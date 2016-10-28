-- Factory layouts

-- Defines
local SIZE_SMALL = 3
local SIZE_MEDIUM = 6
local SIZE_LARGE = 9
local SIZE_HUGE = 12

local function index_size(size)
	if size == SIZE_SMALL then
		return "small"
	elseif size == SIZE_MEDIUM then
		return "medium"
	elseif size == SIZE_LARGE then
		return "large"
	elseif size == SIZE_HUGE then
		return "huge"
	end
	return nil -- should never happen
end

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

local function get_distributors(size)
	local result
	if size == SIZE_SMALL then -- a single distributor will do
		result = {
			{ x = 9, y = 20 }
		}
	elseif size == SIZE_MEDIUM then -- two needed, one at the top and one at the bottom
		result = {
			{ x = 9, y = 38 },
			{ x = -9, y = -38 }
		}
	elseif size < 15 then -- four needed inside the build area
		result = {
			{x = 45, y = 45 },
			{x = -45, y = -45 },
			{x = 45, y = -45 },
			{x = -45, y = 45 }
		}
	end -- size 12 is probably large enough for now (144 X 144 build area, 48 connection points) 
	return result
end

local function make_constructor(size)
	local radius = size * 6
	local constructor = {
		rectangles = {},
		provider_x = -9,
		provider_y = radius + 2,
		distributors = get_distributors(size)
	}
	table.insert(constructor.rectangles, floor_size_border(radius))
	table.insert(constructor.rectangles, entrance_border_at(defines.direction.north, radius))
	table.insert(constructor.rectangles, entrance_border_at(defines.direction.south, radius))
	table.insert(constructor.rectangles, entrance_border_at(defines.direction.east, radius))
	table.insert(constructor.rectangles, entrance_border_at(defines.direction.west, radius))
	table.insert(constructor.rectangles, device_border_at(constructor.provider_x, constructor.provider_y))
	for c1 = 4.5 - radius, radius - 4.5, 9 do
		table.insert(constructor.rectangles, connection_border_at(-0.5 - radius, c1))
		table.insert(constructor.rectangles, connection_border_at(radius + 0.5, c1))
		table.insert(constructor.rectangles, connection_border_at(c1, -0.5 - radius))
		table.insert(constructor.rectangles, connection_border_at(c1, radius + 0.5))
	end
	table.insert(constructor.rectangles, floor_size(radius))
	for _, coords in pairs(constructor.distributors) do
		table.insert(constructor.rectangles, device_border_at(coords.x, coords.y))
	end
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
	small = make_constructor(SIZE_SMALL), -- size of 3n corresponds to a factory with 6nX6n external footprint, 12n connection points and 36nX36n internal construction area
	medium = make_constructor(SIZE_MEDIUM),
	large = make_constructor(SIZE_LARGE),
	huge = make_constructor(SIZE_HUGE)
}

-- Exit functions
local function make_gates(direction, size)
	local result
	local radius = size * 6 + 3.5
	if direction == defines.direction.north then
		result = {
			{ x = -1.5, y = radius },
			{ x = -0.5, y = radius },
			{ x = 0.5, y = radius},
			{ x = 1.5, y = radius }
		}
	elseif direction == defines.direction.south then
		result = {
			{ x = -1.5, y = -radius },
			{ x = -0.5, y = -radius },
			{ x = 0.5, y = -radius},
			{ x = 1.5, y = -radius }
		}
	elseif direction == defines.direction.east then
		result = {
			{ x = -radius, y = -1.5 },
			{ x = -radius, y = -0.5 },
			{ x = -radius, y = 0.5 },
			{ x = -radius, y = 1.5 }
		}
	elseif direction == defines.direction.west then
		result = {
			{ x = radius, y = -1.5 },
			{ x = radius, y = -0.5 },
			{ x = radius, y = 0.5 },
			{ x = radius, y = 1.5 }
		}
	end
	return result
end

-- Connection functions

local function make_connection(direction, index, size, void)
	local result
	local radius = size * 6
	if direction == defines.direction.north then
		result = {
			outside_x = index - math.floor(size * 2 / 3) - 0.5,
			outside_y = -0.5 - size,
			inside_x = index * 9 - radius - 4.5,
			inside_y = -0.5 - radius
		}
	elseif direction == defines.direction.south then
		result = {
			outside_x = index - math.floor(size * 2 / 3) - 0.5,
			outside_y = 0.5 + size,
			inside_x = index * 9 - radius - 4.5,
			inside_y = 0.5 + radius
		}
	elseif direction == defines.direction.east then
		result = {
			outside_x = 0.5 + size,
			outside_y = index - math.floor(size * 2 / 3) - 0.5,
			inside_x = 0.5 + radius,
			inside_y = index * 9 - radius - 4.5
		}
	elseif direction == defines.direction.west then
		result = {
			outside_x = -0.5 - size,
			outside_y = index - math.floor(size * 2 / 3) - 0.5,
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
	for i = 1, math.floor(size * 4 / 3) do
		result["t" .. i] = make_connection(defines.direction.north, i, size, void)
		result["r" .. i] = make_connection(defines.direction.east, i, size, void)
		result["b" .. i] = make_connection(defines.direction.south, i, size, void)
		result["l" .. i] = make_connection(defines.direction.west, i, size, void)
	end
	return result
end

-- Connection table
local connections = {
	small = make_connections(SIZE_SMALL),
	small_void = make_connections(SIZE_SMALL, true),
	medium = make_connections(SIZE_MEDIUM),
	medium_void = make_connections(SIZE_MEDIUM, true),
	large = make_connections(SIZE_LARGE),
	large_void = make_connections(SIZE_LARGE, true),
	huge = make_connections(SIZE_HUGE),
	huge_void = make_connections(SIZE_HUGE, true)
}

-- Directional connections
local function get_possible_connections(direction, size)
	local result = {}
	for i = 1, math.floor(size * 4 / 3) do
		if direction == defines.direction.north then
			table.insert(result, connections[index_size(size) .. "_void"]["b" .. i])
		else
			table.insert(result, connections[index_size(size)]["b" .. i])
		end
		if direction == defines.direction.south then
			table.insert(result, connections[index_size(size) .. "_void"]["t" .. i])
		else
			table.insert(result, connections[index_size(size)]["t" .. i])
		end
		if direction == defines.direction.east then
			table.insert(result, connections[index_size(size) .. "_void"]["l" .. i])
		else
			table.insert(result, connections[index_size(size)]["l" .. i])
		end
		if direction == defines.direction.west then
			table.insert(result, connections[index_size(size) .. "_void"]["r" .. i])
		else
			table.insert(result, connections[index_size(size)]["r" .. i])
		end
	end
	return result
end

-- Directional information table
local directionals = {
	small_north = {
		direction = "north",
		entrance_x = 0,
		entrance_y = 20,
		exit_x = 0,
		exit_y = 3,
		possible_connections = get_possible_connections(defines.direction.north, SIZE_SMALL),
		gates = make_gates(defines.direction.north, SIZE_SMALL)
	},
	small_south = {
		direction = "south",
		entrance_x = 0,
		entrance_y = -20,
		exit_x = 0,
		exit_y = -3,
		possible_connections = get_possible_connections(defines.direction.south, SIZE_SMALL),
		gates = make_gates(defines.direction.south, SIZE_SMALL)
	},
	small_east = {
		direction = "east",
		entrance_x = -20,
		entrance_y = 0,
		exit_x = -3,
		exit_y = 0,
		possible_connections = get_possible_connections(defines.direction.east, SIZE_SMALL),
		gates = make_gates(defines.direction.east, SIZE_SMALL)
	},
	small_west = {
		direction = "west",
		entrance_x = 20,
		entrance_y = 0,
		exit_x = 3,
		exit_y = 0,
		possible_connections = get_possible_connections(defines.direction.west, SIZE_SMALL),
		gates = make_gates(defines.direction.west, SIZE_SMALL)
	},
	medium_north = {
		direction = "north",
		entrance_x = 0,
		entrance_y = 38,
		exit_x = 0,
		exit_y = 6,
		possible_connections = get_possible_connections(defines.direction.north, SIZE_MEDIUM),
		gates = make_gates(defines.direction.north, SIZE_MEDIUM)
	},
	medium_south = {
		direction = "south",
		entrance_x = 0,
		entrance_y = -38,
		exit_x = 0,
		exit_y = -6,
		possible_connections = get_possible_connections(defines.direction.south, SIZE_MEDIUM),
		gates = make_gates(defines.direction.south, SIZE_MEDIUM)
	},
	medium_east = {
		direction = "east",
		entrance_x = -38,
		entrance_y = 0,
		exit_x = -6,
		exit_y = 0,
		possible_connections = get_possible_connections(defines.direction.east, SIZE_MEDIUM),
		gates = make_gates(defines.direction.east, SIZE_MEDIUM)
	},
	medium_west = {
		direction = "west",
		entrance_x = 38,
		entrance_y = 0,
		exit_x = 6,
		exit_y = 0,
		possible_connections = get_possible_connections(defines.direction.west, SIZE_MEDIUM),
		gates = make_gates(defines.direction.west, SIZE_MEDIUM)
	},
	large_north = {
		direction = "north",
		entrance_x = 0,
		entrance_y = 56,
		exit_x = 0,
		exit_y = 9,
		possible_connections = get_possible_connections(defines.direction.north, SIZE_LARGE),
		gates = make_gates(defines.direction.north, SIZE_LARGE)
	},
	large_south = {
		direction = "south",
		entrance_x = 0,
		entrance_y = -56,
		exit_x = 0,
		exit_y = -9,
		possible_connections = get_possible_connections(defines.direction.south, SIZE_LARGE),
		gates = make_gates(defines.direction.south, SIZE_LARGE)
	},
	large_east = {
		direction = "east",
		entrance_x = -56,
		entrance_y = 0,
		exit_x = -9,
		exit_y = 0,
		possible_connections = get_possible_connections(defines.direction.east, SIZE_LARGE),
		gates = make_gates(defines.direction.east, SIZE_LARGE)
	},
	large_west = {
		direction = "west",
		entrance_x = 56,
		entrance_y = 0,
		exit_x = 9,
		exit_y = 0,
		possible_connections = get_possible_connections(defines.direction.west, SIZE_LARGE),
		gates = make_gates(defines.direction.west, SIZE_LARGE)
	},
	huge_north = {
		direction = "north",
		entrance_x = 0,
		entrance_y = 72,
		exit_x = 0,
		exit_y = 12,
		possible_connections = get_possible_connections(defines.direction.north, SIZE_HUGE),
		gates = make_gates(defines.direction.north, SIZE_HUGE)
	},
	huge_south = {
		direction = "south",
		entrance_x = 0,
		entrance_y = -72,
		exit_x = 0,
		exit_y = -12,
		possible_connections = get_possible_connections(defines.direction.south, SIZE_HUGE),
		gates = make_gates(defines.direction.south, SIZE_HUGE)
	},
	huge_east = {
		direction = "east",
		entrance_x = -72,
		entrance_y = 0,
		exit_x = -12,
		exit_y = 0,
		possible_connections = get_possible_connections(defines.direction.east, SIZE_HUGE),
		gates = make_gates(defines.direction.east, SIZE_HUGE)
	},
	huge_west = {
		direction = "west",
		entrance_x = 72,
		entrance_y = 0,
		exit_x = 12,
		exit_y = 0,
		possible_connections = get_possible_connections(defines.direction.west, SIZE_HUGE),
		gates = make_gates(defines.direction.west, SIZE_HUGE)
	}
	
}

local LAYOUT = {
	["small-factory"] = {
		name = "small-factory",
		constructor = constructors["small"],
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
		tier = 0,
		chunk_radius = 1,
		is_power_plant = true,
		north = directionals["small_north"],
		south = directionals["small_south"],
		east = directionals["small_east"],
		west = directionals["small_west"]
	},
	["medium-factory"] = {
		name = "medium-factory",
		constructor = constructors["medium"],
		tier = 0,
		chunk_radius = 1,
		is_power_plant = false,
		north = directionals["medium_north"],
		south = directionals["medium_south"],
		east = directionals["medium_east"],
		west = directionals["medium_west"]
	},
	["medium-power-plant"] = {
		name = "medium-power-plant",
		constructor = constructors["medium"],
		tier = 0,
		chunk_radius = 1,
		is_power_plant = true,
		north = directionals["medium_north"],
		south = directionals["medium_south"],
		east = directionals["medium_east"],
		west = directionals["medium_west"]
	},
	["large-factory"] = {
		name = "large-factory",
		constructor = constructors["large"],
		tier = 0,
		chunk_radius = 1,
		is_power_plant = false,
		north = directionals["large_north"],
		south = directionals["large_south"],
		east = directionals["large_east"],
		west = directionals["large_west"]
	},
	["large-power-plant"] = {
		name = "large-power-plant",
		constructor = constructors["large"],
		tier = 0,
		chunk_radius = 1,
		is_power_plant = true,
		north = directionals["large_north"],
		south = directionals["large_south"],
		east = directionals["large_east"],
		west = directionals["large_west"]
	},
	["huge-factory"] = {
		name = "huge-factory",
		constructor = constructors["huge"],
		tier = 0,
		chunk_radius = 1,
		is_power_plant = false,
		north = directionals["huge_north"],
		south = directionals["huge_south"],
		east = directionals["huge_east"],
		west = directionals["huge_west"]
	},
	["huge-power-plant"] = {
		name = "huge-power-plant",
		constructor = constructors["huge"],
		tier = 0,
		chunk_radius = 1,
		is_power_plant = true,
		north = directionals["huge_north"],
		south = directionals["huge_south"],
		east = directionals["huge_east"],
		west = directionals["huge_west"]
	}
}

return LAYOUT