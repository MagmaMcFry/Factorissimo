local mt = getmetatable(_G) or {}

local function print_error(msg)
    local info = debug.getinfo(3, "nSl")
    local caller = info and info.short_src .. "(" .. info.linedefined .. ")" or ""
    error(caller .. "\n" .. msg)
end

--Prevent accidental pollution of global space
function mt:__newindex(k, v)
    if debug.getinfo(2, "n") and type(v) ~= "function" and
        (type(v) ~= "table" or not rawget(v, "__class")) then
        print_error("Assignment of undefined global ".. k)
    end
    rawset(self, k, v)
end

function mt:__index(k)
    print_error("Use of undefined global " .. k)
end

setmetatable(_G, mt)
