require ("prototypes.copied-from-base.demo-pipecovers")
require ("prototypes.copied-from-base.circuit-connector-sprites")

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

-- Helper function
local function get_connection_points(size)
	local result = {}
	local connection_radius = math.floor(size * 2 / 3)
	local c1 = size + 0.5
	for c2 = 0.5 - connection_radius, connection_radius - 0.5 do
		table.insert(result, { position = { -c1, c2 }, type = "output" })
		table.insert(result, { position = { c2, -c1 }, type = "output" })
		table.insert(result, { position = { c1, c2 }, type = "output" })
	end
	return result
end

local function create_building(size, category, image_width, image_height, image_shift)
	local name = index_size(size) .. "-" .. category
	local icon = "__Factorissimo__/graphics/icons/" .. name .. ".png"
	local input, output, priority, usage
	if category == "factory" then
		input = factorissimo.config.power_input_limit
		output = "0MW"
		priority = "secondary-input"
		usage = input
	elseif category == "power-plant" then
		input = "0MW"
		output = factorissimo.config.power_output_limit
		priority = "secondary-output"
		usage = output
	end
	local image_prefix = "__Factorissimo__/graphics/entity/" .. name .. "/" .. name
	return {
		type = "assembling-machine",
		name = name,
		icon = icon,
		flags = {"placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 10, result = name},
		max_health = 1000 * (size + 2),
		corpse = "big-remnants",
		collision_box = {{.05 - size, .05 - size}, {size - .05, size - .6}},
		selection_box = {{-size, -size}, {size, size}},
		dying_explosion = "medium-explosion",
		energy_source =
		{
			type = "electric",
			usage_priority = priority,
			input_flow_limit = input,
			output_flow_limit = output,
			buffer_capacity = factorissimo.config.power_buffer,
			drain = "0W"
		},
		energy_usage = usage,
		
		pumping_speed = 0,
		fluid_boxes =
		{
			{
				production_type = "output",
				base_area = 1,
				base_level = 1,
				pipe_covers = pipecoverspictures(),
				pipe_connections = get_connection_points(size),
				off_when_no_fluid_recipe = false
			}
		},
		animation =
		{
		  north =
		  {
			filename = image_prefix .. "-north.png",
			width = image_width,
			height = image_height,
			frame_count = 1,
			shift = image_shift
		  },
		  east =
		  {
			filename = image_prefix .. "-east.png",
			width = image_width,
			height = image_height,
			frame_count = 1,
			shift = image_shift
		  },
		  south =
		  {
			filename = image_prefix .. "-south.png",
			width = image_width,
			height = image_height,
			frame_count = 1,
			shift = image_shift
		  },
		  west =
		  {
			filename = image_prefix .. "-west.png",
			width = image_width,
			height = image_height,
			frame_count = 1,
			shift = image_shift
		  }
		},
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound = { filename = "__base__/sound/roboport-working.ogg", volume = 0.0 },
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			probability = 0 / (5 * 60)
		},
		
		-- unused assembling-machine features
		module_specification =
		{
		  module_slots = 0
		},
		crafting_categories = { "factorissimo-no-recipes" },
		crafting_speed = 1,
		ingredient_count = 0
	}
end

data:extend({
	-- FACTORY --
	create_building(SIZE_SMALL, "factory", 288, 256, { 0.5, 0.25 }),
	create_building(SIZE_MEDIUM, "factory", 576, 512, { 1.75, 0.75 }),
	create_building(SIZE_LARGE, "factory", 736, 720, { 1.2, 0.75 }),
	create_building(SIZE_HUGE, "factory", 960, 896, { 1.3, 0.75 }),
	
	-- POWER PLANT --
	create_building(SIZE_SMALL, "power-plant", 288, 256, { 0.5, 0.25 }),
	create_building(SIZE_MEDIUM, "power-plant", 576, 512, { 1.75, 0.75 }),
	create_building(SIZE_LARGE, "power-plant", 736, 720, { 1.2, 0.75 }),
	create_building(SIZE_HUGE, "power-plant", 960, 896, { 1.3, 0.75 })
})