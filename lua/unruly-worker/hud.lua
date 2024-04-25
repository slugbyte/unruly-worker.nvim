local boost = require("unruly-worker.boost")
local config = require("unruly-worker.config")

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
local function generate_hud_mark(hud_state_mark)
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
local function generate_hud_kopy(hud_state_kopy)
	return string.format("[K %s]", hud_state_kopy.register)
end

---@param hud_state_macro UnrulyHudStateMacro
local function generate_hud_macro(hud_state_macro)
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
local function generate_hud_seek(hud_state_seek)
	if hud_state_seek.index < 0 then
		return string.format("[%s ?/%s]", hud_state_seek.mode, hud_state_seek.len)
	end
	return string.format("[%s %s/%s]", hud_state_seek.mode, hud_state_seek.index, hud_state_seek.len)
end

function M.generate()
	local health_state = config.get_state()
	local hud_state = M.get_state()

	if not health_state.is_setup or health_state.user_config == nil then
		return nil
	end

	local hud_text = ""

	if health_state.user_config.booster.unruly_mark then
		hud_text = hud_text .. generate_hud_mark(hud_state.mark)
	end

	if health_state.user_config.booster.unruly_kopy then
		hud_text = hud_text .. generate_hud_kopy(hud_state.kopy)
	end

	if health_state.user_config.booster.unruly_macro_z or health_state.config.booster.unruly_macro_q then
		hud_text = hud_text .. generate_hud_macro(hud_state.macro)
	end

	if health_state.user_config.booster.unruly_seek then
		hud_text = hud_text .. generate_hud_seek(hud_state.seek)
	end

	return hud_text
end

return M
