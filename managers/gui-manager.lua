require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'

GUIManager = class()

function GUIManager:new()
    self._clbks = table.make_keys_weak(table.make_unserializable_table())
end

function GUIManager:register(element, clbk)
    self._clbks[element] = clbk
    managers.event:register(defines.events.on_gui_click, self, callback(self._on_click, self))
end

function GUIManager:unregister(element)
    for k,_ in pairs(self._clbks) do
        if k == element then
            self._clbks[k] = nil
        end
    end
    self._clbks[element] = nil
    if table.is_empty(self._clbks) then
        managers.event:unregister(defines.events.on_gui_click, self)
    end
end

function GUIManager:_on_click(event)
    for k,clbk in pairs(self._clbks) do
        if k == event.element then
            return clbk(event)
        end
    end
end

function GUIManager:load()
    self._clbks = table.make_keys_weak(table.make_unserializable_table())
end
