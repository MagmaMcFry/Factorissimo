data:extend({
  {
    type = "item",
    name = "small_factory",
    icon = "__Factorissimo__/graphics/icons/small-factory.png",
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "y[factory]-a[small-factory]",
    place_result = "small_factory",
    stack_size = 10
  },
  {
    type = "item",
    name = "factory-power-transferrer",
    icon = "__base__/graphics/icons/accumulator.png",
    flags = {"hidden"},
    subgroup = "production-machine",
    order = "y[factory]-z[invisible]-a",
    place_result = "factory-power-transferrer",
    stack_size = 50
  },
  {
    type = "item",
    name = "small_power_plant",
    icon = "__Factorissimo__/graphics/icons/small-power-plant.png",
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "y[factory]-b[small-power-plant]",
    place_result = "small_power_plant",
    stack_size = 10
  },
  {
    type = "item",
    name = "factory-power-distributor",
    icon = "__base__/graphics/icons/substation.png",
    flags = {"hidden"},
    subgroup = "production-machine",
    order = "y[factory]-z[invisible]-b",
    place_result = "factory-power-distributor",
    stack_size = 50
  },
  {
	  type = "item",
	  name = "factory-chest-output",
	  icon = "__base__/graphics/icons/logistic-chest-passive-provider.png",
	  flags = {"hidden"},
	  subgroup = "logistic-network",
	  order = "y[factory]-z[invisible]-c",
	  place_result = "factory-chest-output",
	  stack_size = 50,
  },
  {
	  type = "item",
	  name = "factory-chest-input",
	  icon = "__base__/graphics/icons/logistic-chest-requester.png",
	  flags = {"hidden"},
	  subgroup = "logistic-network",
	  order = "y[factory]-z[invisible]-d",
	  place_result = "factory-chest-input",
	  stack_size = 50,
  },
})