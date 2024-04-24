local ascii = require("unruly-worker.ascii")
local log = require("unruly-worker.log")

---@class UnrulyHudStateMacro
---@field register string
---@field is_recording boolean
---@field is_locked boolean
local state = {
	register = "z",
	is_recording = false,
	is_locked = false,
}

local M = {}

local function is_valid_macro_register(ch_int)
	return ascii.is_int_lowercase(ch_int) or ascii.is_int_uppercase(ch_int)
end

function M.get_hud_state()
	return state
end

-- record a macro into the macro_reg, then pretty print the result
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

-- play the macro_reg
function M.play()
	vim.cmd("silent! noautocmd normal! @" .. state.register)
end

-- select a new macro_reg
function M.select_register()
	if state.is_recording then
		log.error("cannot change macro register while recording")
		log.error("recording aborted")
		vim.cmd("silent! normal! q")
		vim.fn.setreg(state.register, "")
		return
	end
	log.info("MACRO REGISTER SELECT> ")
	local ch_int = vim.fn.getchar()
	local ch_str = string.char(ch_int)
	if is_valid_macro_register(ch_int) then
		state.register = ch_str
		log.info("MACRO REGISTER: %s", state.register)
		return
	end
	log.error("invalid register: %s, try [0-9][a-z] (Macro Register Still: %s)", vim.fn.keytrans(ch_str), state.register)
end

-- pritty print the macro_reg
function M.peek_register()
	local reg_content = vim.fn.getreg(state.register)

	if #reg_content > 0 then
		reg_content = vim.fn.keytrans(reg_content)
		log.info("REGISTER PEEK %s (%s)", state.register, reg_content)
	else
		log.info("REGISTER PEEK %s (empty)", state.register)
	end
end

-- lock all macro recoding
function M.lock()
	state.is_locked = true
	log.info("MACRO RECORDING LOCKED")
end

-- unlock all macro recoding
function M.unlock()
	state.is_locked = false
	log.info("MACRO RECORDING UNLOCKED")
end

-- toggle the macro recording lock
function M.lock_toggle()
	if state.is_locked then
		return M.unlock()
	end
	M.lock()
end

-- set the macro_reg to a char
function M.set_register_silent(register)
	if string.len(register) ~= 1 then
		log.error("invalid register: register must be a single character [a-z][A-X]")
	end
	if is_valid_macro_register(string.byte(register)) then
		state.register = register
		return
	end

	log.error("invalid register (%s): must be [a-z][A-Z]", register)
end

function M.expr_paste_macro()
	vim.fn.setreg("u", vim.fn.keytrans(vim.fn.getreg(state.register)))
	return '"up'
end

function M.load_macro()
	vim.cmd('silent! normal! "uy')
	local macro_content = vim.fn.keytrans(vim.fn.getreg("u"))
	vim.fn.setreg(state.register, vim.api.nvim_replace_termcodes(macro_content, true, false, true))
	log.info("MACRO LOADED: (%s)", macro_content)
end

return M
