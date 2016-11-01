data:extend({
	{
		type = "recipe",
		name = "small_factory",
		enabled = false,
		ingredients =
		{
			{"steel-plate", 100},
			{"stone-brick", 500},
		},
		energy_required = 30,
		result = "small_factory",
		requester_paste_multiplier = 1
	},
	{
		type = "recipe",
		name = "small_power_plant",
		enabled = false,
		ingredients =
		{
			{"steel-plate", 100},
			{"stone-brick", 500},
			{"copper-plate", 100},
		},
		energy_required = 30,
		result = "small_power_plant",
		requester_paste_multiplier = 1
	},
})