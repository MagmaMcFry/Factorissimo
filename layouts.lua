-- Factory layouts

-- Constructor functions
local function make_rectangle(tile, x1, y1, w, h)
	return { x1 = x1, x2 = x1 + w, y1 = y1, y2 = y1 + h, tile = tile }
end

local function floor_size_border(radius)
	local corner, size = -1 - radius, 2 * radius + 2
	return make_rectangle("factory-wall", corner, corner, size, size)
end

local function floor_size(radius)
	local corner, size = -radius, 2 * radius
	return make_rectangle("factory-floor", corner, corner, size, size)
end

local function device_border_at(x, y)
	return make_rectangle("factory-wall", x - 2, y - 2, 4, 4)
end

local function entrance_border_at(direction, radius)
	local result
	if direction == defines.direction.north then
		result = make_rectangle("factory-wall", -3, radius, 6, 4)
	elseif direction == defines.direction.south then
		result = make_rectangle("factory-wall", -3, -4 - radius, 6, 4)
	elseif direction == defines.direction.east then
		result = make_rectangle("factory-wall", radius, -3, 4, 6)
	elseif direction == defines.direction.west then
		result = make_rectangle("factory-wall", -4 - radius, -3, 4, 6)
	end
	return result
end

local function entrance_at(direction, radius)
	local result
	if direction == defines.direction.north then
		result = make_rectangle("factory-entrance", -2, radius, 4, 3)
	elseif direction == defines.direction.south then
		result = make_rectangle("factory-entrance", -2, -3 - radius, 4, 3)
	elseif direction == defines.direction.east then
		result = make_rectangle("factory-entrance", radius, -2, 3, 4)
	elseif direction == defines.direction.west then
		result = make_rectangle("factory-entrance", -3 - radius, -2, 3, 4)
	end
	return result
end

local function connection_border_at(x, y)
	return make_rectangle("factory-wall", math.floor(x) - 1, math.floor(y) - 1, 3, 3)
end

local function connection_at(x, y)
	return make_rectangle("factory-entrance", math.floor(x), math.floor(y), 1, 1)
end

local function make_constructor(size)
	local constructor = {
		rectangles = {},
		provider_x = -9,
		provider_y = size * 6 + 2,
		distributor_x = 9,
		distributor_y = size * 6 + 2
	}
	local radius = size * 6
	table.insert(constructor.rectangles, floor_size_border(radius))
	table.insert(constructor.rectangles, entrance_border_at(defines.direction.north, radius))
	table.insert(constructor.rectangles, entrance_border_at(defines.direction.south, radius))
	table.insert(constructor.rectangles, entrance_border_at(defines.direction.east, radius))
	table.insert(constructor.rectangles, entrance_border_at(defines.direction.west, radius))
	table.insert(constructor.rectangles, device_border_at(constructor.provider_x, constructor.provider_y))
	table.insert(constructor.rectangles, device_border_at(constructor.distributor_x, constructor.distributor_y))
	for c1 = 4.5 - radius, radius - 4.5, 9 do
		table.insert(constructor.rectangles, connection_border_at(-0.5 - radius, c1))
		table.insert(constructor.rectangles, connection_border_at(radius + 0.5, c1))
		table.insert(constructor.rectangles, connection_border_at(c1, -0.5 - radius))
		table.insert(constructor.rectangles, connection_border_at(c1, radius + 0.5))
	end
	table.insert(constructor.rectangles, floor_size(radius))
	table.insert(constructor.rectangles, entrance_at(defines.direction.north, radius))
	table.insert(constructor.rectangles, entrance_at(defines.direction.south, radius))
	table.insert(constructor.rectangles, entrance_at(defines.direction.east, radius))
	table.insert(constructor.rectangles, entrance_at(defines.direction.west, radius))
	for c1 = 4.5 - radius, radius - 4.5, 9 do
		table.insert(constructor.rectangles, connection_at(-0.5 - radius, c1))
		table.insert(constructor.rectangles, connection_at(radius + 0.5, c1))
		table.insert(constructor.rectangles, connection_at(c1, -0.5 - radius))
		table.insert(constructor.rectangles, connection_at(c1, radius + 0.5))
	end
	return constructor
end

-- Constructor table
local constructors = {
	small = make_constructor(3) -- size of n corresponds to a factory with 2nX2n external footprint, 6n - 6 connection points and 12nX12n internal construction area
}

-- Connection functions

local function make_connection(direction, index, size, void)
	local result
	local radius = size * 6
	if direction == defines.direction.north then
		result = {
			outside_x = -2.5 + index,
			outside_y = -0.5 - size,
			inside_x = index * 9 - radius - 4.5,
			inside_y = -0.5 - radius
		}
	elseif direction == defines.direction.south then
		result = {
			outside_x = -2.5 + index,
			outside_y = 0.5 + size,
			inside_x = index * 9 - radius - 4.5,
			inside_y = 0.5 + radius
		}
	elseif direction == defines.direction.east then
		result = {
			outside_x = 0.5 + size,
			outside_y = -2.5 + index,
			inside_x = 0.5 + radius,
			inside_y = index * 9 - radius - 4.5
		}
	elseif direction == defines.direction.west then
		result = {
			outside_x = -0.5 - size,
			outside_y = -2.5 + index,
			inside_x = -0.5 - radius,
			inside_y = index * 9 - radius - 4.5
		}
	end
	if result then -- should always exist, but just to be safe
		if void then
			result.direction_in = -1 -- should never match direction
			result.direction_out = -1 -- should never match direction
		else
			result.direction_in = (direction + 4) % 8
			result.direction_out = direction
		end
	end
	return result
end

local function make_connections(size, void)
	local result = {}
	for i = 1, size * 2 - 2 do
		result["t" .. i] = make_connection(defines.direction.north, i, size, void)
		result["r" .. i] = make_connection(defines.direction.east, i, size, void)
		result["b" .. i] = make_connection(defines.direction.south, i, size, void)
		result["l" .. i] = make_connection(defines.direction.west, i, size, void)
	end
	return result
end

-- Connection table
local connections = {
	small = make_connections(3),
	small_void = make_connections(3, true)
}

local directionals = {
	small_north = {
		direction = "north",
		entrance_x = 0,
		entrance_y = 20,
		exit_x = 0,
		exit_y = 3,
		possible_connections = {
			connections["small"]["l1"],
			connections["small"]["l2"],
			connections["small"]["l3"],
			connections["small"]["l4"],
			connections["small"]["t1"],
			connections["small"]["t2"],
			connections["small"]["t3"],
			connections["small"]["t4"],
			connections["small"]["r1"],
			connections["small"]["r2"],
			connections["small"]["r3"],
			connections["small"]["r4"],
			connections["small_void"]["b1"],
			connections["small_void"]["b2"],
			connections["small_void"]["b3"],
			connections["small_void"]["b4"]
		},
		gates = {
			{ x = -1.5, y = 21.5 },
			{ x = -0.5, y = 21.5 },
			{ x = 0.5, y = 21.5 },
			{ x = 1.5, y = 21.5 }
		}
	},
	small_south = {
		direction = "south",
		entrance_x = 0,
		entrance_y = -20,
		exit_x = 0,
		exit_y = -3,
		possible_connections = {
			connections["small"]["l1"],
			connections["small"]["l2"],
			connections["small"]["l3"],
			connections["small"]["l4"],
			connections["small_void"]["t1"],
			connections["small_void"]["t2"],
			connections["small_void"]["t3"],
			connections["small_void"]["t4"],
			connections["small"]["r1"],
			connections["small"]["r2"],
			connections["small"]["r3"],
			connections["small"]["r4"],
			connections["small"]["b1"],
			connections["small"]["b2"],
			connections["small"]["b3"],
			connections["small"]["b4"]
		},
		gates = {
			{ x = -1.5, y = -21.5 },
			{ x = -0.5, y = -21.5 },
			{ x = 0.5, y = -21.5 },
			{ x = 1.5, y = -21.5 }
		}
	},
	small_east = {
		direction = "east",
		entrance_x = -20,
		entrance_y = 0,
		exit_x = -3,
		exit_y = 0,
		possible_connections = {
			connections["small_void"]["l1"],
			connections["small_void"]["l2"],
			connections["small_void"]["l3"],
			connections["small_void"]["l4"],
			connections["small"]["t1"],
			connections["small"]["t2"],
			connections["small"]["t3"],
			connections["small"]["t4"],
			connections["small"]["r1"],
			connections["small"]["r2"],
			connections["small"]["r3"],
			connections["small"]["r4"],
			connections["small"]["b1"],
			connections["small"]["b2"],
			connections["small"]["b3"],
			connections["small"]["b4"]
		},
		gates = {
			{ x = -21.5, y = -1.5 },
			{ x = -21.5, y = -0.5 },
			{ x = -21.5, y = 0.5 },
			{ x = -21.5, y = 1.5 }
		}
	},
	small_west = {
		direction = "west",
		entrance_x = 20,
		entrance_y = 0,
		exit_x = 3,
		exit_y = 0,
		possible_connections = {
			connections["small"]["l1"],
			connections["small"]["l2"],
			connections["small"]["l3"],
			connections["small"]["l4"],
			connections["small"]["t1"],
			connections["small"]["t2"],
			connections["small"]["t3"],
			connections["small"]["t4"],
			connections["small_void"]["r1"],
			connections["small_void"]["r2"],
			connections["small_void"]["r3"],
			connections["small_void"]["r4"],
			connections["small"]["b1"],
			connections["small"]["b2"],
			connections["small"]["b3"],
			connections["small"]["b4"]
		},
		gates = {
			{ x = 21.5, y = -1.5 },
			{ x = 21.5, y = -0.5 },
			{ x = 21.5, y = 0.5 },
			{ x = 21.5, y = 1.5 }
		}
	}
}

local LAYOUT = {
	["small-factory"] = {
		name = "small-factory",
		constructor = constructors["small"],
		provider_x = -4,
		provider_y = 20,
		distributor_x = 4,
		distributor_y = 20,
		tier = 0,
		chunk_radius = 1,
		is_power_plant = false,
		north = directionals["small_north"],
		south = directionals["small_south"],
		east = directionals["small_east"],
		west = directionals["small_west"]
	},
	["small-power-plant"] = {
		name = "small-power-plant",
		constructor = constructors["small"],
		provider_x = -4,
		provider_y = 20,
		distributor_x = 4,
		distributor_y = 20,
		tier = 0,
		chunk_radius = 1,
		is_power_plant = true,
		north = directionals["small_north"],
		south = directionals["small_south"],
		east = directionals["small_east"],
		west = directionals["small_west"]
	}
}

return LAYOUT