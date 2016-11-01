require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'helpers/factory-gui-helper'

local dirs = defines.direction
FactoryManager = class()
FactoryManager.FACTORIES = {}
FactoryManager.FACTORIES.small_power_plant = require('objects/factories/power-plant')
FactoryManager.FACTORIES.small_factory = require('objects/factories/small-factory')
FactoryManager.VALID_ENTRY_DIRS = { [dirs.north] = true }
FactoryManager.POLLUTION_T = 60

function FactoryManager:new()
    self._active_factories = {}
    self._active_factories_by_entity = table.make_values_weak()
    self._active_factories_by_room = table.make_values_weak()
    self._inactive_rooms = {}
    self._player_saved_rooms = {}
    self._robot_saved_rooms = {}
    self._iterators = table.make_unserializable_table()
    for impl in pairs(self.FACTORIES) do
        self._player_saved_rooms[impl] = {}
        self._robot_saved_rooms[impl] = {}
    end
    self._gui_helper = FactoryGUIHelper:new(self)
    self:_register_for_events()
end

function FactoryManager:try_connect_entity(entity)
    local id = entity.surface.index
    if managers.room:room_exists(id) then
        return self:_get_factory_by_room(id):scan_for_connections()
    end
    local pos = entity.position
    local s_box = {{pos.x - 1.5, pos.y - 1.5}, {pos.x + 1.5, pos.y + 1.5}}
    local args = {area = s_box, force = entity.force}
    local neighbours = entity.surface.find_entities_filtered(args)
    for i = 1, #neighbours do
        local f_entity = neighbours[i]
        if self.FACTORIES[f_entity.name] then
            self._active_factories_by_entity[f_entity.unit_number]:scan_for_connections(entity)
        end
    end
end

function FactoryManager:_register_for_events()
    self._iterators = table.make_unserializable_table()
    local on_build = callback(self._on_build, self)
    local on_tick = callback(self._on_tick, self)
    local on_mined = callback(self._on_pre_deconstruct, self)
    managers.event:register(defines.events.on_built_entity, self, on_build)
    managers.event:register(defines.events.on_robot_built_entity, self, on_build)
    managers.event:register(defines.events.on_preplayer_mined_item, self, on_mined)
    managers.event:register(defines.events.on_robot_pre_mined, self, on_mined)
    managers.event:register(defines.events.on_tick, self, on_tick)
    self:_reset_pollution_iterator()
end

function FactoryManager:_reset_pollution_iterator()
    self._iterators.pollution = table.make_fair_share_iterator(self.POLLUTION_T, #self._active_factories)
end

function FactoryManager:_get_impl(name)
    return self.FACTORIES[name]
end

function FactoryManager:_get_factory(unit_number)
    return self._active_factories_by_entity[unit_number]
end

function FactoryManager:_get_factory_by_room(surface_index)
    return self._active_factories_by_room[surface_index]
end

function FactoryManager:_on_build(event)
    local entity = event.created_entity
    local impl = self:_get_impl(entity.name)
    if impl then
        local player = game.players[event.player_index]
        if table.is_empty(self._inactive_rooms) then
            return self:_create_factory(impl, entity)
        elseif not player and event.robot then
            local room = self:_load_room_from_robot_stack(event.robot.force.name or 1)
            if not room then --no inactive rooms
                self:_create_factory(impl, entity)
            elseif type(room) == "number" then --robot placed factory
                self:_create_factory(impl, entity, self._inactive_rooms[room])
            end
        else
            local rooms = self._player_saved_rooms[entity.name]
            return rooms and rooms[player.force.name or 1] and self._gui_helper:show_factory_load_gui(player, entity)
        end
    end
end

function FactoryManager:_create_factory(impl, entity, room)
    local inst = impl:new({ entity = entity, game = game, room = room })
    room = inst:get_room():get_index()
    table.insert(self._active_factories, {inst = inst, impl = entity.name })
    self._active_factories_by_entity[entity.unit_number] = inst
    self._active_factories_by_room[room], self._inactive_rooms[room] = inst, nil
    self:_reset_pollution_iterator()
end

function FactoryManager:_on_pre_deconstruct(event)
    local entity, id, player = event.entity, event.entity.unit_number, event.player_index
    local factory = self._active_factories_by_entity[id]
    if factory then
        local room = factory:get_room()
        self._inactive_rooms[room:get_index()] = room
        factory:deconstruct()
        table.remove_by_pred(self._active_factories, function(f) return f.inst == factory end)
        self:_reset_pollution_iterator()
        if player then
            self._gui_helper:show_room_save_gui(game.players[player], room:get_index(), entity.name)
        elseif event.robot then
            self:_save_room_to_robot_stack(room:get_index(), event.robot.force.name or 1)
        end
    end
end

function FactoryManager:_on_tick(event)
    for i = 1, #game.connected_players do
        self:_on_tick_process_player(game.connected_players[i])
    end
    local factories = self._active_factories
    local s, i = coroutine.resume(self._iterators.pollution)
    while i do
        factories[i].inst:pollute_environment()
        s, i = coroutine.resume(self._iterators.pollution)
    end
    for i = 1, #factories do
        factories[i].inst:transfer_power()
    end
end

function FactoryManager:_on_tick_process_player(player)
    if player.character and not player.vehicle then
        if managers.room:room_exists(player.surface.index) then
            if not self:_check_should_player_leave_factory(player, player.position) then
                self:_check_should_player_enter_factory(player, player.position)
            end
        else
            self:_check_should_player_enter_factory(player, player.position)
        end
    end
end

function FactoryManager:_check_should_player_enter_factory(player, ppos)
    local args = {}
    args.area = {{ppos.x - 0.2, ppos.y - 0.3}, {ppos.x + 0.2, ppos.y}}
    for _, entity in pairs(player.surface.find_entities_filtered(args)) do
        local factory = self:_get_factory(entity.unit_number)
        if factory and factory:force() == player.force then
            local distance = math.abs(entity.position.x - ppos.x)
            if distance < 0.6 and self.VALID_ENTRY_DIRS[player.character.direction] then
                factory:move_player_inside(player)
                return true
            end
        end
    end
end

function FactoryManager:_check_should_player_leave_factory(player, ppos)
    local args = {}
    args.area = {{ppos.x + 2, ppos.y - 3}, {ppos.x + 6, ppos.y - 2}}
    args.name = "factory-power-distributor"
    local entity = player.surface.find_entities_filtered(args)
    local factory = self:_get_factory_by_room(player.surface.index)
    if #entity > 0 and factory then
        factory:move_player_outside(player)
        return true
    end
end

function FactoryManager:_save_room_to_robot_stack(room, force)
    local rooms = self._robot_saved_rooms
    rooms[force] = rooms[force] or {} 
    table.insert(rooms[force], room)
end

function FactoryManager:_load_room_from_robot_stack(force)
    local rooms = self._robot_saved_rooms
    return rooms[force] and table.remove(self._robot_saved_rooms[force])
end

function FactoryManager:_collect(_, member)
    self.FACTORIES[member.impl].load(member.inst)
end

function FactoryManager:load()
    table.make_values_weak(self._active_factories_by_entity)
    table.make_values_weak(self._active_factories_by_room)
    table.seq_collect(self._active_factories, callback(self._collect, self))
    FactoryGUIHelper.load(self._gui_helper)
    self:_register_for_events()
end
