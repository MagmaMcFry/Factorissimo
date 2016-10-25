require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'

EventManager = class()

function EventManager:new()
    self:_create_ephemeral_event_table()
end

function EventManager:_create_ephemeral_event_table()
    self._event = table.make_unserializable_table({ _callbacks = {}, _handlers = {} })
end

function EventManager:register(event_id, id, callback)
    assert(type(event_id) == "number", "attempt to pass non-numeric eventID")
    assert(id and type(id) ~= "boolean", "attempt to pass nil or boolean id")
    assert(type(callback) == "function", "attempt to pass non-function callback")
    if not self._event._callbacks[event_id] then
        self:_register_for_event(event_id)
    end
    self._event._callbacks[event_id][id] = callback
end

function EventManager:unregister(event_id, id)
    self._event._callbacks[event_id][id] = nil
    if table.size(self._event._callbacks[event_id]) == 0 then
        self:_unregister_from_event(event_id)
    end
end

function EventManager:_register_for_event(event_id)
    self._event._callbacks[event_id] = {}
    self._event._handlers[event_id] = callback(self._on_event, self, event_id)
    self:_register_event(event_id, self._event._handlers[event_id])
end

function EventManager:_unregister_from_event(event_id)
    script.on_event(event_id, nil)
    self._event._callbacks[event_id] = nil
    self._event._handlers[event_id] = nil
end

function EventManager:_register_event(event_id, clbk)
    script.on_event(event_id, clbk)
end

function EventManager:_on_event(event_id, ...)
    for _, clbk in pairs(self._event._callbacks[event_id]) do
        clbk(...)
    end
end

function EventManager:load()
    self:_create_ephemeral_event_table()
end