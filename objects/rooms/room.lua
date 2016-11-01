require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'

Room = class()

Room.NAME_PREFIX = "FactorissimoRoom"

function Room:new(args)
    self._surface = args.game.create_surface(self.NAME_PREFIX .. args.name, args.size)
    self._exit_surface = args.exit_surface
    self._name = args.name
    self._entities = {}
    self._size = args.size
    local gen_type = defines.chunk_generated_status.entities
    for x = -args.size.width + 1, args.size.width - 1 do
        for y = -args.size.height + 1, args.size.height - 1 do
            self._surface.set_chunk_generated_status({x, y}, gen_type)
        end
    end
end

function Room:find_entity(name)
    for _,entity in pairs(self._entities) do
        if entity.valid and entity.name == name then
            return entity
        end
    end
end

function Room:get_name()
    return self._name
end

function Room:get_index()
    return self._surface.index
end

function Room:get_surface()
    return self._surface
end

function Room:get_exit_surface()
    return self._exit_surface
end

function Room:set_tiles(...)
    return self._surface.set_tiles(...)
end

function Room:create_entity(name, x, y, force, direction)
    local args = {}
    args.name = name
    args.position = { x, y }
    args.force = force
    args.direction = direction
    local ret = self._surface.create_entity(args)
    self._entities[ret.unit_number] = ret
    return ret
end

function Room:make_entity_permanent(entity)
    entity.minable = false
    entity.rotatable = false
    entity.destructible = false
end

function Room:set_daytime(time, is_frozen)
    self._surface.daytime = time
    self._surface.freeze_daytime(is_frozen)
end

function Room:player_enter_room(player, x, y)
    player.teleport({x, y}, self._surface)
end

function Room:player_exit_room(player, x, y)
    player.teleport({x, y}, self._exit_surface)
end

function Room:transfer_pollution(target_pos, multiplier)
    local x_r, x_zskip = bit32.rshift(self._size.width, 1), bit32.band(self._size.width, 1) == 0
    local y_r, y_zskip = bit32.rshift(self._size.height, 1), bit32.band(self._size.height, 1) == 0
    for x = -x_r, x_r do
        if x ~= 0 or not x_zskip then
            for y = -y_r, y_r do
                if y ~= 0 or not y_zskip then
                    local pollution = self._surface.get_pollution({x, y})
                    self._surface.pollute({x, y}, -pollution/2)
                    self._exit_surface.pollute(target_pos, (pollution/2) * multiplier)
                end
            end
        end
    end
end

function Room:destroy()
    self._entities = {}
    game.delete_surface(self._surface)
    self._surface = nil
end
