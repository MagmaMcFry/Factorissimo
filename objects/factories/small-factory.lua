require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'objects/factories/factory'

SmallFactory = class(Factory)
SmallFactory.LAYOUT = require('objects/factories/layouts/small-factory')
SmallFactory.CONFIG = require('config').small_factory

function SmallFactory:layout_factory(room)
    Factory.layout_factory(self)
    self._entity.electric_input_flow_limit = self.CONFIG.power_limit
    self._power.electric_output_flow_limit = self.CONFIG.power_limit
end

function SmallFactory:transfer_power()
    return Factory._transfer_power(self, self._entity, self._power)
end

return SmallFactory
