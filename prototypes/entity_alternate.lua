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
			input_flow_limit = "50MW",
			output_flow_limit = "0MW",
			buffer_capacity = "10MJ"
		},
		crafting_categories = {"smelting", "crafting", "advanced-crafting", "crafting-with-fluid", "oil-processing", "chemistry"},

		energy_usage = "10kW",
		crafting_speed = 0,
		ingredient_count = 10,
		
		fluid_boxes =
		{
			{
				production_type = "input",
				base_level = 1,
				--pipe_covers = pipecoverspictures(), -- Don't need those
				pipe_connections = {},
			},
			{
				production_type = "input",
				base_level = 1,
				--pipe_covers = pipecoverspictures(), -- Don't need those
				pipe_connections = {},
			},
			{
				production_type = "input",
				base_level = 1,
				--pipe_covers = pipecoverspictures(), -- Don't need those
				pipe_connections = {},
			},
			{
				production_type = "output",
				base_level = 1,
				--pipe_covers = pipecoverspictures(), -- Don't need those
				pipe_connections = {},
			},
			{
				production_type = "output",
				base_level = 1,
				--pipe_covers = pipecoverspictures(), -- Don't need those
				pipe_connections = {},
			},
			{
				production_type = "output",
				base_level = 1,
				--pipe_covers = pipecoverspictures(), -- Don't need those
				pipe_connections = {},
			},
			{
				production_type = "output",
				base_level = 1,
				--pipe_covers = pipecoverspictures(), -- Don't need those
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
					--{ position = {-2, 3}, type="output" },
					--{ position = {-1, 3}, type="output" },
					--{ position = {0, 3}, type="output" },
					--{ position = {1, 3}, type="output" },
				},
			},
		},
		
		--picture =
		--{
		--	filename = "__Factorissimo__/graphics/entity/small-factory/small-factory.png",
		--	width = 288,
		--	height = 256,
		--	shift = {0.5, 0}
		--},
		
		animation = {
			north =
			{
				filename = "__Factorissimo__/graphics/entity/small-factory/small-factory.png",
				width = 288,
				height = 256,
				frame_count = 1,
				shift = {0.5, 0}
			},
			east =
			{
				filename = "__Factorissimo__/graphics/entity/small-factory/small-factory.png",
				width = 288,
				height = 256,
				frame_count = 1,
				shift = {0.5, 0}
			},
			south =
			{
				filename = "__Factorissimo__/graphics/entity/small-factory/small-factory.png",
				width = 288,
				height = 256,
				frame_count = 1,
				shift = {0.5, 0}
			},
			west =
			{
				filename = "__Factorissimo__/graphics/entity/small-factory/small-factory.png",
				width = 288,
				height = 256,
				frame_count = 1,
				shift = {0.5, 0}
			},
		},
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound = { filename = "__base__/sound/roboport-working.ogg", volume = 0.6 },
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			probability = 1 / (5 * 60) -- average pause between the sound is 5 seconds
		},

		circuit_wire_connection_point =
		{
			shadow =
			{
				red = {1.17188, 1.98438},
				green = {1.04688, 2.04688}
			},
			wire =
			{
				red = {0.78125, 1.375},
				green = {0.78125, 1.53125}
			}
		},
		circuit_connector_sprites = get_circuit_connector_sprites({0.59375, 1.3125}, nil, 18),
		circuit_wire_max_distance = 7.5,
	},
	
	-- FACTORY POWER PROVIDER --
	{
		type = "accumulator",
		name = "factory-power-provider",
		icon = "__base__/graphics/icons/accumulator.png",
		flags = {"placeable-neutral"},
		minable = {hardness = 0.2, mining_time = 0.5, result = "factory-power-provider"},
		max_health = 150,
		corpse = "medium-remnants",
		collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
		selection_box = {{-1, -1}, {1, 1}},
		energy_source =
		{
			type = "electric",
			buffer_capacity = "10MJ",
			usage_priority = "terciary",
			input_flow_limit = "0MW",
			output_flow_limit = "50MW"
		},
		picture =
		{
			filename = "__base__/graphics/entity/accumulator/accumulator.png",
			priority = "extra-high",
			width = 124,
			height = 103,
			shift = {0.6875, -0.203125}
		},
		charge_animation =
		{
			filename = "__base__/graphics/entity/accumulator/accumulator-charge-animation.png",
			width = 138,
			height = 135,
			line_length = 8,
			frame_count = 24,
			shift = {0.46875, -0.640625},
			animation_speed = 0.5
		},
		charge_cooldown = 30,
		charge_light = {intensity = 0.3, size = 0}, --7
		discharge_animation =
		{
			filename = "__base__/graphics/entity/accumulator/accumulator-discharge-animation.png",
			width = 147,
			height = 128,
			line_length = 8,
			frame_count = 24,
			shift = {0.390625, -0.53125},
			animation_speed = 0.5
		},
		discharge_cooldown = 60,
		discharge_light = {intensity = 0.7, size = 0}, --7
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound =
			{
				filename = "__base__/sound/accumulator-working.ogg",
				volume = 1
			},
			idle_sound = {
				filename = "__base__/sound/accumulator-idle.ogg",
				volume = 0.4
			},
			max_sounds_per_type = 5
		},
		circuit_wire_connection_point =
		{
			shadow =
			{
				red = {0.984375, 1.10938},
				green = {0.890625, 1.10938}
			},
			wire =
			{
				red = {0.6875, 0.59375},
				green = {0.6875, 0.71875}
			}
		},
		circuit_connector_sprites = get_circuit_connector_sprites({0.46875, 0.5}, {0.46875, 0.8125}, 26),
		circuit_wire_max_distance = 7.5,
		default_output_signal = "signal-A"
	},
	 -- FACTORY POWER DISTRIBUTOR --
	{
		type = "electric-pole",
		name = "factory-power-distributor",
		icon = "__base__/graphics/icons/substation.png",
		flags = {"placeable-neutral", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.5, result = "factory-power-distributor"},
		max_health = 200,
		corpse = "medium-remnants",
		resistances =
		{
			{
				type = "fire",
				percent = 90
			}
		},
		collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
		selection_box = {{-1, -1}, {1, 1}},
		drawing_box = {{-1, -3}, {1, 1}},
		maximum_wire_distance = 0,
		supply_area_distance = 300,
		pictures =
		{
			filename = "__base__/graphics/entity/substation/substation.png",
			priority = "high",
			width = 132,
			height = 144,
			direction_count = 4,
			shift = {0.9, -1}
		},
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound = { filename = "__base__/sound/substation.ogg" },
			apparent_volume = 1.5,
			audible_distance_modifier = 0.5,
			probability = 1 / (3 * 60) -- average pause between the sound is 3 seconds
		},
		connection_points =
		{
			{
				shadow =
				{
					copper = {1.9, -0.6},
					green = {1.3, -0.6},
					red = {2.65, -0.6}
				},
				wire =
				{
					copper = {-0.25, -2.71875},
					green = {-0.84375, -2.71875},
					red = {0.34375, -2.71875}
				}
			},
			{
				shadow =
				{
					copper = {1.9, -0.6},
					green = {1.2, -0.8},
					red = {2.5, -0.35}
				},
				wire =
				{
					copper = {-0.21875, -2.71875},
					green = {-0.65625, -3.03125},
					red = {0.1875, -2.4375}
				}
			},
			{
				shadow =
				{
					copper = {1.9, -0.6},
					green = {1.9, -0.9},
					red = {1.9, -0.3}
				},
				wire =
				{
					copper = {-0.21875, -2.71875},
					green = {-0.21875, -3.15625},
					red = {-0.21875, -2.34375}
				}
			},
			{
				shadow =
				{
					copper = {1.8, -0.7},
					green = {1.3, -0.6},
					red = {2.4, -1.15}
				},
				wire =
				{
					copper = {-0.21875, -2.75},
					green = {-0.65625, -2.4375},
					red = {0.1875, -3.03125}
				}
			}
		},
		radius_visualisation_picture =
		{
			filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
			width = 12,
			height = 12,
			priority = "extra-high-no-scale"
		},
	},
})