data:extend({
	{
		type = "tile",
		name = "factory-floor",
		needs_correction = false,
		collision_mask = {"ground-tile"},
		walking_speed_modifier = 1.4,
		layer = 61,
		decorative_removal_probability = 0.9,
		variants =
		{
			main =
			{
				{
					picture = "__base__/graphics/terrain/concrete/concrete1.png",
					count = 16,
					size = 1
				},
				{
					picture = "__base__/graphics/terrain/concrete/concrete2.png",
					count = 4,
					size = 2,
					probability = 0.39,
				},
				{
					picture = "__base__/graphics/terrain/concrete/concrete4.png",
					count = 4,
					size = 4,
					probability = 1,
				},
			},
			inner_corner =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-inner-corner.png",
				count = 8
			},
			outer_corner =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-outer-corner.png",
				count = 8
			},
			side =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-side.png",
				count = 8
			},
			u_transition =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-u.png",
				count = 8
			},
			o_transition =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-o.png",
				count = 1
			}
		},
		walking_sound =
		{
			{
				filename = "__base__/sound/walking/concrete-01.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-02.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-03.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-04.ogg",
				volume = 1.2
			}
		},
		map_color={r=100, g=100, b=100},
		ageing=0,
		vehicle_friction_modifier = concrete_vehicle_speed_modifier
	},
	{
		type = "tile",
		name = "factory-wall",
		needs_correction = false,
		collision_mask =
		{
			"ground-tile",
			"resource-layer",
			"floor-layer",
			"item-layer",
			"object-layer",
			"player-layer",
			"doodad-layer"
		},
		walking_speed_modifier = 1.4,
		layer = 61,
		decorative_removal_probability = 0.9,
		variants =
		{
			main =
			{
				{
					picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left1.png",
					count = 16,
					size = 1
				},
				{
					picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left2.png",
					count = 4,
					size = 2,
					probability = 0.39,
				},
				{
					picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left4.png",
					count = 4,
					size = 4,
					probability = 1,
				},
			},
			inner_corner =
			{
				picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-inner-corner.png",
				count = 8
			},
			outer_corner =
			{
				picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-outer-corner.png",
				count = 8
			},
			side =
			{
				picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-side.png",
				count = 8
			},
			u_transition =
			{
				picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-u.png",
				count = 8
			},
			o_transition =
			{
				picture = "__base__/graphics/terrain/hazard-concrete-left/hazard-concrete-left-o.png",
				count = 1
			}
		},
		walking_sound =
		{
			{
				filename = "__base__/sound/walking/concrete-01.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-02.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-03.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-04.ogg",
				volume = 1.2
			}
		},
		map_color={r=0.5, g=0.5, b=0},
		ageing=0,
		vehicle_friction_modifier = concrete_vehicle_speed_modifier
	},
	{
		type = "tile",
		name = "factory-entrance",
		needs_correction = false,
		collision_mask =
		{
			"ground-tile",
			"resource-layer",
			"floor-layer",
			"item-layer",
			"object-layer",
			"doodad-layer"
		},
		walking_speed_modifier = 1.4,
		layer = 61,
		decorative_removal_probability = 0.9,
		variants =
		{
			main =
			{
				{
					picture = "__base__/graphics/terrain/concrete/concrete1.png",
					count = 16,
					size = 1
				},
				{
					picture = "__base__/graphics/terrain/concrete/concrete2.png",
					count = 4,
					size = 2,
					probability = 0.39,
				},
				{
					picture = "__base__/graphics/terrain/concrete/concrete4.png",
					count = 4,
					size = 4,
					probability = 1,
				},
			},
			inner_corner =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-inner-corner.png",
				count = 8
			},
			outer_corner =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-outer-corner.png",
				count = 8
			},
			side =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-side.png",
				count = 8
			},
			u_transition =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-u.png",
				count = 8
			},
			o_transition =
			{
				picture = "__base__/graphics/terrain/concrete/concrete-o.png",
				count = 1
			}
		},
		walking_sound =
		{
			{
				filename = "__base__/sound/walking/concrete-01.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-02.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-03.ogg",
				volume = 1.2
			},
			{
				filename = "__base__/sound/walking/concrete-04.ogg",
				volume = 1.2
			}
		},
		map_color={r=100, g=100, b=100},
		ageing=0,
		vehicle_friction_modifier = concrete_vehicle_speed_modifier
	},
})