local util = require("unruly-worker.util")

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
			util.info(msg)
		end
	end, desc)
end

return M
