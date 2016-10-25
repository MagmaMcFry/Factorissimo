require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'

FactoryGUIHelper = class()

function FactoryGUIHelper:new(manager)
    self._input_boxes = {}
    self._load_buttons = {}
    self._preview_buttons = {}
    self._manager = manager
    self._inactive_rooms = manager._inactive_rooms
    self._player_saved_rooms = manager._player_saved_rooms
end

function FactoryGUIHelper:show_room_save_gui(player, room, impl)
    local s_room = tostring(room)
    local char = player.character
    player.character = nil
    local gui = player.gui.center
    local frame = gui.add({ type = "frame", name = s_room .. "s_frame", style = "factory_save_frame", caption = {"description.save-factory-layout"}})
    frame.add({ type = "label", name = s_room .. "s_label", style="factory_name_label", caption = {"description.save-layout-name"}})
    local input = frame.add({ type = "textfield", name = s_room .. "layout_name", style = "factory_name_input"})
    local save = frame.add({ type = "button", name = s_room, caption = {"description.save-btn"}})
    local nuke = frame.add({ type = "button", name = "D"..s_room, caption = {"description.nuke-btn"} })
    self._input_boxes[room] = { input = input, btn = save, nuke = nuke, impl = impl, player = player, char = char, root = frame }
    managers.gui:register(save, callback(self._on_save_selected, self, input, impl, player, char, frame))
    managers.gui:register(nuke, callback(self._on_nuke_selected, self, input, player, char, frame))
end


function FactoryGUIHelper:show_factory_load_gui(player, entity)
    local impl = entity.name
    local s_entity = tostring(entity.unit_number)
    local gui = player.gui.center
    local frame = gui.add({type = "frame", name = s_entity .. "l_frame", style = "factory_save_frame", caption = {"description.load-factory-layout"}})
    frame.direction = "vertical"
    local tbl = frame.add({type = "table", name = s_entity .. "l_table", colspan = 1})
    local label = tbl.add({ type = "label", name = s_entity .. "l_label", style = "factory_name_label", caption = {"description.choose-layout"}})
    label.style.minimal_width = 400
    label.style.maximal_width = 400
    self:_setup_load_buttons(tbl, frame, impl, entity, player, s_entity)
    player.character = nil
end

function FactoryGUIHelper:_on_save_selected(input, impl, player, char, root, event)
    local room, impl_saved = tonumber(event.element.name), self._player_saved_rooms[impl]
    local force = player.force.name or 1
    self:_restore_player_character(player, char)
    impl_saved[force] = impl_saved[force] or {}
    impl_saved[force][room] = input.text
    self._input_boxes[room] = nil
    root.destroy()
end

function FactoryGUIHelper:_on_nuke_selected(input, player, char, root, event)
    if event.element.caption[1] == "description.nuke-btn" then
        event.element.caption = {"description.nuke-confirm-btn"}
        event.element.style.font_color = { r = 1, g = 0, b = 0 }
        return
    end
    local room = tonumber(event.element.name:sub(2, -1))
    self:_restore_player_character(player, char)
    self._inactive_rooms[room]:destroy()
    self._inactive_rooms[room] = nil
    self._input_boxes[room] = nil
    root.destroy()
end

function FactoryGUIHelper:_restore_player_character(player, char)
    if not char.valid then
        player.create_character()
    else
        player.character = char
    end
end

function FactoryGUIHelper:_setup_load_buttons(top_tbl, root, impl, entity, player, s_entity)
    local scroll = top_tbl.add({ type = "scroll-pane", name = s_entity .. "l_scroll"})
    local new_layout = scroll.add({ type = "button", name = "0", caption = {"description.new-layout"}})
    local tbl = scroll.add({ type = "table", name = s_entity .. "l_subtable", colspan = 2})
    local clbk = callback(self._on_load_selected, self, impl, entity, player, player.character, player.character.surface, player.character.position, root)
    local preview_clbk = callback(self._on_preview_selected, self, player)
    local load_buttons = { impl = impl, entity = entity, player = player, char = player.character, surface = player.character.surface, pos = player.character.position, root = root, btns = {}}
    self._load_buttons[entity.unit_number] = load_buttons
    local preview_buttons = {}
    self._preview_buttons[entity.unit_number] = preview_buttons
    managers.gui:register(new_layout, clbk)
    table.insert(load_buttons.btns, new_layout)
    for room, caption in pairs(self._player_saved_rooms[impl][player.force.name or 1]) do
        local s_room = tostring(room)
        local button = tbl.add({type = "button", name = s_room, caption = caption})
        local preview = tbl.add({type = "button", name = "P" .. s_room, caption = {"description.preview"}})
        table.insert(load_buttons.btns, button)
        table.insert(preview_buttons, preview)
        managers.gui:register(button, clbk)
        managers.gui:register(preview, preview_clbk)
    end
end

function FactoryGUIHelper:_on_load_selected(impl, entity, player, char, surface, pos, root, event)
    local rooms, id, manager = self._player_saved_rooms[impl][player.force.name or 1], tonumber(event.element.name), self._manager
    manager:_create_factory(manager:_get_impl(impl), entity, id ~= 0 and self._inactive_rooms[id] or nil)
    rooms[id] = nil
    self._load_buttons[entity.unit_number] = nil
    player.teleport(pos, surface)
    self:_restore_player_character(player, char)
    root.destroy()
end

function FactoryGUIHelper:_on_preview_selected(player, event)
    local room = self._inactive_rooms[tonumber(event.element.name:sub(2, -1))]
    player.teleport({0,0}, room:get_surface())
end

function FactoryGUIHelper:load()
    for _,v in pairs(self._input_boxes) do
        managers.gui:register(v.btn, callback(self._on_save_selected, self, v.input, v.impl, v.player, v.char, v.root))
        managers.gui:register(v.nuke, callback(self._on_save_selected, self, v.input, v.player, v.char, v.root))
    end
    for id,v in pairs(self._load_buttons) do
        local btns = v.btns
        local clbk = callback(self._on_load_selected, self, v.impl, v.entity, v.player, v.char, v.surface, v.pos, v.root)
        local preview_clbk = callback(self._on_preview_selected, self, v.player)
        for i = 1, #btns do
            managers.gui:register(btns[i], clbk)
            managers.gui:register(self._preview_buttons[id][i], preview_clbk)
        end
    end
end
