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
		name = "medium-factory",
		enabled = false,
		ingredients =
		{
			{"small-factory", 2},
			{"steel-plate", 100},
			{"concrete", 200},
		},
		energy_required = 30,
		result = "medium-factory",
		requester_paste_multiplier = 1
	},
	{
		type = "recipe",
		name = "large-factory",
		enabled = false,
		ingredients =
		{
			{"medium-factory", 2},
			{"steel-plate", 200},
			{"concrete", 400},
		},
		energy_required = 30,
		result = "large-factory",
		requester_paste_multiplier = 1
	},
	{
		type = "recipe",
		name = "huge-factory",
		enabled = false,
		ingredients =
		{
			{"large-factory", 2},
			{"low-density-structure", 30},
			{"concrete", 600},
		},
		energy_required = 30,
		result = "huge-factory",
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
	{
		type = "recipe",
		name = "medium-power-plant",
		enabled = false,
		ingredients =
		{
			{"small-power-plant", 2},
			{"steel-plate", 100},
			{"concrete", 200},
		},
		energy_required = 30,
		result = "medium-power-plant",
		requester_paste_multiplier = 1
	},
	{
		type = "recipe",
		name = "large-power-plant",
		enabled = false,
		ingredients =
		{
			{"medium-power-plant", 2},
			{"steel-plate", 200},
			{"concrete", 400},
		},
		energy_required = 30,
		result = "large-power-plant",
		requester_paste_multiplier = 1
	},
	{
		type = "recipe",
		name = "huge-power-plant",
		enabled = false,
		ingredients =
		{
			{"large-power-plant", 2},
			{"low-density-structure", 30},
			{"concrete", 600},
		},
		energy_required = 30,
		result = "huge-power-plant",
		requester_paste_multiplier = 1
	}
})