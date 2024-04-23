local log = require("unruly-worker.log")

local M = {}


-- remap keys will map to current mapping (so kinda dangerous b/c who knows what peeps maps are)
-- no_remap keys will be whatever the vim EX cmd defaults are
M.no_remap = false
M.remap = true

M.silent = true
M.no_silent = false

function M.custom(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		s_silent = is_silent,
		is_expr = false,
		desc = desc,
	}
end

function M.custom_expr(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		is_silent = is_silent,
		is_expr = true,
		desc = desc,
	}
end

function M.basic(cmd, desc)
	return M.custom(cmd, no_remap, no_silent, desc)
end

function M.basic_expr(cmd, desc)
	return M.custom_expr(cmd, no_remap, no_silent, desc)
end

function M.noop()
	return M.basic("\\", "")
end

function M.cmd(cmd, desc, msg)
	return M.basic(function()
		vim.cmd("silent! normal!" .. cmd)
		if msg ~= nil then
			log.info(msg)
		end
	end, desc)
end

local function is_key_equal(a, b)
	local len_a = #a
	local len_b = #b
	if len_a ~= len_b then
		return false
	end

	if len_a == 1 then
		return a == b
	end

	if (string.find(a, "leader") ~= nil) then
		-- BUG: need to remove leader then compare
		return a == b
	end

	return string.lower(a) == string.lower(b)
end

function M.should_map(key, skip_list)
	local skip = false
	for _, skip_key in ipairs(skip_list) do
		skip = skip or is_key_equal(key, skip_key)
	end

	return not skip
end

return M
