require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'objects/connections/connection'

BeltConnection = class(Connection)
BeltConnection.LEFT = defines.transport_line.left_line
BeltConnection.RIGHT = defines.transport_line.right_line

function BeltConnection:_move_items()
    for i = self.LEFT, self.RIGHT do
        local from = self._source_entity.get_transport_line(i)
        local to = self._dest_entity.get_transport_line(i)
        for item in pairs(from.get_contents()) do
            local stack = {name = item, count = 1}
            if to.insert_at(0.75, stack) then
                from.remove_item(stack)
            end
        end
    end
end

function BeltConnection:try_connect(...)
    if Connection.try_connect(self, ...) then
        self._tick_target = (9/32)/self._source_entity.prototype.belt_speed
        return true
    end
end

return BeltConnection
