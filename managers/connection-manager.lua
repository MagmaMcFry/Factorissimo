require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'

ConnectionManager = class()
ConnectionManager.CONNECTIONS = {}
ConnectionManager.CONNECTIONS["transport-belt"] = require('objects/connections/belt-connection')
ConnectionManager.CONNECTIONS["pipe"] = require('objects/connections/pipe-connection')
ConnectionManager.CONNECTIONS["pipe-to-ground"] = require('objects/connections/pipe-connection')
ConnectionManager.CONNECTIONS["inserter"] = require('objects/connections/inserter-connection')
ConnectionManager.MAX_TICKS_FOR_UPDATE = 100

function ConnectionManager:new()
    self._connections = {}
    self:_setup_for_build()
end

function ConnectionManager:valid_connection_types()
    return self.CONNECTIONS
end

function ConnectionManager:_setup_for_build()
    local on_build = callback(self._on_build, self)
    managers.event:register(defines.events.on_built_entity, self, on_build)
    managers.event:register(defines.events.on_robot_built_entity, self, on_build)
end

function ConnectionManager:_setup_for_connections()
    if #self._connections == 0 then
        managers.event:unregister(defines.events.on_tick, self)
        return
    end
    managers.event:register(defines.events.on_tick, self, callback(self._on_tick, self))
end

function ConnectionManager:try_connect(source, target_surface, x, y, dirs, swap)
    local impl = self.CONNECTIONS[source.type]
    if not impl then
        return
    end
    local inst = impl:new({entity = source, surface = target_surface, info = {x = x, y = y}, valid_dirs = dirs, swap = swap})
    if inst:try_connect() then
        table.insert(self._connections, { impl = source.type, inst = inst })
        self:_setup_for_connections()
        return inst
    end
end

function ConnectionManager:_on_build(event)
    local entity = event.created_entity
    if self.CONNECTIONS[entity.type] then
        managers.factory:try_connect_entity(entity)
    end
end

function ConnectionManager:_on_tick(event)
    local conns, i = self._connections, 1
    while i <= #conns do
        local inst = conns[i].inst
        if inst:valid() then
            inst:update()
            i = i + 1
        else
            table.remove(conns, i).inst:destroy()
            self:_setup_for_connections()
        end
    end
end

function ConnectionManager:load()
    table.seq_collect(self._connections, function(_, o) self.CONNECTIONS[o.impl].load(o.inst) end)
    self:_setup_for_build()
    self:_setup_for_connections()
end
