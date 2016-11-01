require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'
require 'objects/rooms/room'

RoomManager = class()
RoomManager.ON_CHUNK_GENERATED = defines.events.on_chunk_generated

function RoomManager:new(script)
    self._room_ids = table.make_values_weak()
    self._name_counter = 0
end

function RoomManager:create_room(args, ...)
    args.name = tostring(self._name_counter)
    self._name_counter = self._name_counter + 1
    local room = Room:new(args, ...)
    self._room_ids[room:get_index()] = room
    return room
end

function RoomManager:room_exists(id)
    return self._room_ids[id]
end

function RoomManager:load()
    table.make_values_weak(self._room_ids)
    for _,room in pairs(self._room_ids) do
        Room.load(room)
    end
end
