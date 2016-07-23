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
		name = "relay-combinator",
		enabled = false,
		ingredients =
		{
			{"constant-combinator", 1},
		},
		energy_required = .1,
		result = "relay-combinator",
		requester_paste_multiplier = 1
	},
})