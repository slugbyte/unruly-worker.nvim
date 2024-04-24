local log = require "unruly-worker.log"
local M = {}

--- source the current lua or vim file
function M.source_file()
	local current_file = vim.fn.expandcmd("%")
	if current_file == "%" then
		log.error("cannot source noname buffer, try to save file beforce sourcing")
		return
	end
	local keys = vim.api.nvim_replace_termcodes(":source %<cr>", true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end

return M
