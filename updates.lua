
local function update02()
	for surface_name, structure in pairs(global["surface-structure"]) do
		-- Change how layouts are stored internally
		local layout = global["surface-layout"][surface_name]
		global["surface-layout"][surface_name] = layout.name
		-- Make inside connections minable
		for _, sconn in pairs(structure.connections) do
			if (sconn.__type == "pipe" or sconn.__type == "belt") and sconn.inside.valid then
				sconn.inside.minable = true
				sconn.inside.destructible = true
				sconn.inside.operable = true
			end
		end
	end
end

local function update01()
	-- Make factory port tiles walkable
	if global["surface-layout"] and global["surface-structure"] then
		for surface_name, _ in pairs(global["surface-structure"]) do -- Don't iterate over surface-layout because we're changing that
			local layout = global["surface-layout"][surface_name]
			local surface = game.surfaces[surface_name]
			local tiles = {}
			for _, pconn in pairs(layout.possible_connections) do
				-- Add walkable tiles to inside ports
				tiles[1+#tiles] = {name = "factory-entrance", position = {pconn.inside_x, pconn.inside_y}}
			end
			surface.set_tiles(tiles)
			-- Update layout
			if layout.is_power_plant then
				global["surface-layout"][surface_name] = layouts()["small-power-plant"]
			else
				global["surface-layout"][surface_name] = layouts()["small-factory"]
			end
			-- Reset connections
			local structure = global["surface-structure"][surface_name]
			if structure and structure.parent and structure.parent.valid then
				mark_connections_dirty(structure.parent)
			end
		end
	end
end

function init_update_system()
		global.update_version = 2 -- Latest update
end

function do_required_updates()
	global.update_version = global.update_version or 0
	if global.update_version < 1 then
		update01()
		global.update_version = 1
	end
	if global.update_version < 2 then
		update02()
		global.update_version = 2
	end
end
