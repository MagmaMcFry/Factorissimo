

local function update01()
	-- Make factory port tiles walkable
	if global["surface-layout"] then
		for surface_name, layout in pairs(global["surface-layout"]) do
			local surface = game.surfaces[surface_name]
			local tiles = {}
			for _, pconn in pairs(layout.possible_connections) do
				tiles[1+#tiles] = {name = "factory-entrance", position = {pconn.inside_x, pconn.inside_y}}
			end
			surface.set_tiles(tiles)
		end
	end
end

function init_update_system()
		global.update_version = 1 -- Latest update
end

function do_required_updates()
	global.update_version = global.update_version or 0
	if global.update_version < 1 then
		update01()
		global.update_version = 1
	end
end
