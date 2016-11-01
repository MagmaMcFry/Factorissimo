require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'objects/factories/factory'

PowerPlant = class(Factory)
PowerPlant.LAYOUT = require('objects/factories/layouts/power-plant')
PowerPlant.CONFIG = require('config').small_power_plant

function PowerPlant:layout_factory()
    Factory.layout_factory(self) --do generic stuff first
    self._entity.electric_output_flow_limit = self.CONFIG.power_limit
    self._power.electric_input_flow_limit = self.CONFIG.power_limit
end

function PowerPlant:transfer_power()
    return Factory._transfer_power(self, self._power, self._entity)
end

return PowerPlant
