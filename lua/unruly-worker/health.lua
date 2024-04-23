local M = {}

M.check = function()
	local unruly = require("unruly-worker")
	local state = unruly._get_state()
	if state.is_setup == false then
		vim.health.report_error("unruly-worker is not setup")
		return
	end

	if state.is_config_legacy == true then
		vim.health.report_error("unruly-worker had a big update, and you now have an incompatable configuration.")
		vim.health.report_info(
			"checkout the github to see how to setup your config: https://github.com/slubyte/unruly-worker")
	end

	if state.config == nil then
		return
	end

	if state.config.booster == nil then
		return
	end

	if state.config.unruly_greeting then
		vim.health.report_ok("congrats, you found the easter egg greeting!")
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
