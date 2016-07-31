data:extend({
	{
		type = "recipe",
		name = "small-factory",
		enabled = false,
		ingredients =
		{
			{"steel-plate", 100},
			{"stone-brick", 500},
		},
		energy_required = 30,
		result = "small-factory",
		requester_paste_multiplier = 1
	},
	{
		type = "recipe",
		name = "small-power-plant",
		enabled = false,
		ingredients =
		{
			{"steel-plate", 100},
			{"stone-brick", 500},
			{"copper-plate", 100},
		},
		energy_required = 30,
		result = "small-power-plant",
		requester_paste_multiplier = 1
	},
})