local boost = require("unruly-worker.boost")

local M = {}

--- @class UnrulyHudState
--- @field mark UnrulyHudStateMark?
--- @field seek UnrulyHudStateSeek?
--- @field kopy UnrulyHudStateKopy?
--- @field macro UnrulyHudStateMacro?

--- @return UnrulyHudState
function M.get_state()
	return {
		mark = boost.mark.get_hud_state(),
		seek = boost.seek.get_hud_state(),
		kopy = boost.kopy.get_hud_state(),
		macro = boost.macro.get_hud_state(),
	}
end

---@param hud_state_mark UnrulyHudStateMark
local function mark_hud(hud_state_mark)
	local mark_a = nil
	local mark_b = nil

	if hud_state_mark.is_local_mode then
		mark_a = "x"
		mark_b = "x"
		if hud_state_mark.is_a_set then
			mark_a = "a"
		end
		if hud_state_mark.is_b_set then
			mark_b = "b"
		end
	else
		mark_a = "X"
		mark_b = "X"
		if hud_state_mark.is_a_set then
			mark_a = "A"
		end
		if hud_state_mark.is_b_set then
			mark_b = "B"
		end
	end
	return string.format("[%s%s]", mark_a, mark_b)
end

---@param hud_state_kopy UnrulyHudStateKopy
local function kopy_hud(hud_state_kopy)
	return string.format("[K %s]", hud_state_kopy.register)
end

---@param hud_state_macro UnrulyHudStateMacro
local function macro_hud(hud_state_macro)
	local macro_mode = 'M'
	if hud_state_macro.is_recording then
		macro_mode = 'R'
	end
	if hud_state_macro.is_locked then
		macro_mode = 'L'
	end
	return string.format("[%s %s]", macro_mode, hud_state_macro.register)
end

---@param hud_state_seek UnrulyHudStateSeek
local function seek_hud(hud_state_seek)
	return string.format("[S %s %s/%s]", hud_state_seek.mode, hud_state_seek.index, hud_state_seek.len)
end

function M.generate()
	local hud_state = M.get_state()

	local hud_text = ""

	-- if hud_state.mark then
	hud_text = hud_text .. mark_hud(hud_state.mark)
	-- end

	-- if hud_state.kopy then
	hud_text = hud_text .. kopy_hud(hud_state.kopy)
	-- end

	-- if hud_state.macro then
	hud_text = hud_text .. macro_hud(hud_state.macro)
	-- end

	return hud_text
end

return M
