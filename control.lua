serpent = require('lib/serpent')
require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'managers/lifecycle-manager'

rawset(_G, "factorissimo", LifeCycleManager:new(script))
