require ("prototypes.copied-from-base.demo-pipecovers")
require ("prototypes.copied-from-base.circuit-connector-sprites")
local config = require('config')

data:extend({
	-- FACTORY POWER PROVIDER --
	{
		type = "electric-energy-interface",
		name = "factory-power-transferrer",
		icon = "__base__/graphics/icons/accumulator.png",
		flags = {"placeable-neutral"},
		minable = nil,
		max_health = 150,
		corpse = "medium-remnants",
		collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
		selection_box = {{-1, -1}, {1, 1}},
		energy_source =
		{
			type = "electric",
			buffer_capacity = "0MW",
			usage_priority = "terciary",
			input_flow_limit = "0MW",
			output_flow_limit = "0MW",
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
		minable = nil,
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
		supply_area_distance = 40, -- Thanks Rufflemao!
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


	-- OUTPUT CHEST
	{
		type = "logistic-container",
		name = "factory-chest-output",
		icon = "__base__/graphics/icons/logistic-chest-requester.png",
		flags = {"placeable-neutral"},
		minable = nil,
		max_health = 150,
		corpse = "small-remnants",
		collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		fast_replaceable_group = "container",
		inventory_size = 55,
		logistic_mode = "requester",
		open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
		close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		picture =
		{
		filename = "__base__/graphics/entity/logistic-chest/logistic-chest-requester.png",
		priority = "extra-high",
		width = 38,
		height = 32,
		shift = {0.09375, 0}
		},
		circuit_wire_connection_point =
		{
		shadow =
		{
			red = {0.734375, 0.453125},
			green = {0.609375, 0.515625},
		},
		wire =
		{
			red = {0.40625, 0.21875},
			green = {0.40625, 0.375},
		}
		},
		circuit_wire_max_distance = 7.5,
		circuit_connector_sprites = get_circuit_connector_sprites({0.1875, 0.15625}, nil, 18),
  },


  -- INPUT CHEST
	{
		type = "logistic-container",
		name = "factory-chest-input",
		icon = "__base__/graphics/icons/logistic-chest-active-provider.png",
		flags = {"placeable-neutral"},
		minable = nil,
		max_health = 150,
		corpse = "small-remnants",
		collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		fast_replaceable_group = "container",
		inventory_size = 55,
		logistic_mode = "active-provider",
		open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
		close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		picture =
		{
			filename = "__base__/graphics/entity/logistic-chest/logistic-chest-active-provider.png",
			priority = "extra-high",
			width = 38,
			height = 32,
			shift = {0.09375, 0}
		},
		circuit_wire_connection_point =
		{
			shadow =
			{
				red = {0.734375, 0.453125},
				green = {0.609375, 0.515625},
			},
			wire =
			{
				red = {0.40625, 0.21875},
				green = {0.40625, 0.375},
			}
		},
		circuit_wire_max_distance = 7.5,
		circuit_connector_sprites = get_circuit_connector_sprites({0.1875, 0.15625}, nil, 18),
  },
})