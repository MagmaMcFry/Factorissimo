-- As usual for configs, playing multiplayer will require all players to have the same config as the server.

-- How much power a factory or power plant can store
-- Note: If this value is set too small relative to the power limits, then this will lower the effective power limits.
factorissimo.config.power_buffer = "10MJ"

-- How much power can enter a factory
factorissimo.config.power_input_limit = "50MW"

-- How much of the power sent into a factory arrives inside
-- 1 means lossless transfer, 0 means no power arrives inside at all.
factorissimo.config.power_input_multiplier = 1.0

-- How much power can leave a power plant
factorissimo.config.power_output_limit = "50MW"

-- How much of the power produced in a power plant arrives outside
-- 1 means lossless transfer, 0 means no power arrives outside at all.
factorissimo.config.power_output_multiplier = 1.0

-- Daytime in factories (2 is always day, 1 is regular day/night, 0 is always night)
-- After changing configs, load your game and visit all existing factories to automatically update their daytimes
factorissimo.config.factory_daytime = 2

-- Daytime in power plants (2 is always day, 1 is regular day/night, 0 is always night)
-- After changing configs, load your game and visit all existing power plants to automatically update their daytimes
factorissimo.config.power_plant_daytime = 0

-- How much of the pollution inside arrives outside
-- 1 means all pollution inside is transferred outside, 0 means all pollution inside is destroyed.
-- 2 means pollution is doubled!
factorissimo.config.pollution_multiplier = 1.0
