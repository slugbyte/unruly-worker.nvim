-- TODO: Paste keytrans macro
-- TODO: YANK keytrans macro

local util = require("unruly-worker.util")

local S = {
	register = "z",
	is_recording = false,
}

local M = {}

local function is_valid_macro_register(ch_int)
	-- TODO: upper prbos ok now (test it out)
	return util.is_int_ascii_lowercase(ch_int) or util.is_int_ascii_num(ch_int)
end

function M.get_state()
	return S
end

function M.record()
	S.is_recording = not S.is_recording
	if S.is_recording then
		vim.fn.setreg(S.register, "")
		vim.cmd(string.format("silent! normal! q%s", S.register))
	else
		vim.cmd("silent! normal! q")
		util.notify_info(string.format("MACRO RECORDED: %s", S.register))
	end
end

function M.play()
	local register_content = vim.fn.getreg(S.register)
	-- NOTE: because z is keymaped to fn instead of an excommand
	-- the letter 'z' will allways be added to then end of the recorded
	-- register, `safe_macro` is just everything but that 'z'
	local safe_macro = string.sub(register_content, 1, #register_content - 1)
	if #safe_macro > 0 then
		util.notify_info(string.format("MACRO PLAY: %s (%s)", S.register, vim.fn.keytrans(safe_macro)))
		vim.fn.setreg("1", safe_macro)
		vim.cmd('silent! noautocmd normal! @1')
	else
		util.notify_info(string.format("MACRO EMPTY: %s", S.register))
	end
end

function M.select_register()
	if S.is_recording then
		util.notify_error("cannot change macro register while recording")
		util.notify_error("recording aborted")
		vim.cmd("silent! normal! q")
		vim.fn.setreg(S.register, "")
		return
	end
	util.notify_info("MACRO REGISTER SELECT> ")
	local ch_int = vim.fn.getchar()
	local ch_str = string.char(ch_int)
	if is_valid_macro_register(ch_int) then
		S.register = ch_str
		util.notify_info(string.format("MACRO REGISTER: %s", S.register))
		return
	end
	util.notify_error(string.format("invalid register: %s, try [0-9][a-z] (Macro Register Still: %s)", ch_str, S.register))
end

return M

-- TODO: figure out how to save load and name macros
--
--function M.save_macro()
-- 	local desc = vim.fn.input("What does the macro do?")
-- 	table.insert(S.macro_list, {
-- 		desc = desc,
-- 		content = vim.fn.getreg(S.register),
-- 	})
-- 	S.current_macro = #S.macro_list
-- 	for index, value in ipairs(S.macro_list) do
-- 		print(string.format("%d: %s", index, value.desc))
-- 	end
-- end
-- function M.select_macro()
-- 	if #S.macro_list > 0 then
-- 		local choices = {}
-- 		for _, value in ipairs(S.macro_list) do
-- 			table.insert(choices, value.desc)
-- 		end
--
-- 		vim.ui.select({ "cool", "beans", "dude" },
-- 			{ prompt = "Select a Macro:", kind = "string" },
-- 			function(_, choice)
-- 				print("you selected", choice)
-- 			end)
-- 		return
-- 	end
--
-- 	util.notify_error("no macros to select")
-- end
-- vim.print(vim.api.nvim_cmd(vim.print(vim.api.nvim_parse_cmd(string.format("silent! normal! q%s", S.register), {})),
-- { output = true }))
-- vim.print("result:::", vim.api.nvim_cmd({ "silent!", "normal!", string.format("q%s", S.register) }, { output = true }))
