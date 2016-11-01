require 'lib/table-utils'
-- As usual for configs, playing multiplayer will require all players to have
-- the same config as the server.

-- The basic "factory" elements can apply to any factory. These can copied to the specific
-- factory type as well if you wish to override a particular setting for a given variant.

local config = {}
config.constants = {}
config.constants.ALWAYS_DAY = 0
config.constants.ALWAYS_NIGHT = 0.5
config.constants.SAME_AS_OUTSIDE = 1

config.constants.NO_FACTORY_IN_FACTORY = 0
config.constants.ONLY_SMALLER_IN_LARGER = 1
config.constants.ONLY_SMALLER_IN_LARGER_OR_EQUAL = 2
config.constants.ANY_FACTORY_IN_FACTORY = 3
local KW, MW, GW = 1000, 1000000, 1000000000
local KJ, MJ, GJ = KW, MW, GW

-- START EDITING FROM BELOW THIS LINE.

config.factory = { --Generic settings for all kinds of Factory.
    -- How much power any kind of factory can store
    -- Note: If this value is set too small relative to the power limits,
    -- then this will lower the effective power limits.
    power_buffer = 10 * MJ,
    -- How much of the power sent into any factory arrives inside
    -- 1 means lossless transfer, 0 means no power arrives inside at all.
    power_multiplier = 1.0,
    -- Daytime in factories
    -- After changing configs, load your game and visit all existing
    -- factories to automatically update their daytimes. using SAME_AS_OUTSIDE
    -- will cause the factory to use the same time cycle as whatever is outside it.
    -- If that happens to be another factory then it'll depend on that.
    time = config.constants.ALWAYS_DAY,
    -- Pollution multiplier.
    -- The default is 1.0 which is 100% of inside pollution going outside.
    -- 0.5 would be 50%, 2 would be 200%
    pollution_multiplier = 1.0,
    -- Factory recursion. (factories inside factories, factory-ception)
    -- Note: Changing this config will not prevent you from *placing*
    -- factories anywhere. However if you place factories where they are
    -- not supposed to be, they will simply not work and not connect to
    -- anything, and you won't be able to enter them.
    --
    -- Changing this config mid-game will not disconnect preexisting
    -- wrongly nested factories, but it will prevent you from entering
    -- them. To be able to enter such interior factories again, mine them
    -- and place them back down in the overworld.
    recursion = config.constants.ANY_FACTORY_IN_FACTORY,
}
config.small_power_plant = { --currently just known as "power plant"
    -- How much power can leave a power plant
    power_limit = 500 * MW,
    -- How much of the power produced in a power plant arrives outside
    -- 1 means lossless transfer, 0 means no power arrives outside at all.
    power_multiplier = 1.0,
    -- Same deal as above.
    time = config.constants.ALWAYS_NIGHT,
}
config.small_factory = { --currently just known as "factory"
    --How much power can enter a factory
    power_limit = 50 * MW,
}

--Config ends here. Don't edit anything after this line.

setmetatable(config.small_factory, { __index = config.factory})
setmetatable(config.small_power_plant, { __index = config.factory})
return config
