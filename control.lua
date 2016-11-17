if not factorissimo then factorissimo = {} end
if not factorissimo.config then factorissimo.config = {} end

require("config")
require("updates")
require("layouts")
require("connections")

-- GLOBALS --

function glob_init()
	global["health-data"] = global["health-data"] or {}

	global["surfaces"] = global["surfaces"] or {}
	global["structures"] = global["structures"] or {}
	global["entity-structures"] = global["entity-structures"] or {}
	global["factory-structures"] = global["entity-structures"] or {}
	init_connection_structure()
end

script.on_init(function()
	glob_init()
	init_update_system()
end)

script.on_configuration_changed(function(configuration_changed_data)
	glob_init()
	do_required_updates()
end)

-- SETTINGS --

local DEBUG = false

local LAYOUT = layouts()

local CHUNK_SIZE = 64

-- FACTORY WORLD ASSIGNMENT --

function maybe_create_surface(layout)
	local name = "factorissimo " .. layout.name
	local surface = game.surfaces[name]
	if surface then
		return surface
	else
		return create_surface(layout, name)
	end
end

function create_surface(layout, surface_name)
	local surface = game.create_surface(surface_name, {
		width = 2,
		height = 2,
	})

	global["surfaces"][surface_name] = {
		layout_name = layout.name,
		chunks_generated = 0,
		chunks_required = 4, -- based on width+height above
		chunks_finished = false
	}

	surface.request_to_generate_chunks({0, 0}, 1)
	reset_daytime(surface)
	return surface
end

function create_structure(factory, layout, surface)
	local structure_index = next_structure_index(layout)
	local structure_name = layout.name .. "_" .. structure_index
	dbg("creating " .. structure_name)
	local offset = calculate_offset(layout, structure_index)

	local structure = {
		name = structure_name,
		layout_name = layout.name,
		index = structure_index,
		factory = factory,
		surface = surface,
		surface_details = get_surface_details(surface),
		ticks = 0,
		connections = {},
		finished = false,

		offset = offset,
		exit = {
			x = factory.position.x+layout.exit_x,
			y = factory.position.y+layout.exit_y,
			surface = factory.surface,
		},
		entrance = {
			x = layout.entrance_x + offset.tile_x,
			y = layout.entrance_y + offset.tile_y,
			surface = surface,
		},
	}
	global["structures"][structure_name] = structure
	set_factory_structure(factory, structure)
end

function connect_factory_to_existing_surface(factory, surface)
	global["factory-surface"][factory.unit_number] = surface
	global["surface-structure"][surface.name].factory = factory
	local layout = get_layout(surface)
	global["surface-exit"][surface.name] = {x = factory.position.x+layout.exit_x, y = factory.position.y+layout.exit_y, surface = factory.surface}
end

-- If this function gets slow, it should probably start using
-- global sequence numbers and just incrementing them.
-- Might want to change the name to claim_next_structure_index at that point.
--
-- On the other hand, by the time this starts getting slow, the per-tick
-- code will probably need optimisation anyway.  And this is run rarely.
function next_structure_index(layout)
	max_index = 0
	for structure_name, structure in pairs(get_all_structures()) do
		if structure.layout_name == layout.name and structure.index > max_index then
			max_index = structure.index
		end
	end
	dbg("max structure index for " .. layout.name .. ": " .. max_index)
	return max_index + 1
end

function calculate_offset(layout, index)
	-- Initial offsets are linear, left to right.
	-- TODO: Use either modulo-eight compass bearings,
	--       or a square-/root-based X+Y system.
	local chunk_x = (index - 1) * layout.chunk_radius * 4
	local chunk_y = 0
	dbg("offset: x = " .. chunk_x .. ", y = " .. chunk_y)
	return {
		chunk_x = chunk_x,
		chunk_y = chunk_y,
		tile_x = CHUNK_SIZE * chunk_x,
		tile_y = CHUNK_SIZE * chunk_y,
	}
end

--function has_surface(factory)
--	return global["factory-surface"][factory.unit_number] ~= nil
--end

function is_factory_surface(surface)
	return global["surfaces"][surface.name] ~= nil
end

function get_factory_structure(factory)
	return global["factory-structures"][factory.unit_number]
end
function set_factory_structure(factory, structure)
	global["factory-structures"][factory.unit_number] = structure
end

function get_entity_structure(entity)
	return global["entity-structures"][entity.unit_number]
end
function set_entity_structure(entity, structure)
	global["entity-structures"][entity.unit_number] = structure
end

function get_all_structures()
	return global["structures"]
end

function get_surface_details(surface)
	return global["surfaces"][surface.name]
end

function get_surface_layout(surface)
	local surface_details = get_surface_details(surface)
	if surface_details then
		return LAYOUT[surface_details.layout_name]
	else
		return nil
	end
end

function get_structure_layout(structure)
	return LAYOUT[structure.surface_details.layout_name]
end

function get_layout_by_name(surface_name)
	if global["surface-layout"][surface_name] then
		return LAYOUT[global["surface-layout"][surface_name]]
	else
		return nil
	end
end

function save_health_data(factory)
	i = 1
	while global["health-data"][i] do
	i = i + 1
	end
	if i > factory.prototype.max_health-1 then
		for _, player in pairs(game.players) do
			player.print("You have picked up too many factories at once. Tell the dev about this, he'll be impressed and slightly worried.")
		end
	else
		if i > factory.prototype.max_health-100 then
			for _, player in pairs(game.players) do
				player.print("Approaching factory pickup limit. What are you doing with all these factories in your inventory?")
			end
		end
		global["health-data"][i] = {
			surface = get_surface(factory),
			health = factory.health,
			backer_name = factory.backer_name,
			energy = factory.energy,
		}
		factory.health = i
		dbg("Saved factory to health value " .. i)
	end
end

function get_and_delete_health_data(health)
	local health_int = math.floor(health+0.5)
	local data = global["health-data"][health_int]
	global["health-data"][health_int] = nil
	return data
end

-- FACTORY INTERIOR GENERATION --

-- Daytime values: 0 is eternal night, 1 is regular, 2 is eternal day
function reset_daytime(surface)
	local daytime = 0
	local layout = get_surface_layout(surface)
	if not layout then return end
	if layout.is_power_plant then
		daytime = factorissimo.config.power_plant_daytime
	else
		daytime = factorissimo.config.factory_daytime
	end
	if daytime == 2 then
		surface.daytime = 0 -- Midday
		surface.freeze_daytime(true)
	elseif daytime == 0 then
		surface.daytime = 0.5 -- Midnight
		surface.freeze_daytime(true)
	else
		surface.daytime = game.surfaces["nauvis"].daytime
		surface.freeze_daytime(false)
	end
end

function add_tile_rect(tiles, tile_name, xmin, ymin, xmax, ymax, offset) -- tiles is rw
	local i = #tiles
	for x = xmin, xmax-1 do
		for y = ymin, ymax-1 do
			i = i + 1
			tiles[i] = {name = tile_name, position = {
				x + offset.tile_x,
				y + offset.tile_y,
			}}
		end
	end
end

function place_entity(surface, entity_name, x, y, force, direction)
	entity = surface.create_entity{name = entity_name, position = {x, y}, force = force, direction = direction}
	if entity then
		entity.minable = false
		entity.rotatable = false
		entity.destructible = false
	end
	return entity
end


-- TODO merge with place_entity?
function place_entity_generated(structure, entity_name, x, y, structure_key)
	local surface = structure.surface
	local entity = surface.create_entity{
		name = entity_name,
		position = {
			x + structure.offset.tile_x,
			y + structure.offset.tile_y,
		},
		force = structure.factory.force,
	}
	if entity then
		entity.minable = false
		entity.rotatable = false
		entity.destructible = false
		if structure_key and entity then
			dbg("Placed and registered " .. structure_key)
			structure[structure_key] = entity
		end
	end
	return entity
end

function build_factory_interior(structure)
	dbg("build_factory_interior")
	local surface = structure.surface
	local layout = get_structure_layout(structure)

	tiles = {}
	for _, pconn in pairs(layout.possible_connections) do
		add_tile_rect(tiles, "factory-wall", pconn.inside_x-1, pconn.inside_y-1, pconn.inside_x+2, pconn.inside_y+2, structure.offset)
	end
	for _, rect in pairs(layout.rectangles) do
		add_tile_rect(tiles, rect.tile, rect.x1, rect.y1, rect.x2, rect.y2, structure.offset)
	end
	for _, pconn in pairs(layout.possible_connections) do
		add_tile_rect(tiles, "factory-entrance", pconn.inside_x, pconn.inside_y, pconn.inside_x+1, pconn.inside_y+1, structure.offset)
	end
	surface.set_tiles(tiles)
	if layout.is_power_plant then
		place_entity_generated(structure, "factory-power-receiver", layout.provider_x, layout.provider_y, "power_provider")
	else
		place_entity_generated(structure, "factory-power-provider", layout.provider_x, layout.provider_y, "power_provider")
	end

	-- We use this for the exit, so we register it in a lookup table.
	-- TODO: Maybe create an exit sign and use that instead?
	local distributor = place_entity_generated(structure, "factory-power-distributor", layout.distributor_x, layout.distributor_y)
	set_entity_structure(distributor, structure)

	structure.finished = true
end

script.on_event(defines.events.on_chunk_generated, function(event)
	local details = get_surface_details(event.surface)
	if details and not details.chunks_finished then
		-- Wait until all chunks are generated and then some, to avoid other mods' worldgen interfering
		details.chunks_generated = details.chunks_generated + 1
		dbg("chunks generated: " .. details.chunks_generated)
		if details.chunks_generated >= details.chunks_required then
			details.chunks_finished = true
			dbg("chunks finished!")
		end
	end
end)


-- PLACING, PICKING UP FACTORIES

function on_built_factory(factory)
	factory.rotatable = false
	health_data = get_and_delete_health_data(factory.health)
	if health_data then
		connect_factory_to_existing_surface(factory, health_data.surface)
		for k, v in pairs(health_data) do
			if k ~= "surface" then
				factory[k] = v
			end
		end
		mark_connections_dirty(factory)

	else
		dbg("Generating new factory interior")
		local layout = LAYOUT[factory.name]
		local surface = maybe_create_surface(factory, layout)
		create_structure(factory, layout, surface)
		factory.energy = 0
	end
end

 -- Workaround to not really being able to store information in a deconstructed entity:
 -- I store the factory information in the factory item by modifying its health value right before it is picked up, and storing all relevant
 -- information in a global table indexed by the new unique health value (including the factory's actual health). When the damaged factory item is
 -- placed down again, I look for its health value in the table and retrieve the information from there, restoring its name, health,
 -- stored energy, and most importantly the link to the surface acting as its interior.
 -- This has the neat side effect of making initialized factories non-stackable.
 -- However things may break a little if some other mod has the bright idea of changing health values of my items,
 -- or aborting factory deconstruction, or, well, you get the point.


function on_picked_up_factory(factory)
	save_health_data(factory)
	local structure = get_structure(get_surface(factory))
	for _, data in pairs(structure.connections) do
		destroy_connection(data)
	end
	structure.connections = {}
end

script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(event)
	local entity = event.created_entity
	if LAYOUT[entity.name] then -- entity is factory
		on_built_factory(entity)
	else
		-- Entity needs to update factory connections
		local entities = entity.surface.find_entities_filtered{area = {{entity.position.x-5, entity.position.y-5},{entity.position.x+5, entity.position.y+5}}} -- Generous search radius, maybe too generous
		for _, entity2 in pairs(entities) do
			local structure = get_factory_structure(entity2)
			if structure then
				mark_structure_connections_dirty(structure)
			end
		end
	end
end)

script.on_event({defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined}, function(event)
	local factory = event.entity
	if LAYOUT[factory.name] then
		on_picked_up_factory(factory)
	end
end)

script.on_event({defines.events.on_entity_died}, function(event)
	local factory = event.entity
	if LAYOUT[factory.name] then
		local structure = get_structure(get_surface(factory))
		for _, data in pairs(structure.connections) do
			destroy_connection(data)
		end
		structure.connections = {}
	end
end)


-- FACTORY MECHANICS

function balance_power(from, to, multiplier)
	local max_transfer_energy = math.min(from.energy, to.electric_buffer_size - to.energy)
	from.energy = from.energy - max_transfer_energy
	to.energy = to.energy + max_transfer_energy * multiplier
end

function mark_structure_connections_dirty(structure)
	structure.connections_dirty = true
end

local function check_connections(factory, surface, structure, layout, parent_surface)
	for id, pconn in pairs(layout.possible_connections) do
		data = structure.connections[id]
		
		if data then
			if not update_connection(data) then
				destroy_connection(data)
			end
			if not data.__valid then
				data = nil
				structure.connections[id] = nil
			end
		elseif factory_placement_valid(surface, parent_surface) then
			local fx = structure.factory.position.x
			local fy = structure.factory.position.y
			structure.connections[id] = test_for_connection(parent_surface, factory, surface, pconn, structure.offset, fx, fy)
		end
	end
end

script.on_event(defines.events.on_tick, function(event)
	-- PLAYER TRANSFER
	for _, player in pairs(game.players) do
		if player.connected and player.character and player.vehicle == nil then
			try_enter_factory(player)
			try_leave_factory(player)
		end
	end
	
	-- CONNECTIONS
	update_pending_connections()

	-- BASE FACTORY MECHANICS
	for structure_name, structure in pairs(get_all_structures()) do
		if not (structure.factory and structure.factory.valid) then
			-- skip it
		elseif structure.finished then -- Don't do anything before the interior has finished generating
		
			structure.ticks = (structure.ticks or 0) + 1
		
			local surface = structure.surface
			local parent_surface = structure.factory.surface
			local layout = get_structure_layout(structure)
			
			-- TRANSFER POWER
			if structure.power_provider and structure.power_provider.valid then
				if layout.is_power_plant then
					balance_power(structure.power_provider, structure.factory, factorissimo.config.power_output_multiplier)
				else
					balance_power(structure.factory, structure.power_provider, factorissimo.config.power_input_multiplier)
				end
			end
			
			-- TRANSFER POLLUTION
			if structure.ticks % 60 < 1 then
				local exit_pos = structure.exit
				for y = -1,1,2 do
					for x = -1,1,2 do
						local pollution = surface.get_pollution({x, y})
						surface.pollute({x, y}, -pollution/2)
						parent_surface.pollute({exit_pos.x, exit_pos.y}, (pollution/2) * factorissimo.config.pollution_multiplier)
					end
				end
			end
			
			-- CHECK FOR NEW CONNECTIONS
			if structure.connections_dirty then
				structure.connections_dirty = false
				check_connections(structure.factory, surface, structure, layout, parent_surface)
			end
		elseif not structure.surface_details.chunks_finished then
			-- Don't do anything until the global surface has finished default worldgen.
			-- Should only happen for the first factory of each layout.
		else
			-- Create the interior for our structure
			build_factory_interior(structure)
			-- This can theoretically be called repeatedly each tick until the factory is marked finished
			if structure.finished then
				-- Check connections once the factory is finished
				mark_structure_connections_dirty(structure)
			end
		end
	end
end)

-- RECURSION

function factory_placement_valid(inner_surface, outer_surface)
--	if is_factory(inner_surface) and is_factory(outer_surface) then
--		local inner_tier = get_layout(inner_surface).tier or 0
--		local outer_tier = get_layout(outer_surface).tier or 0
--		if factorissimo.config.recursion == 0 then return false end
--		if factorissimo.config.recursion == 1 then return inner_tier < outer_tier end
--		if factorissimo.config.recursion == 2 then return inner_tier <= outer_tier end
--		return true
--	end
	return true
end

-- ENTERING/LEAVING FACTORIES

function get_factory_beneath(player)
	local entities = player.surface.find_entities_filtered{area = {{player.position.x-0.2, player.position.y-0.3},{player.position.x+0.2, player.position.y}}}
	for _, entity in pairs(entities) do
		if LAYOUT[entity.name] then
			return entity
		end
	end
	return nil
end

function get_exit_beneath(player)
	-- Depends on location of power distributor!
	local entities = player.surface.find_entities_filtered{area={{player.position.x+2, player.position.y-3},{player.position.x+6, player.position.y-2}}, name="factory-power-distributor"}
	return entities[1]
end

function try_enter_factory(player)
	local factory = get_factory_beneath(player)
	if factory and math.abs(factory.position.x-player.position.x) < 0.6 then
		local structure = get_factory_structure(factory)
		local new_surface = structure.surface
		if structure.finished and factory_placement_valid(new_surface, factory.surface) then
			dbg("Entering structure: " .. structure.name)
			reset_daytime(new_surface)
			player.teleport({structure.entrance.x, structure.entrance.y}, new_surface)
			return
		end
	end
end

function try_leave_factory(player)
	local exit_entity = get_exit_beneath(player)
	if exit_entity then
		local structure = get_entity_structure(exit_entity)
		if structure then
			dbg("Exiting structure: " .. structure.name)
			player.teleport({structure.exit.x, structure.exit.y}, structure.exit.surface)
			return
		end
	end
end

-- DEBUGGING

if DEBUG then
	script.on_event(defines.events.on_player_created, function(event)
		local player = game.players[event.player_index]
		player.insert{name="small-factory", count=10}
		player.insert{name="express-transport-belt", count=200}
		player.insert{name="steel-axe", count=10}
		player.insert{name="medium-electric-pole", count=100}
		player.cheat_mode = true
		--player.gui.top.add{type="button", name="enter-factory", caption="Enter Factory"}
		--player.gui.top.add{type="button", name="leave-factory", caption="Leave Factory"}
		player.gui.top.add{type="button", name="debug", caption="Debug"}
		player.force.research_all_technologies()
	end)
end

script.on_event(defines.events.on_gui_click, function(event)
	local player = game.players[event.player_index]
	if event.element.name == "enter-factory" then
		try_enter_factory(player)
	end
	if event.element.name == "leave-factory" then
		try_leave_factory(player)
	end
	if event.element.name == "debug" then
		debug_this(player)
	end
end)

function dbg(text)
	if DEBUG then
		game.players[1].print(text)
	end
end

function debug_this(player)
	if player.connected then
		if player.character then
			dbg("Player character: " .. player.character.name)
		else
			dbg("Player missing character")
		end
	else
		return
	end
	local i = 0
	local entities = player.surface.find_entities_filtered{area = {{player.position.x-3, player.position.y-3},{player.position.x+3, player.position.y+3}}}
	for _, entity in pairs(entities) do
		if entity.unit_number then
			i = i + 1
			player.print("(" .. i .. ") Entity: " .. entity.name)
			player.print("(" .. i .. ") Buffer size: " .. (entity.electric_buffer_size or "-"))
			player.print("(" .. i .. ") Energy: " .. (entity.energy or "-"))
			player.print("(" .. i .. ") Health: " .. (entity.health or "-"))
		end
	end
end
