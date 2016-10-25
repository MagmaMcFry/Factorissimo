require 'lib/explicit-global'
require 'lib/table-utils'

--do not attempt to optimise, results in becoming a non-function
--and failing a later check
local function loadMetaTable(...)
    local ret = getmetatable(...)()
    return ret
end

local function pv_error()
    local i, info = 1, debug.getinfo(1, "nSl")
    while info do
        print(info.short_src, info.name, info.linedefined)
        i = i + 1
        info = debug.getinfo(i, "nSl")
    end
    error("FATAL: Attempt to create instance of pure virtual class.")
end

function class(base, is_pure_virtual)
    local mt = {}
    local def = { __class = true }
    local function find_method(_,k)
        return def[k] or base[k]
    end
    local inst_mt = { __index = base and find_method or def }
    function mt:__inew(...)
        if base then
            loadMetaTable(base).__inew(self, ...)
        end
        if mt.new then
            mt.new(self, ...)
        end
    end
    function mt:__new(...)
        local ret = setmetatable({}, inst_mt)
        if base then
            loadMetaTable(base).__inew(ret, ...)
        end
        if mt.new then
            mt.new(ret, ...)
        end
        return ret
    end
    function mt:__iload(...)
        if base then
            loadMetaTable(base).__iload(self, ...)
        end
        if mt.load then
            mt.load(self, ...)
        end
    end
    function mt:__load(...)
        if not is_pure_virtual and not getmetatable(self) then
            setmetatable(self, inst_mt)
            if base then
                loadMetaTable(base).__iload(self, ...)
            end
            return mt.load and mt.load(self, ...) 
        end
    end
    function mt:__index(k)
        if k == "new" then
            return is_pure_virtual and pv_error() or mt.__new
        elseif k == "load" then
            return mt.__load
        elseif k == "localise_methods" or k == "unlocalise_methods" then
            return mt[k]
        end
        return base and base[k]
    end
    function mt:__newindex(k, v)
        if k == "new" or k == "load" then
            mt[k] = v
        elseif k ~= "localise_methods" and k~= "unlocalise_methods" then
            rawset(self, k, v)
        end
    end
    function mt:conf_instance_methods(localise)
        if base then
            loadMetaTable(base).conf_instance_methods(self, localise)
        end
        for k,v in pairs(def) do
            rawset(self, k, localise and v or nil)
        end
        return self
    end
    function mt:localise_methods()
        if not self._localised then
            self.__localised = true
            return mt.conf_instance_methods(self, true)
        end
    end
    function mt:unlocalise_methods()
        if self.__localised then
            self.__localised = nil
            return mt.conf_instance_methods(self, false)
        end
    end
    function mt:__metatable()
        return debug.getinfo(2, "f").func == loadMetaTable and mt or 0
    end
    return setmetatable(def, mt)
end

function virtual_class(base)
    return class(base, true)
end

function callback(func, ...)
    assert(type(func) == "function", "attempt to create callback of non-function type")
    local args = table.pack(...)
    return function(...)
        return func(table.unpack(table.pack_merge(args, table.pack(...))))
    end
end
