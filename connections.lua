local connection_types = {}

local function update_connection(data)
	if data.__valid and connection_types[data.__type] then
		return connection_types[data.__type].on_update(data)
	else
		return nil
	end
end

-- Longest time a connection may be idle
local MAX_PENDING_TIME = 600

-- Called during global initialization
function init_connection_structure()
	global["connections"] = global["connections"] or {}
	for i = 0, MAX_PENDING_TIME-1 do
		global["connections"][i] = global["connections"][i] or {}
	end
end

local function add_connection_to_queue(data)
	local current_pos = game.tick % MAX_PENDING_TIME
	table.insert(global["connections"][current_pos], data)
end

-- Connections are stored in a global circular queue of size MAX_PENDING_TIME
function update_pending_connections()
	local current_pos = game.tick % MAX_PENDING_TIME
	local connections = global["connections"]
	local current_connections = connections[current_pos] or {}
	connections[current_pos] = {}
	for _, data in pairs(current_connections) do
		local wait_time = update_connection(data)
		if wait_time then
			wait_time = math.max(1, math.min(600, math.floor(wait_time)))
			queue_pos = (current_pos + wait_time) % MAX_PENDING_TIME
			table.insert(connections[queue_pos], data)
		else
			destroy_connection(data)
		end
	end
end

function test_for_connection(parent_surface, factory, interior, raw_specs, fx, fy)
	local px = fx + raw_specs.outside_x
	local py = fy + raw_specs.outside_y
	for _, outside_entity in pairs(parent_surface.find_entities_filtered{area = {{px-0.2, py-0.2},{px+0.2, py+0.2}}}) do
		if outside_entity.unit_number then
			for type, methods in pairs(connection_types) do
				local data = methods.accepts_outside_entity(
					outside_entity, factory, interior, {
						outside_pos = {x = px, y = py},
						inside_pos = {x = raw_specs.inside_x, y = raw_specs.inside_y},
						direction_in = raw_specs.direction_in,
						direction_out = raw_specs.direction_out,
					}
				)
				if data then
					data.__valid = true
					data.__type = type
					add_connection_to_queue(data)
					return data
				end
			end
		end
	end
	return nil
end

function destroy_connection(data)
	if data.__valid and connection_types[data.__type] then
		connection_types[data.__type].on_destroy(data)
		data.__valid = false
	end
end

-- Interface to allow mods to add custom connection types.
-- Methods in this interface should be called, once per connection type, directly from control.lua or dependencies, NOT from inside any callbacks such as on_init or on_event.
remote.add_interface("factorissimo_connections",
	{
		["register_connection_type"] = function(type, methods)
			-- See below for calls
			connection_types[type] = {
				accepts_outside_entity = methods.accepts_outside_entity or function() return nil; end,
				on_update = methods.on_update or function() return nil; end,
				on_destroy = methods.on_destroy or function() return; end,
			}
		end,
	}
)

remote.call("factorissimo_connections", "register_connection_type",
	"belt",
	{
	
		-- This function is given an entity that was placed on an outside port and must decide whether the entity is acceptable for this connection type.
		-- If the entity is accepted, this function must establish a connection and return a data table containing all the relevant connection information, otherwise this function must return nil.
		-- Arguments:
		--   outside_entity: The entity to inspect.
		--   factory: The factory it is trying to connect to.
		--   interior: The surface for the factory interior.
		--   conn_specs: Connection specification. This is a table with the following fields:
		--     outside_pos: The half-integer coordinates of the outside port position on the outside surface, available as factory.surface.
		--     inside_pos: The half-integer coordinates of the inside port position on the inside surface, available as interior.
		--     direction_in: Inwards-pointing direction.
		--     direction_out: Outwards-pointing direction. Opposite of direction_in, for your convenience.
		accepts_outside_entity = function(outside_entity, factory, interior, conn_specs)
			local inside_entity = nil
			local inwards = false
			if outside_entity.type == "transport-belt" then
				if outside_entity.direction == conn_specs.direction_in or outside_entity.direction == conn_specs.direction_out then
					inside_entity = interior.create_entity{name = outside_entity.name, position = conn_specs.inside_pos, force = factory.force, direction = outside_entity.direction}
					inwards = (outside_entity.direction == conn_specs.direction_in)
				else
					return nil
				end
			else
				return nil
			end
			if not inside_entity then return nil end
			outside_entity.rotatable = false
			inside_entity.rotatable = false
			inside_entity.minable = false
			inside_entity.destructible = false
			inside_entity.operable = false
			data = {
				outside = outside_entity, inside = inside_entity,
				belt_speed = outside_entity.prototype.belt_speed
			}
			if inwards then
				data.from = data.outside
				data.to = data.inside
			else
				data.from = data.inside
				data.to = data.outside
			end
			return data
		end,
		
		-- This function is called repeatedly to update an established connection. It is called once directly after the connection is created, and must return the amount of ticks until the next update as an integer between 1 and 600 inclusive. If false or nil is returned instead, then the connection will be deleted, after a call to on_destroy (see below).
		-- Arguments:
		--   data: The connection data table created in accepts_outside_entity. It can be modified at will inside this function.
		on_update = function(data)
			if data.from.valid and data.to.valid then
				local f1 = data.from.get_transport_line(1)
				local t1 = data.to.get_transport_line(1)
				local active = false
				for t, c in pairs(f1.get_contents()) do
					if t1.insert_at(0.75, {name = t, count = 1}) then
						f1.remove_item{name = t, count = 1}
						active = true
					end
				end
				local f2 = data.from.get_transport_line(2)
				local t2 = data.to.get_transport_line(2)
				for t, c in pairs(f2.get_contents()) do
					if t2.insert_at(0.75, {name = t, count = 1}) then -- TODO batching
						f2.remove_item{name = t, count = 1}
						active = true
					end
				end
				
				-- data.belt_speed is in tiles per tick
				-- 9/32 tiles per item
				-- Wait for amount of ticks per item
				--if active then
					return (9/32)/data.belt_speed
				--else
				--	return 3*(9/32)/data.belt_speed
				--end
			else
				return false -- The belts are broken, so we destroy the connection.
			end
		end,
		
		-- This function is called whenever a connection is broken, either when on_update returns false or nil, or when the factory is picked up or destroyed. All entities created as part of this connection must be destroyed here.
		-- Arguments:
		--   data: The connection data table created in accepts_outside_entity.
		on_destroy = function(data)
			if data.inside.valid then data.inside.destroy() end
		end,
	}
)

remote.call("factorissimo_connections", "register_connection_type",
	"pipe",
	{	
		accepts_outside_entity = function(outside_entity, factory, interior, conn_specs)
			local inside_entity = nil
			if outside_entity.type == "pipe" then
				inside_entity = interior.create_entity{name = outside_entity.name, position = conn_specs.inside_pos, force = factory.force}
				if not inside_entity then return nil end
			elseif outside_entity.type == "pipe-to-ground" and outside_entity.direction == conn_specs.direction_in then
				inside_entity = interior.create_entity{name = outside_entity.name, position = conn_specs.inside_pos, force = factory.force, direction = outside_entity.direction}
				if not inside_entity then return nil end
				outside_entity.rotatable = false
				inside_entity.rotatable = false
			else
				return nil
			end
			inside_entity.minable = false
			inside_entity.destructible = false
			inside_entity.operable = false
			data = {
				outside = outside_entity, inside = inside_entity,
			}
			return data
		end,
		
		on_update = function(data)
			if data.outside.valid and data.inside.valid then
				fluid1 = data.outside.fluidbox[1]
				fluid2 = data.inside.fluidbox[1]
				if fluid1 and fluid2 then
					if fluid1.type == fluid2.type then
						local amount = fluid1.amount + fluid2.amount
						local temperature = (fluid1.amount*fluid1.temperature+fluid2.amount*fluid2.temperature)/amount -- Total temperature balance
						data.outside.fluidbox[1] = {type = fluid1.type, amount=amount/2, temperature=temperature}
						data.inside.fluidbox[1] = {type = fluid1.type, amount=amount/2, temperature=temperature}
					end
				elseif fluid1 or fluid2 then
					fluid = fluid1 or fluid2
					fluid.amount = fluid.amount/2
					data.outside.fluidbox[1] = fluid
					data.inside.fluidbox[1] = fluid
				end
				return 1
			else
				return false
			end
		end,
		
		on_destroy = function(data)
			if data.inside.valid then data.inside.destroy() end
		end,
	}
)
