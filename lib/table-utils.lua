function table.size(t)
	local count = 0
	for _,_ in pairs(t) do
		count = count + 1
	end
	return count
end

function table.is_empty(t)
	for _ in pairs(t) do
		return false
	end
	return true
end

function table.equals(a, b)
	if table.size(a) ~= table.size(b) then
		return false
	end
	for k,v in pairs(a) do
		if type(b[k]) ~= type(v) then
			return false
		end
		if type(v) == "table" then
			if not table.equals(b[k], v) then
				return false
			end
		elseif b[k] ~= v then
			return false
		end
	end
	return true
end

function table.remove_by_pred(tbl, pred)
	for i = 1, #tbl do
		if pred(tbl[i]) then
			return table.remove(tbl, i)
		end
	end
end

function table.copy_pred(src, dst, pred)
    for k,v in pairs(src) do
        if pred(k,v) then
            dst[k] = v
        end
    end
end

function table.collect(tbl, pred)
	for k,v in pairs(tbl) do
		pred(k, v)
	end
end

function table.seq_collect(tbl, pred)
	for i = 1, #tbl do
		pred(i, tbl[i])
	end
end

function table.deep_clone(src, dst)
    dst = dst or {}
    for k,v in pairs(src) do
        if type(v) == "table" then
            dst[k] = table.deep_clone(v)
        else
            dst[k] = v
        end
    end
	return dst
end

-- merges N tables produced by table.pack() and then returns 3 arguments
-- suitable for passing directly to table.unpack
function table.pack_merge(tbl, ...)
	local n, out = 0, { }
	for _,t in pairs({tbl, ...}) do
		for i = 1, t.n do
			n = n + 1
			out[n] = t[i]
		end
	end
	return out, 1, n
end

function table.make_weak(table, mode)
	local mt = getmetatable(table)
	if mt then
		mt.__mode = mode
		return table
	end
	return setmetatable(table, { __mode = mode})
end

function table.make_keys_weak(t)
	return table.make_weak(t or {}, "k")
end

function table.make_values_weak(t)
	return table.make_weak(t or {}, "v")
end

function table.make_unserializable_table(table)
	table = table or {}
	local mt = getmetatable(table) or {}
	mt.__serialize = function() return "" end
	return setmetatable(table, mt)
end

function table.make_fair_share_iterator(target_t, array_n)
	local function yielding_iterator(target_t, array_n)
		local curr_arr_idx = 0
		local last_arr_idx = 0
		local elems_per_tick = 1/(target_t/array_n)
		while true do
			coroutine.yield()
			curr_arr_idx = curr_arr_idx + elems_per_tick
			local idx_floor = math.min(math.floor(curr_arr_idx), array_n)
			for i = last_arr_idx + 1, idx_floor do
				coroutine.yield(i)
			end
			last_arr_idx = idx_floor == array_n and 0 or idx_floor
			curr_arr_idx = idx_floor == array_n and 0 or curr_arr_idx
		end
	end
	local ret = coroutine.create(yielding_iterator)
	coroutine.resume(ret, target_t, array_n)
	return ret
end
