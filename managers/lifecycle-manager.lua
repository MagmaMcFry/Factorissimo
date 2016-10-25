require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'managers/factory-manager'
require 'managers/room-manager'
require 'managers/event-manager'
require 'managers/connection-manager'
require 'managers/gui-manager'
require 'managers/debug-manager'

LifeCycleManager = class()

function LifeCycleManager:new(script)
    rawset(_G, "managers", {})
    script.on_init(callback(self._on_init, self))
    script.on_load(callback(self._on_load, self))
end

function LifeCycleManager:_on_init()
    if global.update_version then
        error("Migration to newer Factorissimo currently unimplemented.")
    end
    global.managers = managers
    managers.event = EventManager:new()
    managers.factory = FactoryManager:new()
    managers.room = RoomManager:new()
    managers.connection = ConnectionManager:new()
    managers.gui = GUIManager:new()
    managers.debug = require('config').debug and DebugManager:new()
end

function LifeCycleManager:_on_load()
    if global.update_version then
        error("Migration to newer Factorissimo currently unimplemented.")
    end
    managers = global.managers
    EventManager.load(managers.event)
    FactoryManager.load(managers.factory)
    RoomManager.load(managers.room)
    ConnectionManager.load(managers.connection)
    GUIManager.load(managers.gui)
    if managers.debug then
        DebugManager.load(managers.debug)
    end
end
