local log = require("unruly-worker.log")
local seek_buffer = require("unruly-worker.boost.seek-buffer")
local seek_quickfix = require("unruly-worker.boost.seek-quickfix")
local seek_loclist = require("unruly-worker.boost.seek-loclist")

-- module
local M = {}

---@enum UnrulySeekMode
M.seek_mode = {
	quickfix = "Q",
	loclist = "L",
	buffer = "B",
}

local state = {
	seek_mode = M.seek_mode.buffer,
}

local function create_mode_set_fn(mode_option, mode_name)
	return function()
		log.info("SEEK MODE %s", mode_name)
		state.seek_mode = mode_option
		M.seek_start()
	end
end

---check if a seek mode is valid
---@param seek_mode UnrulySeekMode
---@return boolean
function M.is_seek_mode_valid(seek_mode)
	return seek_mode == M.seek_mode.buffer
			or seek_mode == M.seek_mode.quickfix
			or seek_mode == M.seek_mode.loclist
end

--- set seek mode to quickfix and goto first item
M.mode_set_quickfix = create_mode_set_fn(M.seek_mode.quickfix, "QUICKFIX")

--- set seek mode to loclist and goto first item
M.mode_set_loclist = create_mode_set_fn(M.seek_mode.loclist, "LOCLIST")

--- set seek mode to buffer and goto first item
M.mode_set_buffer = create_mode_set_fn(M.seek_mode.buffer, "BUFFER")

---@class UnrulyHudStateSeek
---@field mode UnrulySeekMode
---@field len number count of items in current mode
---@field index number index of current item

--- get seek hud state
---@return UnrulyHudStateSeek
function M.get_hud_state()
	local result = {
		mode = state.seek_mode,
		len = 0,
		index = 0,
	}

	if state.seek_mode == M.seek_mode.buffer then
		local buffer_state = seek_buffer.get_hud_state()
		result.len = buffer_state.len
		result.index = buffer_state.index
		return result
	end

	if state.seek_mode == M.seek_mode.quickfix then
		local buffer_state = seek_quickfix.get_hud_state()
		result.len = buffer_state.len
		result.index = buffer_state.index
		return result
	end

	local buffer_state = seek_loclist.get_hud_state()
	result.len = buffer_state.len
	result.index = buffer_state.index
	return result
end

--- goto next item in list
function M.seek_next()
	if state.seek_mode == M.seek_mode.buffer then
		return seek_buffer.seek_next()
	end
	if state.seek_mode == M.seek_mode.quickfix then
		return seek_quickfix.seek_next()
	end
	return seek_loclist.seek_next()
end

--- goto prev item in list
function M.seek_prev()
	if state.seek_mode == M.seek_mode.buffer then
		return seek_buffer.seek_prev()
	end
	if state.seek_mode == M.seek_mode.quickfix then
		return seek_quickfix.seek_prev()
	end
	return seek_loclist.seek_prev()
end

--- goto first item in list
function M.seek_start()
	if state.seek_mode == M.seek_mode.buffer then
		return seek_buffer.seek_start()
	end
	if state.seek_mode == M.seek_mode.quickfix then
		return seek_quickfix.seek_start()
	end
	return seek_loclist.seek_start()
end

--- goto last item in list
function M.seek_end()
	if state.seek_mode == M.seek_mode.buffer then
		return seek_buffer.seek_end()
	end
	if state.seek_mode == M.seek_mode.quickfix then
		return seek_quickfix.seek_end()
	end
	return seek_loclist.seek_end()
end

--- set the current seek mode
--- @param seek_mode UnrulySeekMode
--- @return boolean true if success
function M.set_seek_mode(seek_mode)
	if not M.is_seek_mode_valid(seek_mode) then
		if seek_mode == "" then
			---@diagnostic disable-next-line: cast-local-type
			seek_mode = "(empty)"
		end
		log.error("SEEK_MODE INVALID: (%s)", seek_mode)
		return false
	end
	state.seek_mode = seek_mode
	return true
end

return M
