require ("prototypes.copied-from-base.demo-pipecovers")
require ("prototypes.copied-from-base.circuit-connector-sprites")

data:extend({
	-- FACTORY --
	{
		type = "assembling-machine",
		name = "small-factory",
		icon = "__Factorissimo__/graphics/icons/small-factory.png",
		flags = {"placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 10, result = "small-factory"},
		max_health = 5000,
		corpse = "big-remnants",
		collision_box = {{-2.95, -2.95}, {2.95, 2.4}},
		selection_box = {{-3, -3}, {3, 3}},
		dying_explosion = "medium-explosion",
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-input",
			input_flow_limit = factorissimo.config.power_input_limit,
			output_flow_limit = "0MW",
			buffer_capacity = factorissimo.config.power_buffer,
			drain = "0W"
		},
		energy_usage = factorissimo.config.power_input_limit,
		
		pumping_speed = 0,
		fluid_boxes =
		{
			{
				production_type = "output",
				base_area = 1,
				base_level = 1,
				pipe_covers = pipecoverspictures(),
				pipe_connections =
				{
					{ position = {-3.5, -1.5}, type="output" },
					{ position = {-3.5, -0.5}, type="output" },
					{ position = {-3.5, 0.5}, type="output" },
					{ position = {-3.5, 1.5}, type="output" },
					{ position = {-1.5, -3.5}, type="output" },
					{ position = {-0.5, -3.5}, type="output" },
					{ position = {0.5, -3.5}, type="output" },
					{ position = {1.5, -3.5}, type="output" },
					{ position = {3.5, -1.5}, type="output" },
					{ position = {3.5, -0.5}, type="output" },
					{ position = {3.5, 0.5}, type="output" },
					{ position = {3.5, 1.5}, type="output" },
				},
				off_when_no_fluid_recipe = false
			}
		},
		animation =
		{
		  north =
		  {
			filename = "__Factorissimo__/graphics/entity/small-factory/small-factory-north.png",
			width = 288,
			height = 256,
			frame_count = 1,
			shift = {0.5, 0.25}
		  },
		  east =
		  {
			filename = "__Factorissimo__/graphics/entity/small-factory/small-factory-east.png",
			width = 288,
			height = 256,
			frame_count = 1,
			shift = {0.5, 0.25}
		  },
		  south =
		  {
			filename = "__Factorissimo__/graphics/entity/small-factory/small-factory-south.png",
			width = 288,
			height = 256,
			frame_count = 1,
			shift = {0.5, 0.25}
		  },
		  west =
		  {
			filename = "__Factorissimo__/graphics/entity/small-factory/small-factory-west.png",
			width = 288,
			height = 256,
			frame_count = 1,
			shift = {0.5, 0.25}
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
	},
	
	-- POWER PLANT --
	{
		type = "assembling-machine",
		name = "small-power-plant",
		icon = "__Factorissimo__/graphics/icons/small-power-plant.png",
		flags = {"placeable-player", "player-creation"},
		minable = {hardness = 0.2, mining_time = 10, result = "small-power-plant"},
		max_health = 5000,
		corpse = "big-remnants",
		collision_box = {{-2.95, -2.95}, {2.95, 2.4}},
		selection_box = {{-3, -3}, {3, 3}},
		dying_explosion = "medium-explosion",
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-output",
			input_flow_limit = "0MW",
			output_flow_limit = factorissimo.config.power_output_limit,
			buffer_capacity = factorissimo.config.power_buffer,
			drain = "0W"
		},
		energy_usage = factorissimo.config.power_input_limit,
		
		pumping_speed = 0,
		fluid_boxes =
		{
			{
				production_type = "output",
				base_area = 1,
				base_level = 1,
				pipe_covers = pipecoverspictures(),
				pipe_connections =
				{
					{ position = {-3.5, -1.5}, type="output" },
					{ position = {-3.5, -0.5}, type="output" },
					{ position = {-3.5, 0.5}, type="output" },
					{ position = {-3.5, 1.5}, type="output" },
					{ position = {-1.5, -3.5}, type="output" },
					{ position = {-0.5, -3.5}, type="output" },
					{ position = {0.5, -3.5}, type="output" },
					{ position = {1.5, -3.5}, type="output" },
					{ position = {3.5, -1.5}, type="output" },
					{ position = {3.5, -0.5}, type="output" },
					{ position = {3.5, 0.5}, type="output" },
					{ position = {3.5, 1.5}, type="output" },
				},
				off_when_no_fluid_recipe = false
			}
		},
		animation =
		{
		  north =
		  {
			filename = "__Factorissimo__/graphics/entity/small-power-plant/small-power-plant-north.png",
			width = 288,
			height = 256,
			frame_count = 1,
			shift = {0.5, 0.25}
		  },
		  east =
		  {
			filename = "__Factorissimo__/graphics/entity/small-power-plant/small-power-plant-east.png",
			width = 288,
			height = 256,
			frame_count = 1,
			shift = {0.5, 0.25}
		  },
		  south =
		  {
			filename = "__Factorissimo__/graphics/entity/small-power-plant/small-power-plant-south.png",
			width = 288,
			height = 256,
			frame_count = 1,
			shift = {0.5, 0.25}
		  },
		  west =
		  {
			filename = "__Factorissimo__/graphics/entity/small-power-plant/small-power-plant-west.png",
			width = 288,
			height = 256,
			frame_count = 1,
			shift = {0.5, 0.25}
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
})