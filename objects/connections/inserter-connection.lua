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
    --elseif self:_is_hand_empty_and_idle() then --currently unnecessary
        --self:_try_give_to_inserter_for_input()
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
--[[ BEGIN UNUSED CODE, DELETE AFTER COMMIT
function InserterConnection:_try_give_to_inserter_for_input()
    local inserter = self._source_entity
    local source, item, count = self:_try_get_item_stack(inserter.pickup_target)
    if source and item and count then --SimpleStack
        count = math.min(count, self._stack_max)
        inserter.held_stack.set_stack({name = item, count = count})
        source.remove_item({name = item, count = count})
    elseif source and source.valid_for_read then --LuaItemStack
        local old_count = source.count
        source.count = math.min(count, self._stack_max)
        inserter.held_stack.set_stack(source)
        local new_count = old_count - source.count
        if new_count ~= 0 then
            source.count = new_count
        else
            source.clear()
        end
    end
end

function InserterConnection:_try_get_item_stack(target)
    if target and target.valid then
        local type = target.type
        if type:find("belt") or type:find("splitter") then
            return self:_try_get_belt_item_stack(target)
        else
            return self:_try_get_inventory_item_stack(target)
        end
    end
end

function InserterConnection:_try_get_belt_item_stack(target)
    local belt = nil
    for _,line in pairs(defines.transport_line) do
        pcall(function() belt = target.get_transport_line(line) end)
        if belt and belt.valid then
            for k,v in pairs(belt.get_contents()) do
                return belt, k, v
            end
        end
    end
end

function InserterConnection:_try_get_inventory_item_stack(target, ins)
    local types = self.INV_TYPES
    for i = 1, #types do
        local inv = target.get_inventory(types[i])
        if inv and inv.valid then
            local item = self:_try_get_item_from_inventory(inv, ins)
            if item then
                return item
            end
        end
    end
end
--]]
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
