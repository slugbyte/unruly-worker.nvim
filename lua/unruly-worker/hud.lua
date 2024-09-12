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
	return boost.mark.get_status_text()
end

---@param hud_state_kopy UnrulyHudStateKopy
local function generate_hud_kopy(hud_state_kopy)
	return string.format("(%s)", hud_state_kopy.register)
end

---@param hud_state_macro UnrulyHudStateMacro
local function generate_hud_macro(hud_state_macro)
	local macro_mode = "M"
	if hud_state_macro.is_recording then
		macro_mode = "R"
	end
	if hud_state_macro.is_locked then
		macro_mode = "L"
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
	local health_state = config.get_setup_report()
	local hud_state = M.get_state()

	if not health_state.is_setup or health_state.user_config == nil then
		return nil
	end

	local hud_text = ""

	if health_state.user_config.booster.unruly_kopy then
		hud_text = hud_text .. generate_hud_kopy(hud_state.kopy)
	end

	if health_state.user_config.booster.unruly_mark then
		hud_text = hud_text .. generate_hud_mark(hud_state.mark)
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
