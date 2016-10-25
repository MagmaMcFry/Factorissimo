require 'lib/table-utils'

local ret = {
    tier = 0,
    chunk_radius = 1,
    surface_width = 2,
    surface_height = 2,
    entrance_x = 0,
    entrance_y = 19,
    exit_x = 0,
    exit_y = 3,
    provider_x = -4,
    provider_y = 20,
    distributor_x = 4,
    distributor_y = 20,
    output_chest_x = -3,
    output_chest_y = 18,
    input_chest_x = 2,
    input_chest_y = 18,
    tiles = {},
    rectangles = {
        {x1 = -19, x2 = 19, y1 = -19, y2 = 19, tile = "factory-wall"},
        {x1 = -6, x2 = 6, y1 = 18, y2 = 22, tile = "factory-wall"},
        {x1 = -18, x2 = 18, y1 = -18, y2 = 18, tile = "factory-floor"},
        {x1 = -2, x2 = 2, y1 = 18, y2 = 22, tile = "factory-entrance"},
    },
    possible_connections = {
        {
            outside_x = -3.5,
            outside_y = -1.5,
            inside_x = -18.5,
            inside_y = -13.5,
            direction_in = defines.direction.east,
            direction_out = defines.direction.west,
        },
        {
            outside_x = -3.5,
            outside_y = -0.5,
            inside_x = -18.5,
            inside_y = -4.5,
            direction_in = defines.direction.east,
            direction_out = defines.direction.west,
        },
        {
            outside_x = -3.5,
            outside_y = 0.5,
            inside_x = -18.5,
            inside_y = 4.5,
            direction_in = defines.direction.east,
            direction_out = defines.direction.west,
        },
        {
            outside_x = -3.5,
            outside_y = 1.5,
            inside_x = -18.5,
            inside_y = 13.5,
            direction_in = defines.direction.east,
            direction_out = defines.direction.west,
        },
        {
            outside_x = -1.5,
            outside_y = -3.5,
            inside_x = -13.5,
            inside_y = -18.5,
            direction_in = defines.direction.south,
            direction_out = defines.direction.north,
        },
        {
            outside_x = -0.5,
            outside_y = -3.5,
            inside_x = -4.5,
            inside_y = -18.5,
            direction_in = defines.direction.south,
            direction_out = defines.direction.north,
        },
        {
            outside_x = 0.5,
            outside_y = -3.5,
            inside_x = 4.5,
            inside_y = -18.5,
            direction_in = defines.direction.south,
            direction_out = defines.direction.north,
        },
        {
            outside_x = 1.5,
            outside_y = -3.5,
            inside_x = 13.5,
            inside_y = -18.5,
            direction_in = defines.direction.south,
            direction_out = defines.direction.north,
        },
        {
            outside_x = 3.5,
            outside_y = -1.5,
            inside_x = 18.5,
            inside_y = -13.5,
            direction_in = defines.direction.west,
            direction_out = defines.direction.east,
        },
        {
            outside_x = 3.5,
            outside_y = -0.5,
            inside_x = 18.5,
            inside_y = -4.5,
            direction_in = defines.direction.west,
            direction_out = defines.direction.east,
        },
        {
            outside_x = 3.5,
            outside_y = 0.5,
            inside_x = 18.5,
            inside_y = 4.5,
            direction_in = defines.direction.west,
            direction_out = defines.direction.east,
        },
        {
            outside_x = 3.5,
            outside_y = 1.5,
            inside_x = 18.5,
            inside_y = 13.5,
            direction_in = defines.direction.west,
            direction_out = defines.direction.east,
        },
    }
}

local function add_tile_rect(tiles, tile_name, xmin, ymin, xmax, ymax)
	local i = #tiles
	for x = xmin, xmax-1 do
		for y = ymin, ymax-1 do
			i = i + 1
			tiles[i] = {name = tile_name, position={x, y}}
		end
	end
end

local tiles = ret.tiles

for _, pconn in pairs(ret.possible_connections) do
	add_tile_rect(tiles, "factory-wall", pconn.inside_x-1, pconn.inside_y-1, pconn.inside_x+2, pconn.inside_y+2)
end
for _, rect in pairs(ret.rectangles) do
	add_tile_rect(tiles, rect.tile, rect.x1, rect.y1, rect.x2, rect.y2)
end
for _, pconn in pairs(ret.possible_connections) do
	add_tile_rect(tiles, "factory-floor", pconn.inside_x, pconn.inside_y, pconn.inside_x+1, pconn.inside_y+1)
end

return ret
