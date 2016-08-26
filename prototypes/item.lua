data:extend({
  {
    type = "item",
    name = "small-factory",
    icon = "__Factorissimo__/graphics/icons/small-factory.png",
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "y[factory]-a[small-factory]",
    place_result = "small-factory",
    stack_size = 10
  },
  {
    type = "item",
    name = "factory-power-provider",
    icon = "__base__/graphics/icons/accumulator.png",
    flags = {"hidden"},
    subgroup = "production-machine",
    order = "y[factory]-z[invisible]-a",
    place_result = "factory-power-provider",
    stack_size = 50
  },
  {
    type = "item",
    name = "small-power-plant",
    icon = "__Factorissimo__/graphics/icons/small-power-plant.png",
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "y[factory]-b[small-power-plant]",
    place_result = "small-power-plant",
    stack_size = 10
  },
  {
    type = "item",
    name = "factory-power-receiver",
    icon = "__base__/graphics/icons/accumulator.png",
    flags = {"hidden"},
    subgroup = "production-machine",
    order = "y[factory]-z[invisible]-b",
    place_result = "factory-power-receiver",
    stack_size = 50
  },
  {
    type = "item",
    name = "factory-power-distributor",
    icon = "__base__/graphics/icons/substation.png",
    flags = {"hidden"},
    subgroup = "production-machine",
    order = "y[factory]-z[invisible]-c",
    place_result = "factory-power-distributor",
    stack_size = 50
  },
})