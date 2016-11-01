require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'

Connection = virtual_class()

function Connection:new(args)
    self._source_entity = args.entity
    self._dest_entity = nil
    self._info = args.info
    self._valid_dirs = args.valid_dirs
    self._surface = args.surface
    self._swap = args.swap
end

function Connection:try_connect()
    local entity = self._source_entity
    if self._valid_dirs and not self._valid_dirs[entity.direction] then
        return
    end
    local info = self._info
    local args = { name = entity.name, position = {info.x, info.y},
        force = self._source_entity.force, direction = self._source_entity.direction }
    self._dest_entity = self._surface.create_entity(args)
    self._tick = 1
    if self._valid_dirs then
        self:_lock_entity_rotations()
    end
    if self._swap then
        self._source_entity, self._dest_entity = self._dest_entity, self._source_entity
    end
    return self._dest_entity ~= nil
end

function Connection:update()
    if not self._dest_entity then
        return
    end
    if self._tick == self._tick_target then
        self._tick = 0
        self:_move_items()
    end
    self._tick = self._tick + 1
end

function Connection:valid()
    return self._source_entity and self._source_entity.valid
        and self._dest_entity and self._dest_entity.valid
end

function Connection:_lock_entity_rotations()
    self._source_entity.rotatable = false
    self._dest_entity.rotatable = false
end

function Connection:destroy_for_deconstruct(ignored_surface)
    local entity = self._dest_entity.surface == ignored_surface and self._dest_entity or self._source_entity
    entity.destroy()
    self._dest_entity = nil
    self._source_entity = nil
end

function Connection:destroy()
    if self._dest_entity then
        if self._dest_entity.valid then
            self._dest_entity.destroy()
        end
        self._dest_entity = nil
    end
    if self._source_entity then
        if self._source_entity.valid then
            self._source_entity.destroy()
        end
        self._source_entity = nil
    end
end
