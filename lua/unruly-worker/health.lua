local M = {}

local function check_setup()
	return false
end

M.check = function()
	local unruly = require("unruly-worker")
	local state = unruly._get_state()
	if state.is_setup == false then
		vim.health.report_error("unruly-worker is not setup")
		return
	end

	if state.config == nil then
		return
	end

	if state.config.booster == nil then
		return
	end

	if state.config.enable_easter_egg_greeting then
		vim.health.report_ok("congrats, you found the easter egg!")
	end

	vim.health.report_start("checking for unruly dependencies")


	local should_have_telescope = state.config.booster.plugin_telescope_leader
			or state.config.booster.plugin_telescope_easy_jump
			or state.config.booster.plugin_telescope_lsp_leader
			or state.config.booster.plugin_telescope_easy_paste

	if should_have_telescope then
		local status, _ = pcall(require, "telescope")
		if not status then
			vim.health.report_error("cannot find telescope.nvim")
		else
			vim.health.report_ok("found telescope.nvim")
		end
	end

	if state.config.booster.plugin_navigator then
		local status, _ = pcall(require, "Navigator")
		if not status then
			vim.health.report_error("cannot find navigator.nvim")
		else
			vim.health.report_ok("found navigator.nvim")
		end
	end


	if state.config.booster.plugin_textobject then
		local treesitter_status, _ = pcall(require, 'nvim-treesitter.configs')
		if not treesitter_status then
			vim.health.report_error("cannot find nvim-treesitter")
		else
			vim.health.report_ok("found nvim-treesitter")
		end

		local textobject_status, _ = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
		if not textobject_status then
			vim.health.report_error("cannot find nvim-treesitter-textobjects")
		else
			vim.health.report_ok("found nvim-treesitter-textobjects")
		end
	end

	if state.config.booster.plugin_luasnip then
		local status, _ = pcall(require, "luasnip")
		if not status then
			vim.health.report_error("cannot find luasnip")
		else
			vim.health.report_ok("found luasnip")
		end
	end
end

return M
