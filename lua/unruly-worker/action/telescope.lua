-- TODO: should this have a find config (files/grep)?
local util = require("unruly-worker.util")
local telescope_status, telescope_builtin = pcall(require, "telescope.builtin")

local M = {}

function M.find_files()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.find_files({
			hidden = true,
		})
		return
	end
	util.notify_error("telescope not found")
end

function M.live_grep()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.live_grep({
			hidden = true,
		})
		return
	end
	util.notify_error("telescope not found")
end

-- this will work without telescope
function M.lsp_definiton()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.lsp_definitions()
	else
		vim.lsp.buf.definition()
	end
end

return M
