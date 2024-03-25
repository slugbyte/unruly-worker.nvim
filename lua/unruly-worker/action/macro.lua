local util = require("unruly-worker.util")

local S = {
	register = "Z",
	is_recording = false,
}

local M = {}

function M.get_state()
	return S
end

function M.record()
	S.is_recording = not S.is_recording
	if S.is_recording then
		vim.fn.feedkeys(string.format("q%s", S.register), "n")
	else
		vim.api.nvim_feedkeys("q", "n", false)
		vim.schedule(function()
			local macro = vim.fn.getreg(S.register)
			vim.fn.setreg(S.register, string.sub(macro, 1, #macro - 1))
		end)
	end
end

function M.play()
	print("playing macro", S.register)
	vim.fn.feedkeys(string.format("@%s", S.register), "n")
end

function M.select_register()
	if S.is_recording then
		util.notify_error("cannot change macro register while recording")
		return
	end
	util.notify_info("Select Macro Register: ")
	local ch_int = vim.fn.getchar()
	local ch_str = string.char(ch_int)
	if util.is_valid_register(ch_int) then
		S.register = ch_str
		util.notify_info(string.format("Macro Register: %s", S.register))
		return
	end
	util.notify_error(string.format("invalid register: %s (Macro Register Still: %s)", ch_str, S.register))
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
