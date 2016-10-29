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
			}
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
		order = "c-c-d"
	},
	{
		type = "technology",
		name = "factory-architecture-2",
		icon = "__base__/graphics/technology/automated-construction.png",
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "medium-factory"
			},
			{
				type = "unlock-recipe",
				recipe = "medium-power-plant"
			}
		},
		prerequisites = { "factory-architecture", "concrete" },
		unit =
		{
			count = 100,
			ingredients =
			{
				{"science-pack-1", 1},
				{"science-pack-2", 1},
			},
			time = 20
		},
		order = "c-c-d-a",
		enabled = factorissimo.config.maximum_tier >= 1
	},
	{
		type = "technology",
		name = "factory-architecture-3",
		icon = "__base__/graphics/technology/automated-construction.png",
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "large-factory"
			},
			{
				type = "unlock-recipe",
				recipe = "large-power-plant"
			}
		},
		prerequisites = { "factory-architecture-2", "construction-robotics" },
		unit =
		{
			count = 250,
			ingredients =
			{
				{"science-pack-1", 1},
				{"science-pack-2", 1},
				{"science-pack-3", 1}
			},
			time = 30
		},
		order = "c-c-d-b",
		enabled = factorissimo.config.maximum_tier >= 2
	},
	{
		type = "technology",
		name = "factory-architecture-4",
		icon = "__base__/graphics/technology/automated-construction.png",
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "low-density-structure"
			},
			{
				type = "unlock-recipe",
				recipe = "huge-factory"
			},
			{
				type = "unlock-recipe",
				recipe = "huge-power-plant"
			}
		},
		prerequisites = { "factory-architecture-3" },
		unit =
		{
			count = 500,
			ingredients =
			{
				{"science-pack-1", 1},
				{"science-pack-2", 1},
				{"science-pack-3", 1}
			},
			time = 30
		},
		order = "c-c-d-c",
		enabled = factorissimo.config.maximum_tier >= 3
	}
})