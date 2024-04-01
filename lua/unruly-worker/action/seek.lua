local util = require("unruly-worker.util")
local text_object = require("unruly-worker.action.text-object")
local seek_buffer = require("unruly-worker.action.seek-buffer")
local seek_quickfix = require("unruly-worker.action.seek-quickfix")
local seek_loclist = require("unruly-worker.action.seek-loclist")

-- module
local M = {}

M.mode_option = {
	quickfix = "Q",
	loclist = "L",
	buffer = "B",
	arg_list = "A",
}

local S = {
	seek_mode = M.mode_option.buffer,
}

local function create_mode_set_fn(mode_option)
	return function()
		S.seek_mode = mode_option
	end
end

-- seek quick fix list
M.mode_set_text_object = create_mode_set_fn(M.mode_option.text_object)
M.mode_set_quickfix = create_mode_set_fn(M.mode_option.quickfix)
M.mode_set_buffer = create_mode_set_fn(M.mode_option.buffer)
M.mode_set_loclist = create_mode_set_fn(M.mode_option.loclist)

function M.get_status_text()
	if S.seek_mode == M.mode_option.buffer then
		return seek_buffer.get_status_text()
	end
	if S.seek_mode == M.mode_option.quickfix then
		return seek_quickfix.get_status_text()
	end
	if S.seek_mode == M.mode_option.loclist then
		return seek_loclist.get_status_text()
	end
end

-- seek mode rotate
function M.mode_rotate()
	if S.seek_mode == M.mode_option.quickfix then
		M.mode_set_buffer()
		return
	end
	if S.seek_mode == M.mode_option.buffer then
		M.mode_set_loclist()
		return
	end
	M.mode_set_quickfix()
end

function M.mode_get()
	return S.seek_mode
end

function M.seek_forward()
	if S.seek_mode == M.mode_option.buffer then
		return seek_buffer.seek_forward()
	end

	if S.seek_mode == M.mode_option.quickfix then
		return seek_quickfix.seek_forward()
	end

	if S.seek_mode == M.mode_option.loclist then
		return seek_loclist.seek_forward()
	end

	util.error("no seek forward impl for %s", M.mode_get())
end

function M.seek_reverse()
	if S.seek_mode == M.mode_option.buffer then
		return seek_buffer.seek_reverse()
	end
	if S.seek_mode == M.mode_option.quickfix then
		return seek_quickfix.seek_reverse()
	end
	if S.seek_mode == M.mode_option.loclist then
		return seek_loclist.seek_reverse()
	end
	util.error("no seek reverse impl for %s", M.mode_get())
end

function M.seek_first()
	if S.seek_mode == M.mode_option.buffer then
		return seek_buffer.seek_first()
	end
	if S.seek_mode == M.mode_option.quickfix then
		return seek_quickfix.seek_first()
	end
	if S.seek_mode == M.mode_option.loclist then
		return seek_loclist.seek_first()
	end

	util.error("no seek forward impl for %s", M.mode_get())
end

function M.seek_last()
	if S.seek_mode == M.mode_option.buffer then
		return seek_buffer.seek_last()
	end
	if S.seek_mode == M.mode_option.quickfix then
		return seek_quickfix.seek_last()
	end
	if S.seek_mode == M.mode_option.loclist then
		return seek_loclist.seek_last()
	end

	util.error("no seek forward impl for %s", M.mode_get())
end

return M
