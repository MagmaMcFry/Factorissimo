if not factorissimo then factorissimo = {} end
if not factorissimo.config then factorissimo.config = {} end

require("config")
require("updates")
require("layouts")
require("connections")

-- GLOBALS --

function glob_init()
	global["factory-surface"] = global["factory-surface"] or {}
	global["surface-structure"] = global["surface-structure"] or {}
	global["surface-layout"] = global["surface-layout"] or {}
	global["surface-exit"] = global["surface-exit"] or {}
	global["health-data"] = global["health-data"] or {}
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

-- FACTORY WORLD ASSIGNMENT --

function create_surface(factory, layout)
	local surface_name = "Inside factory " .. factory.unit_number
	local surface = game.create_surface(surface_name, {width = 64*layout.chunk_radius-62, height = 64*layout.chunk_radius-62})
	surface.request_to_generate_chunks({0, 0}, layout.chunk_radius)
	global["factory-surface"][factory.unit_number] = surface -- surface_name
	global["surface-structure"][surface_name] = {parent = factory, ticks = 0, connections = {}, chunks_generated = 0, chunks_required = 4*layout.chunk_radius*layout.chunk_radius, finished = false}
	global["surface-layout"][surface_name] = layout.name
	global["surface-exit"][surface_name] = {x = factory.position.x+layout.exit_x, y = factory.position.y+layout.exit_y, surface = factory.surface}
	reset_daytime(surface)
end

function connect_factory_to_existing_surface(factory, surface)
	global["factory-surface"][factory.unit_number] = surface
	global["surface-structure"][surface.name].parent = factory
	local layout = get_layout(surface)
	global["surface-exit"][surface.name] = {x = factory.position.x+layout.exit_x, y = factory.position.y+layout.exit_y, surface = factory.surface}
end

function has_surface(factory)
	return global["factory-surface"][factory.unit_number] ~= nil
end

function get_surface(factory)
	return global["factory-surface"][factory.unit_number]
end

function is_factory(surface)
	return global["surface-structure"][surface.name] ~= nil
end

function get_structure(surface)
	return global["surface-structure"][surface.name]
end

function set_structure(surface, structure_id, entity)
	global["surface-structure"][surface.name][structure_id] = entity
end

function get_all_structures()
	return global["surface-structure"]
end

function get_layout(surface)
	if global["surface-layout"][surface.name] then
		return LAYOUT[global["surface-layout"][surface.name]]
	else
		return nil
	end
end

function get_layout_by_name(surface_name)
	if global["surface-layout"][surface_name] then
		return LAYOUT[global["surface-layout"][surface_name]]
	else
		return nil
	end
end

function get_exit(surface)
	return global["surface-exit"][surface.name]
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
	local layout = get_layout(surface)
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

function delete_entities(surface)
	for _, entity in pairs(surface.find_entities({{-1000, -1000},{1000, 1000}})) do
		entity.destroy()
	end
end

function add_tile_rect(tiles, tile_name, xmin, ymin, xmax, ymax) -- tiles is rw
	local i = #tiles
	for x = xmin, xmax-1 do
		for y = ymin, ymax-1 do
			i = i + 1
			tiles[i] = {name = tile_name, position={x, y}}
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
function place_entity_generated(surface, entity_name, x, y, structure_id)
	entity = surface.create_entity{name = entity_name, position = {x, y}, force = get_structure(surface).parent.force}
	if entity then
		entity.minable = false
		entity.rotatable = false
		entity.destructible = false
		if structure_id and entity then
			dbg("Placed and registered " .. structure_id)
			set_structure(surface, structure_id, entity)
		end
	end
end

function build_factory_interior(factory, surface, layout, structure)
	delete_entities(surface)
	tiles = {}
	for _, pconn in pairs(layout.possible_connections) do
		add_tile_rect(tiles, "factory-wall", pconn.inside_x-1, pconn.inside_y-1, pconn.inside_x+2, pconn.inside_y+2)
	end
	for _, rect in pairs(layout.rectangles) do
		add_tile_rect(tiles, rect.tile, rect.x1, rect.y1, rect.x2, rect.y2)
	end
	for _, pconn in pairs(layout.possible_connections) do
		add_tile_rect(tiles, "factory-entrance", pconn.inside_x, pconn.inside_y, pconn.inside_x+1, pconn.inside_y+1)
	end
	surface.set_tiles(tiles)
	if layout.is_power_plant then
		place_entity_generated(surface, "factory-power-receiver", layout.provider_x, layout.provider_y, "power_provider")
	else
		place_entity_generated(surface, "factory-power-provider", layout.provider_x, layout.provider_y, "power_provider")
	end
	place_entity_generated(surface, "factory-power-distributor", layout.distributor_x, layout.distributor_y)
	structure.finished = true
end

script.on_event(defines.events.on_chunk_generated, function(event)
	if is_factory(event.surface) then
		local structure = get_structure(event.surface)
		structure.chunks_generated = structure.chunks_generated + 1 -- Wait until all chunks are generated and then some, to avoid other mods' worldgen interfering
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

	elseif not has_surface(factory) then -- Should always be the case, but just in case
		dbg("Generating new factory interior")
		local layout = LAYOUT[factory.name]
		create_surface(factory, layout)
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
			if has_surface(entity2) then
				-- entity2 is factory
				mark_connections_dirty(entity2)
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

function mark_connections_dirty(factory)
	local surface = get_surface(factory)
	if not surface then return end
	local structure = get_structure(surface)
	if not structure then return end
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
		end
		if data == nil and factory_placement_valid(surface, parent_surface) then
			local fx = structure.parent.position.x
			local fy = structure.parent.position.y
			structure.connections[id] = test_for_connection(parent_surface, factory, surface, pconn, fx, fy)
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
	for surface_name, structure in pairs(get_all_structures()) do
		if structure.parent and structure.parent.valid and structure.finished then -- Don't do anything before the interior has finished generating
		
			structure.ticks = (structure.ticks or 0) + 1
		
			local surface = get_surface(structure.parent) --game.surfaces[surface_name]
			local parent_surface = structure.parent.surface
			local layout = get_layout(surface)
			
			-- TRANSFER POWER
			if structure.power_provider and structure.power_provider.valid then
				if layout.is_power_plant then
					balance_power(structure.power_provider, structure.parent, factorissimo.config.power_output_multiplier)
				else
					balance_power(structure.parent, structure.power_provider, factorissimo.config.power_input_multiplier)
				end
			end
			
			-- TRANSFER POLLUTION
			if structure.ticks % 60 < 1 then
				local exit_pos = get_exit(surface) 
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
				check_connections(structure.parent, surface, structure, layout, parent_surface)
			end
		elseif structure.parent and structure.parent.valid and structure.chunks_generated == structure.chunks_required then
			-- We need to wait until the factory interior surface is generated with default worldgen, then replace it with our own interior
			local surface = get_surface(structure.parent)
			local layout = get_layout(surface)
			build_factory_interior(structure.parent, surface, layout, structure)
			-- This can theoretically be called repeatedly each tick until the factory is marked finished
			if structure.finished then
				-- Check connections once the factory is finished
				mark_connections_dirty(structure.parent)
			end
		end
	end
end)

-- RECURSION

function factory_placement_valid(inner_surface, outer_surface)
	if is_factory(inner_surface) and is_factory(outer_surface) then
		local inner_tier = get_layout(inner_surface).tier or 0
		local outer_tier = get_layout(outer_surface).tier or 0
		if factorissimo.config.recursion == 0 then return false end
		if factorissimo.config.recursion == 1 then return inner_tier < outer_tier end
		if factorissimo.config.recursion == 2 then return inner_tier <= outer_tier end
		return true
	end
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
		local new_surface = get_surface(factory)
		if new_surface and factory_placement_valid(new_surface, factory.surface) then
			local structure = get_structure(new_surface)
				if structure.finished then
					local layout = get_layout(new_surface)
					reset_daytime(new_surface)
					player.teleport({layout.entrance_x, layout.entrance_y}, new_surface)
					return
				end
		end
	end
end

function try_leave_factory(player)
	local exit_building = get_exit_beneath(player)
	if exit_building then
		local exit_pos = get_exit(player.surface)
		if exit_pos then
			player.teleport({exit_pos.x, exit_pos.y}, exit_pos.surface)
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
