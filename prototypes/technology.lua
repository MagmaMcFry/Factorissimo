data:extend({
	{
		type = "technology",
		name = "factory-architecture",
		icon = "__base__/graphics/technology/automated-construction.png",
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "small-factory"
			},
			{
				type = "unlock-recipe",
				recipe = "small-power-plant"
			},
		},
		prerequisites = {"steel-processing"},
		unit =
		{
			count = 50,
			ingredients =
			{
				{"science-pack-1", 1},
				{"science-pack-2", 1},
			},
			time = 20
		},
		order = "c-c-d",
	},
})