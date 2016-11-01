require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'objects/connections/connection'

PipeConnection = class(Connection)

function PipeConnection:new(args)
    self._source_entity = args.entity
    self._dest_entity = nil
    self._info = args.info
    self._valid_dirs = args.entity.name ~= "pipe" and self._valid_dirs or nil
    self._surface = args.surface
    self._tick_target = 1
end

function PipeConnection:_move_items()
    local s_fbox, d_fbox = self._source_entity.fluidbox, self._dest_entity.fluidbox
    local from, to = s_fbox[1], d_fbox[1]
    if from and to then
        if from.type == to.type then
            local amount = from.amount + to.amount
            local temp = (from.amount * from.temperature) + (to.amount * to.temperature) / amount
            from.amount, from.temperature = amount/2, temp
            to.amount, to.temperature = amount/2, temp
            s_fbox[1] = from
            d_fbox[1] = to
        end
    elseif from or to then
        from = from or to
        from.amount = from.amount/2
        s_fbox[1] = from
        d_fbox[1] = from
    end
end

return PipeConnection
