require ("prototypes.copied-from-base.demo-pipecovers")
require ("prototypes.copied-from-base.circuit-connector-sprites")

data:extend({
	-- FACTORY --
	{
		type = "roboport",
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
			buffer_capacity = factorissimo.config.power_buffer
		},
		energy_usage = "0kW",
		pumping_speed = 0,
		fluid_box = -- NOT WORKING :( Pipes won't connect, roboport entity type won't create a fluid box. Need better entity type
		{
			base_area = 1,
			pipe_covers = pipecoverspictures(),
			pipe_connections =
			{
				{ position = {-4, -2}, type="output" },
				{ position = {-4, -1}, type="output" },
				{ position = {-4, 0}, type="output" },
				{ position = {-4, 1}, type="output" },
				{ position = {-2, -4}, type="output" },
				{ position = {-1, -4}, type="output" },
				{ position = {0, -4}, type="output" },
				{ position = {1, -4}, type="output" },
				{ position = {3, -2}, type="output" },
				{ position = {3, -1}, type="output" },
				{ position = {3, 0}, type="output" },
				{ position = {3, 1}, type="output" },
			},
		},
		
		-- unused roboport features
		charging_energy = "1000kW",
		logistics_radius = 0, 
		construction_radius = 0,
		charge_approach_distance = 5,
		robot_slots_count = 0,
		recharge_minimum = "4000MJ",
		material_slots_count = 0,
		stationing_offset = {0, 0},
		charging_offsets = {},
		
		
		picture =
		{
			filename = "__Factorissimo__/graphics/entity/small-factory/small-factory.png",
			width = 288,
			height = 256,
			shift = {0.5, 0}
		},
		
		base =
		{
			filename = "__Factorissimo__/graphics/entity/small-factory/small-factory.png",
			width = 288,
			height = 256,
			shift = {0.5, 0}
		},
		base_patch =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		base_animation =
		{
			filename = "__base__/graphics/entity/roboport/roboport-base-animation.png",
			priority = "medium",
			width = 42,
			height = 31,
			frame_count = 8,
			animation_speed = 0.5,
			shift = {-0.5315, -1.9375}
		},
		door_animation_up =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		door_animation_down =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		recharging_animation =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound = { filename = "__base__/sound/roboport-working.ogg", volume = 0.0 },
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			probability = 0 / (5 * 60)
		},
		recharging_light = {intensity = 0.4, size = 5},
		request_to_open_door_timeout = 15,
		spawn_and_station_height = -0.1,

		draw_logistic_radius_visualization = false,
		draw_construction_radius_visualization = false,

		open_door_trigger_effect =
		{
			{
				type = "play-sound",
				sound = { filename = "__base__/sound/roboport-door.ogg", volume = 1.2 }
			},
		},
		close_door_trigger_effect =
		{
			{
				type = "play-sound",
				sound = { filename = "__base__/sound/roboport-door.ogg", volume = 0.75 }
			},
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
		default_available_logistic_output_signal = "signal-X",
		default_total_logistic_output_signal = "signal-Y",
		default_available_construction_output_signal = "signal-Z",
		default_total_construction_output_signal = "signal-T",
	},
	
	-- POWER PLANT --
	{
		type = "roboport",
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
			buffer_capacity = factorissimo.config.power_buffer
		},
		energy_usage = "0kW",
		pumping_speed = 0,
		fluid_box = -- NOT WORKING :( Pipes won't connect, roboport entity type won't create a fluid box. Need better entity type
		{
			base_area = 1,
			pipe_covers = pipecoverspictures(),
			pipe_connections =
			{
				{ position = {-4, -2}, type="output" },
				{ position = {-4, -1}, type="output" },
				{ position = {-4, 0}, type="output" },
				{ position = {-4, 1}, type="output" },
				{ position = {-2, -4}, type="output" },
				{ position = {-1, -4}, type="output" },
				{ position = {0, -4}, type="output" },
				{ position = {1, -4}, type="output" },
				{ position = {3, -2}, type="output" },
				{ position = {3, -1}, type="output" },
				{ position = {3, 0}, type="output" },
				{ position = {3, 1}, type="output" },
			},
		},
		
		-- unused roboport features
		charging_energy = "1000kW",
		logistics_radius = 0, 
		construction_radius = 0,
		charge_approach_distance = 5,
		robot_slots_count = 0,
		recharge_minimum = "4000MJ",
		material_slots_count = 0,
		stationing_offset = {0, 0},
		charging_offsets = {},
		
		
		picture =
		{
			filename = "__Factorissimo__/graphics/entity/small-power-plant/small-power-plant.png",
			width = 288,
			height = 256,
			shift = {0.5, 0}
		},
		
		base =
		{
			filename = "__Factorissimo__/graphics/entity/small-power-plant/small-power-plant.png",
			width = 288,
			height = 256,
			shift = {0.5, 0}
		},
		base_patch =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		base_animation =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		door_animation_up =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		door_animation_down =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		recharging_animation =
		{
			filename = "__Factorissimo__/graphics/nothing.png",
			priority = "medium",
			width = 4,
			height = 4,
			frame_count = 1,
			shift = {0, 0}
		},
		vehicle_impact_sound =	{ filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		working_sound =
		{
			sound = { filename = "__base__/sound/roboport-working.ogg", volume = 0.0 },
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			probability = 0 / (5 * 60)
		},
		recharging_light = {intensity = 0.4, size = 5},
		request_to_open_door_timeout = 15,
		spawn_and_station_height = -0.1,

		draw_logistic_radius_visualization = false,
		draw_construction_radius_visualization = false,

		open_door_trigger_effect =
		{
			{
				type = "play-sound",
				sound = { filename = "__base__/sound/roboport-door.ogg", volume = 1.2 }
			},
		},
		close_door_trigger_effect =
		{
			{
				type = "play-sound",
				sound = { filename = "__base__/sound/roboport-door.ogg", volume = 0.75 }
			},
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
		default_available_logistic_output_signal = "signal-X",
		default_total_logistic_output_signal = "signal-Y",
		default_available_construction_output_signal = "signal-Z",
		default_total_construction_output_signal = "signal-T",
	},
	
	

})