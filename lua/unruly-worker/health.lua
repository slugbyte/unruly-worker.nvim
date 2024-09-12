local config = require("unruly-worker.config")
local keymap = require("unruly-worker.keymap")

local M = {}

M.check = function()
	local setup_report = config.get_setup_report()

	if setup_report.is_setup == false then
		vim.health.report_error("unruly-worker is not setup")
		return
	end

	vim.health.report_start("check setup() config")
	local is_config_ok = true

	if setup_report.user_config.unruly_options.enable_greeting then
		vim.health.report_ok("Congrats! you Found the easter egg.")
	end

	if setup_report.is_user_config_legacy then
		vim.health.report_error(
			"CONFIG_ERROR: unruly-worker had a big update, and you now have an incompatable setup() config."
		)
		vim.health.report_error(
			"checkout the github to see how to setup your config: https://github.com/slubyte/unruly-worker"
		)
		is_config_ok = false
	end

	if not setup_report.is_kopy_reg_ok then
		vim.health.report_error(
			"CONFIG_ERROR: config.unruly_options.kopy_reg is not valid. valid reg are ([a-z] [A-Z] + 0)"
		)
		is_config_ok = false
	end

	if not setup_report.is_macro_reg_ok then
		vim.health.report_error(
			"CONFIG_ERROR: config.unruly_options.macro_reg is not valid. valid reg are ([a-z] [A-Z])"
		)
		is_config_ok = false
	end

	if not setup_report.is_seek_mode_valid then
		vim.health.report_error(
			"CONFIG_ERROR: config.unruly_options.seek_mode is not valid. must be unruly.seek_mode.(buffer/quickfix/loclist)"
		)
		is_config_ok = false
	end

	local invalid_booster_list = {}
	for booster_name, _ in pairs(setup_report.user_config.booster) do
		local Found_booster = false
		for _, booster in ipairs(keymap) do
			if booster.name == booster_name then
				Found_booster = true
			end
		end
		if not Found_booster then
			table.insert(invalid_booster_list, booster_name)
		end
	end

	if #invalid_booster_list ~= 0 then
		for _, booster_name in ipairs(invalid_booster_list) do
			vim.health.report_error(string.format("CONFIG_ERROR: invalid booster config.booster.%s", booster_name))
		end
		is_config_ok = false
	end

	if is_config_ok then
		vim.health.report_ok("setup() config is ok")
	end

	vim.health.report_start("check dependencies")
	local is_deps_ok = true

	local should_have_telescope = setup_report.user_config.booster.plugin_telescope_leader
		or setup_report.user_config.booster.plugin_telescope_easy_jump
		or setup_report.user_config.booster.plugin_telescope_lsp_leader
	if should_have_telescope then
		local status, _ = pcall(require, "telescope")
		if not status then
			vim.health.report_error("DEPENDENCIE_MISSING: telescope.nvim")
			is_deps_ok = false
		else
			vim.health.report_ok("Found telescope.nvim")
		end
	end

	if setup_report.user_config.booster.plugin_navigator then
		local status, _ = pcall(require, "Navigator")
		if not status then
			vim.health.report_error("DEPENDENCIE_MISSING: navigator.nvim")
			is_deps_ok = false
		else
			vim.health.report_ok("Found navigator.nvim")
		end
	end

	if setup_report.user_config.booster.plugin_luasnip then
		local status, _ = pcall(require, "luasnip")
		if not status then
			vim.health.report_error("DEPENDENCIE_MISSING: luasnip")
			is_deps_ok = false
		else
			vim.health.report_ok("Found luasnip")
		end
	end

	if setup_report.user_config.booster.plugin_textobject then
		local treesitter_status, _ = pcall(require, "nvim-treesitter.configs")
		if not treesitter_status then
			vim.health.report_error("DEPENDENCIE_MISSING: nvim-treesitter")
			is_deps_ok = false
		else
			vim.health.report_ok("Found nvim-treesitter")
		end

		local textobject_status, _ = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
		if not textobject_status then
			vim.health.report_error("DEPENDENCIE_MISSING: nvim-treesitter-textobjects")
			is_deps_ok = false
		else
			vim.health.report_ok("Found nvim-treesitter-textobjects")
		end
	end

	if is_deps_ok then
		vim.health.report_ok("All dependencies Found!")
	end
end

return M
