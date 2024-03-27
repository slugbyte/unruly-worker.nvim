-- TODO: should this have a find config (files/grep)?
local util = require("unruly-worker.util")
local telescope_status, telescope_builtin = pcall(require, "telescope.builtin")
local _, telescope_themes = pcall(require, "telescope.themes")

local M = {}

function M.buffer_fuzzy_search()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.current_buffer_fuzzy_find(telescope_themes.get_dropdown({
			previewer = false,
		}))
		return
	end
	util.error("telescope not found")
end

function M.find_files()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.find_files({
			hidden = true,
		})
		return
	end
	util.error("telescope not found")
end

function M.live_grep()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.live_grep({
			hidden = true,
		})
		return
	end
	util.error("telescope not found")
end

-- this will work without telescope
function M.lsp_definiton()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.lsp_definitions()
		return
	else
		vim.lsp.buf.definition()
	end
end

function M.jump_list()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.jumplist()
		return
	else
		vim.cmd("jumps")
	end
end

return M
