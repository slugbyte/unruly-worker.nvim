local ascii = require("unruly-worker.ascii")
local log = require("unruly-worker.log")

---@class UnrulyHudStateMacro
---@field register string
---@field default_register string
---@field is_recording boolean
---@field is_locked boolean
local state = {
	register = "z",
	default_register = "z",
	is_recording = false,
	is_locked = false,
}

-- TODO: create a unro record, to reload the last recoding

local M = {}

---check if int is a valid macro_reg
---@param ch_int number a number representing a ascii char
---@return boolean
local function is_valid_macro_reg(ch_int)
	return ascii.is_int_lowercase(ch_int) or ascii.is_int_uppercase(ch_int)
end

---@return UnrulyHudStateMacro
function M.get_hud_state()
	return state
end

--- log invalid register error message
---@param macro_reg string
local function log_error_invalid_macro_reg(macro_reg)
	if macro_reg == "" then
		macro_reg = "(empty)"
	end
	log.error("INVALID MACRO_REG: %s, valid registers are [a-z] [A-Z] (MACRO_REG STILL: %s)",
		vim.fn.keytrans(macro_reg), state.register)
end

---record a macro into the macro_reg, then pretty print the result
function M.record()
	if state.is_locked then
		log.error("MACRO RECORDING LOCKED")
		return
	end
	state.is_recording = not state.is_recording
	if state.is_recording then
		vim.fn.setreg(state.register, "")
		vim.cmd(string.format("silent! normal! q%s", state.register))
	else
		vim.cmd("silent! normal! q")
		local reg_content = vim.fn.getreg(state.register)
		-- NOTE: strip the last char because them macro_record_key is keymaped to fn
		-- instead of an excommand so the macro_record_key will allways be added to
		-- then end of the recorded register
		local safe_macro = string.sub(reg_content, 1, #reg_content - 1)
		vim.fn.setreg(state.register, safe_macro)
		if #safe_macro > 0 then
			reg_content = vim.fn.keytrans(safe_macro)
			log.info("MACRO RECORDED: %s (%s)", state.register, reg_content)
		else
			log.info("MACRO RECORDED: %s (empty)", state.register)
		end
	end
end

---play the macro_reg
function M.play()
	vim.cmd("silent! noautocmd normal! @" .. state.register)
end

---select a new macro_reg
function M.prompt_macro_reg_select()
	if state.is_recording then
		log.error("MACRO RECORDING ABORTED: cannot change MACRO_REG while recording.")
		vim.cmd("silent! normal! q")
		vim.fn.setreg(state.register, "")
		return
	end
	log.info("SELECT MACRO_REG: ")
	local ch_int = vim.fn.getchar()
	local ch_str = string.char(ch_int)
	if ch_int == ascii.escape then
		log.info("ABORTED MACRO_REG SELECT: (MACRO_REG still %s)", state.register)
		return
	end
	if is_valid_macro_reg(ch_int) then
		state.register = ch_str
		log.info("MACRO_REG: %s", state.register)
		return
	end

	if ch_int == ascii.enter or ch_int == ascii.space then
		state.register = state.default_register
		log.info("MACRO_REG: %s", state.register)
		return
	end
	log_error_invalid_macro_reg(ch_str)
end

---pritty print the macro_reg
function M.peek_register()
	local reg_content = vim.fn.getreg(state.register)

	if #reg_content > 0 then
		reg_content = vim.fn.keytrans(reg_content)
		log.info("MACRO_REG %s (%s)", state.register, reg_content)
	else
		log.info("MACRO_REG %s (empty)", state.register)
	end
end

---lock all macro recoding
function M.lock()
	state.is_locked = true
	log.info("MACRO RECORDING LOCKED")
end

---unlock all macro recoding
function M.unlock()
	state.is_locked = false
	log.info("MACRO RECORDING UNLOCKED")
end

---toggle the macro recording lock
function M.lock_toggle()
	if state.is_locked then
		return M.unlock()
	end
	M.lock()
end

---set the macro_reg
---@param macro_reg string an alpha char [a-z][A-Z]
---@return boolean true if success
function M.set_default_macro_reg(macro_reg)
	if (string.len(macro_reg) ~= 1) or (not is_valid_macro_reg(string.byte(macro_reg))) then
		log_error_invalid_macro_reg(macro_reg)
		return false
	end
	state.default_register = macro_reg
	state.register = macro_reg
	return true
end

---pretty paste the current macro into the file
---special keys will look like (<c-u> <leader>)
function M.expr_paste_macro()
	vim.fn.setreg("u", vim.fn.keytrans(vim.fn.getreg(state.register)))
	return '"up'
end

---load(yank) visualy selected text as a macro from the buffer
---special keys should be written like (<c-u> <leader>)
function M.load_macro()
	vim.cmd('silent! normal! "uy')
	local macro_content = vim.fn.keytrans(vim.fn.getreg("u"))
	vim.fn.setreg(state.register, vim.api.nvim_replace_termcodes(macro_content, true, false, true))
	log.info("MACRO LOADED: (%s)", macro_content)
end

return M
