local util = require("unruly-worker.util")
local text_object = require("unruly-worker.action.text-object")
local seek_buffer = require("unruly-worker.action.seek-buffer")

-- module
local M = {}

M.mode_option = {
	quick_fix = "Q",
	buffer = "B",
	arg_list = "A",
}

local S = {
	seek_mode = M.mode_option.buffer,
}

-- local function get_quickfix_status()
-- 	local qflist = vim.fn.getqflist()
-- 	S.total = #qflist
-- 	S.current_buf_num = vim.fn.bufnr()
-- 	local continue = true
-- 	local i = 1
-- 	while continue and i < #qflist do
-- 	end
-- end

local function create_mode_set_fn(mode_option)
	return function()
		S.seek_mode = mode_option
	end
end

-- hop quick fix list
M.mode_set_text_object = create_mode_set_fn(M.mode_option.text_object)
M.mode_set_quick_fix = create_mode_set_fn(M.mode_option.quick_fix)
M.mode_set_buffer = create_mode_set_fn(M.mode_option.buffer)

function M.get_status_text()
	if S.seek_mode == M.mode_option.buffer then
		return seek_buffer.get_status_text()
	end
end

-- hop mode rotate
function M.mode_rotate()
	if S.seek_mode == M.mode_option.quick_fix then
		M.mode_set_buffer()
		return
	end
	M.mode_set_quick_fix()
end

function M.mode_get()
	return S.seek_mode
end

function M.seek_forward()
	if S.seek_mode == M.mode_option.buffer then
		return seek_buffer.seek_forward()
	end

	util.error("no hop forward impl for %s", M.mode_get())
end

function M.seek_reverse()
	if S.seek_mode == M.mode_option.buffer then
		return seek_buffer.seek_reverse()
	end
	util.error("no hop reverse impl for %s", M.mode_get())
end

return M
