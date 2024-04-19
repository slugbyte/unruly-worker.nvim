local util = require("unruly-worker.util")

local S = {
	register = "z",
	is_recording = false,
	is_locked = false,
}

local M = {}

local function is_valid_macro_register(ch_int)
	return util.is_int_ascii_lowercase(ch_int) or util.is_int_ascii_uppercase(ch_int)
end

function M.get_state()
	return S
end

function M.get_status_text()
	if (S.is_recording) then
		return string.format("[R %s]", S.register)
	end
	if (S.is_locked) then
		return string.format("[L %s]", S.register)
	end
	return string.format("[M %s]", S.register)
end

function M.record()
	if S.is_locked then
		util.error("MACRO RECORDING LOCKED")
		return
	end
	S.is_recording = not S.is_recording
	if S.is_recording then
		vim.fn.setreg(S.register, "")
		vim.cmd(string.format("silent! normal! q%s", S.register))
	else
		vim.cmd("silent! normal! q")
		util.notify("MACRO RECORDED: %s", S.register)
	end
end

function M.play()
	local register_content = vim.fn.getreg(S.register)
	-- NOTE: because z is keymaped to fn instead of an excommand
	-- the letter 'z' will allways be added to then end of the recorded
	-- register, `safe_macro` is just everything but that 'z'
	local safe_macro = string.sub(register_content, 1, #register_content - 1)
	if #safe_macro > 0 then
		util.notify("MACRO PLAY: %s (%s)", S.register, vim.fn.keytrans(safe_macro))
		vim.fn.setreg("1", safe_macro)
		vim.cmd('silent! noautocmd normal! @1')
	else
		util.notify("MACRO EMPTY: %s", S.register)
	end
end

function M.select_register()
	if S.is_recording then
		util.error("cannot change macro register while recording")
		util.error("recording aborted")
		vim.cmd("silent! normal! q")
		vim.fn.setreg(S.register, "")
		return
	end
	util.info("MACRO REGISTER SELECT> ")
	local ch_int = vim.fn.getchar()
	local ch_str = string.char(ch_int)
	if is_valid_macro_register(ch_int) then
		S.register = ch_str
		util.notify("MACRO REGISTER: %s", S.register)
		return
	end
	util.error("invalid register: %s, try [0-9][a-z] (Macro Register Still: %s)", vim.fn.keytrans(ch_str), S.register)
end

function M.peek_register()
	local reg_content = vim.fn.getreg(S.register)

	if #reg_content > 0 then
		reg_content = vim.fn.keytrans(reg_content)
		util.notify("REGISTER PEEK %s (%s)", S.register, reg_content)
	else
		util.notify("REGISTER PEEK %s (empty)", S.register)
	end
end

function M.lock()
	S.is_locked = true
	util.notify("MACRO RECORDING LOCKED")
end

function M.unlock()
	S.is_locked = false
	util.notify("MACRO RECORDING UNLOCKED")
end

function M.lock_toggle()
	if S.is_locked then
		return M.unlock()
	end
	M.lock()
end

return M
