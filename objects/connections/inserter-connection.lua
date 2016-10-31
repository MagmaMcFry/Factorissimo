require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'objects/connections/connection'

InserterConnection = class(Connection)
InserterConnection.INPUT = -1
InserterConnection.OUTPUT = 1
InserterConnection.INV_TYPES = {}

table.collect(defines.inventory, function(k,v) 
        if type(k) == "string" and (k == "chest" or k:find("result") or k:find("output")) then
            table.insert(InserterConnection.INV_TYPES, v)
        end
    end)

function InserterConnection:new(args)
    self._bldg = args.surface.bldg
    self._inbox = args.surface.inbox
    self._outbox = args.surface.outbox
    self:_calc_stack_bonus()
    self:_compute_direction()
    managers.event:register(defines.events.on_player_rotated_entity, self, callback(self._on_rotate, self))
    managers.event:register(defines.events.on_research_finished, self, callback(self._calc_stack_bonus, self))
end

function InserterConnection:try_connect()
    return true
end

function InserterConnection:valid()
    return self._source_entity and self._source_entity.valid and
        self._bldg and self._bldg.valid
end

function InserterConnection:update()
    if self._dir then
        return self._dir == self.INPUT and self:_process_input() or self:_process_output()
    end
end

function InserterConnection:destroy()
    self._source_entity = nil
end

function InserterConnection:destroy_for_deconstruct()
    self._source_entity = nil
end

function InserterConnection:_calc_stack_bonus()
    local bonus = self._source_entity.force
    self._stack_max = self._source_entity.name:find("stack") and bonus.stack_inserter_capacity_bonus or (bonus.inserter_stack_size_bonus + 1)
end

function InserterConnection:_is_hand_empty_and_idle()
    local ins = self._source_entity
    return not ins.held_stack.valid_for_read and
        table.equals(ins.held_stack_position, ins.pickup_position)
end

function InserterConnection:_is_hand_full_and_idle()
    local ins = self._source_entity
    return ins.held_stack.valid_for_read and table.equals(ins.held_stack_position, ins.drop_position)
end

function InserterConnection:_try_get_item_from_inventory(inv, ins)
    if ins and ins.filter_slot_count > 0 then
        local item, is_filtered = self:_try_find_items_from_filter(inv, ins)
        if is_filtered then
            return item
        end
    end
    local k,_ = next(inv.get_contents())
    return inv.find_item_stack(k)
end

function InserterConnection:_try_find_items_from_filter(inv, ins)
    local is_filtered = false
    for i = 1, ins.filter_slot_count do
        local f = ins.get_filter(i)
        if f then
            is_filtered = true
            local item = inv.find_item_stack(f)
            if item then
                return item, is_filtered
            end
        end
    end
    return nil, is_filtered
end

function InserterConnection:_process_input()
    if self:_is_hand_full_and_idle() then
        self:_try_take_from_inserter_for_input()
    end
    return true --prevent fallthrough to output
end

function InserterConnection:_process_output()
    if self:_is_hand_empty_and_idle() then
        local ins = self._source_entity
        local inv = self._outbox.get_inventory(defines.inventory.chest)
        if not inv.is_empty() then
            local item = self:_try_get_item_from_inventory(inv, ins)
            if item then
                local count, old_count = math.min(item.count, self._stack_max), item.count
                item.count = count
                if ins.held_stack.set_stack(item) then
                    item.count = old_count - count
                end
            end
        end
    end
    return true
end

function InserterConnection:_try_take_from_inserter_for_input()
    local stack = self._source_entity.held_stack
    local input = self._inbox.get_inventory(defines.inventory.chest)
    local inserted = input.insert(stack)
    if inserted == stack.count then
        stack.clear()
    else
        stack.count = stack.count - inserted
    end
end

function InserterConnection:_on_rotate(event)
    if event.entity == self._source_entity then
        self:_compute_direction()
    end
end

function InserterConnection:_compute_direction()
    local ent, dirs = self._source_entity, defines.direction
    local pos, dir, box = ent.position, ent.direction, self._bldg.bounding_box
    local top_dir = {[dirs.north] = self.OUTPUT, [dirs.south] = self.INPUT}
    local left_dir = {[dirs.east] = self.INPUT, [dirs.west] = self.OUTPUT}
    if pos.y > box.left_top.y then --north
        self._dir = top_dir[dir]
    elseif pos.x > box.right_bottom.x then --east
        self._dir = left_dir[dir] and -left_dir[dir]
    elseif pos.y < box.right_bottom.y then --south
        self._dir = top_dir[dir] and -top_dir[dir]
    elseif pos.x < box.left_top.x then --west, should be guaranteed
        self._dir = left_dir[dir]
    end
end

function InserterConnection:load()
    managers.event:register(defines.events.on_player_rotated_entity, self, callback(self._on_rotate, self))
    managers.event:register(defines.events.on_research_finished, self, callback(self._calc_stack_bonus, self))
end

return InserterConnection
