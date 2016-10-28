require ("prototypes.copied-from-base.demo-pipecovers")
require ("prototypes.copied-from-base.circuit-connector-sprites")

data:extend({
	-- FACTORY POWER PROVIDER --
	{
		type = "accumulator",
		name = "factory-power-provider",
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
			buffer_capacity = factorissimo.config.power_buffer,
			usage_priority = "terciary",
			input_flow_limit = "0MW",
			output_flow_limit = factorissimo.config.power_input_limit
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
	
	
	-- FACTORY POWER RECEIVER --
	{
		type = "accumulator",
		name = "factory-power-receiver",
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
			buffer_capacity = factorissimo.config.power_buffer,
			usage_priority = "terciary",
			input_flow_limit = factorissimo.config.power_output_limit,
			output_flow_limit = "0MW"
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
		maximum_wire_distance = 90,
		supply_area_distance = 45, -- Thanks Rufflemao!
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

	-- FACTORY GATE --

	{
		type = "gate",
		name = "factory-gate",
		icon = "__base__/graphics/icons/gate.png",
		flags = { "placeable-neutral" },
		minable = nil,
		max_health = 350,
		corpse = "small-remnants",
		collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		opening_speed = 0.0666666,
		activation_distance = 3,
		timeout_to_close = 5,
		resistances =
		{
		  {
			type = "physical",
			decrease = 3,
			percent = 20
		  },
		  {
			type = "impact",
			decrease = 45,
			percent = 60
		  },
		  {
			type = "explosion",
			decrease = 10,
			percent = 30
		  },
		  {
			type = "fire",
			percent = 100
		  },
		  {
			type = "laser",
			percent = 70
		  }
		},
		vertical_animation =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/gate/gate-vertical.png",
			  line_length = 8,
			  width = 21,
			  height = 60,
			  frame_count = 16,
			  shift = {0.015625, -0.40625}
			},
			{
			  filename = "__base__/graphics/entity/gate/gate-vertical-shadow.png",
			  line_length = 8,
			  width = 41,
			  height = 50,
			  frame_count = 16,
			  shift = {0.328125, 0.3},
			  draw_as_shadow = true
			}
		  }
		},
		horizontal_animation =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/gate/gate-horizontal.png",
			  line_length = 8,
			  width = 32,
			  height = 36,
			  frame_count = 16,
			  shift = {0, -0.21875}
			},
			{
			  filename = "__base__/graphics/entity/gate/gate-horizontal-shadow.png",
			  line_length = 8,
			  width = 62,
			  height = 28,
			  frame_count = 16,
			  shift = {0.4375, 0.46875},
			  draw_as_shadow = true
			}
		  }
		},
		vertical_base =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/gate/gate-base-vertical.png",
			  width = 32,
			  height = 32
			},
			{
			  filename = "__base__/graphics/entity/gate/gate-base-vertical-mask.png",
			  width = 32,
			  height = 32,
			  apply_runtime_tint = true
			}
		  }
		},
		horizontal_rail_animation_left =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/gate/gate-rail-horizontal-left.png",
			  line_length = 8,
			  width = 32,
			  height = 47,
			  frame_count = 16,
			  shift = {0, -0.140625 + 0.125}
			},
			{
			  filename = "__base__/graphics/entity/gate/gate-rail-horizontal-shadow-left.png",
			  line_length = 8,
			  width = 73,
			  height = 27,
			  frame_count = 16,
			  shift = {0.078125, 0.171875 + 0.125},
			  draw_as_shadow = true
			}
		  }
		},
		horizontal_rail_animation_right =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/gate/gate-rail-horizontal-right.png",
			  line_length = 8,
			  width = 32,
			  height = 43,
			  frame_count = 16,
			  shift = {0, -0.203125 + 0.125}
			},
			{
			  filename = "__base__/graphics/entity/gate/gate-rail-horizontal-shadow-right.png",
			  line_length = 8,
			  width = 73,
			  height = 28,
			  frame_count = 16,
			  shift = {0.60938, 0.2875 + 0.125},
			  draw_as_shadow = true
			}
		  }
		},
		vertical_rail_animation_left =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/gate/gate-rail-vertical-left.png",
			  line_length = 8,
			  width = 22,
			  height = 54,
			  frame_count = 16,
			  shift = {0, -0.46875}
			},
			{
			  filename = "__base__/graphics/entity/gate/gate-rail-vertical-shadow-left.png",
			  line_length = 8,
			  width = 47,
			  height = 48,
			  frame_count = 16,
			  shift = {0.27, -0.16125 + 0.5},
			  draw_as_shadow = true
			}
		  }
		},
		vertical_rail_animation_right =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/gate/gate-rail-vertical-right.png",
			  line_length = 8,
			  width = 22,
			  height = 55,
			  frame_count = 16,
			  shift = {0, -0.453125}
			},
			{
			  filename = "__base__/graphics/entity/gate/gate-rail-vertical-shadow-right.png",
			  line_length = 8,
			  width = 47,
			  height = 47,
			  frame_count = 16,
			  shift = {0.27, 0.803125 - 0.5},
			  draw_as_shadow = true
			}
		  }
		},
		vertical_rail_base =
		{
		  filename = "__base__/graphics/entity/gate/gate-rail-base-vertical.png",
		  line_length = 8,
		  width = 64,
		  height = 64,
		  frame_count = 16,
		  shift = {0, 0},
		},
		horizontal_rail_base =
		{
		  filename = "__base__/graphics/entity/gate/gate-rail-base-horizontal.png",
		  line_length = 8,
		  width = 64,
		  height = 45,
		  frame_count = 16,
		  shift = {0, -0.015625 + 0.125},
		},
		vertical_rail_base_mask =
		{
		  filename = "__base__/graphics/entity/gate/gate-rail-base-mask-vertical.png",
		  width = 63,
		  height = 39,
		  shift = {0.015625, -0.015625},
		  apply_runtime_tint = true
		},
		horizontal_rail_base_mask =
		{
		  filename = "__base__/graphics/entity/gate/gate-rail-base-mask-horizontal.png",
		  width = 53,
		  height = 45,
		  shift = {0.015625, -0.015625 + 0.125},
		  apply_runtime_tint = true
		},
		horizontal_base =
		{
		  layers =
		  {
			{
			  filename = "__base__/graphics/entity/gate/gate-base-horizontal.png",
			  width = 32,
			  height = 23,
			  shift = {0, 0.125}
			},
			{
			  filename = "__base__/graphics/entity/gate/gate-base-horizontal-mask.png",
			  width = 32,
			  height = 23,
			  apply_runtime_tint = true,
			  shift = {0, 0.125}
			}
		  }
		},
		wall_patch =
		{
		  north =
		  {
			layers =
			{
			  {
				filename = "__base__/graphics/entity/gate/wall-patch-north.png",
				width = 22,
				height = 35,
				shift = {0, -0.62 + 1}
			  },
			  {
				filename = "__base__/graphics/entity/gate/wall-patch-north-shadow.png",
				width = 46,
				height = 31,
				shift = {0.3, 0.20 + 1},
				draw_as_shadow = true
			  }
			}
		  },
		  east =
		  {
			layers =
			{
			  {
				filename = "__base__/graphics/entity/gate/wall-patch-east.png",
				width = 11,
				height = 40,
				shift = {0.328125 - 1, -0.109375}
			  },
			  {
				filename = "__base__/graphics/entity/gate/wall-patch-east-shadow.png",
				width = 38,
				height = 32,
				shift = {0.8125 - 1, 0.46875},
				draw_as_shadow = true
			  }
			}
		  },
		  south =
		  {
			layers =
			{
			  {
				filename = "__base__/graphics/entity/gate/wall-patch-south.png",
				width = 22,
				height = 40,
				shift = {0, -0.125}
			  },
			  {
				filename = "__base__/graphics/entity/gate/wall-patch-south-shadow.png",
				width = 48,
				height = 25,
				shift = {0.3, 0.95},
				draw_as_shadow = true
			  }
			}
		  },
		  west =
		  {
			layers =
			{
			  {
				filename = "__base__/graphics/entity/gate/wall-patch-west.png",
				width = 11,
				height = 40,
				shift = {-0.328125 + 1, -0.109375}
			  },
			  {
				filename = "__base__/graphics/entity/gate/wall-patch-west-shadow.png",
				width = 46,
				height = 32,
				shift = {0.1875 + 1, 0.46875},
				draw_as_shadow = true
			  }
			}
		  }
		},
		vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		open_sound =
		{
		  variations = { filename = "__base__/sound/gate1.ogg", volume = 0.5 },
		  aggregation =
		  {
			max_count = 1,
			remove = true
		  }
		},
		close_sound =
		{
		  variations = { filename = "__base__/sound/gate1.ogg", volume = 0.5 },
		  aggregation =
		  {
			max_count = 1,
			remove = true
		  }
		}
	}
})
