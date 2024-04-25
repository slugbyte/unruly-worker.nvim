local boost = require("unruly-worker.boost")
local M = {}

--
---@class UnrulyConfigBooster
---@field default boolean
---@field easy_swap boolean
---@field easy_find boolean
---@field easy_line boolean
---@field easy_spellcheck boolean
---@field easy_incrament boolean
---@field easy_hlsearch boolean
---@field easy_focus boolean
---@field easy_window boolean
---@field easy_jumplist boolean
---@field easy_scroll boolean
---@field easy_source boolean
---@field easy_lsp boolean
---@field easy_lsp_leader boolean
---@field easy_diagnostic boolean
---@field easy_diagnostic_leader boolean
---@field unruly_seek boolean
---@field unruly_mark boolean
---@field unruly_macro boolean?
---@field unruly_macro_z boolean?
---@field unruly_macro_q boolean?
---@field unruly_kopy boolean
---@field unruly_quit boolean
---@field plugin_navigator boolean
---@field plugin_comment boolean
---@field plugin_luasnip boolean
---@field plugin_textobject boolean
---@field plugin_telescope_leader boolean
---@field plugin_telescope_lsp_leader boolean
---@field plugin_telescope_easy_jump boolean

---@class UnrulyConfigUnrulyOptions
---@field seek_mode UnrulySeekMode?
---@field kopy_reg string?
---@field macro_reg string?
---@field swap_q_and_z  boolean?
---@field enable_greeting boolean?
---@field mark_mode_is_global boolean?

---@class UnrulyConfig
---@field unruly_options UnrulyConfigUnrulyOptions?
---@field booster UnrulyConfigBooster?
---@field skip_list string[]?

---@type UnrulyConfig
local default_config = {
	unruly_options = {
		seek_mode = nil,
		kopy_reg = nil,
		macro_reg = nil,
		swap_q_and_z = false,
		enable_greeting = false,
		mark_mode_is_global = false,
	},
	booster = {
		default                     = true,
		easy_swap                   = false,
		easy_find                   = false,
		easy_line                   = false,
		easy_spellcheck             = false,
		easy_incrament              = false,
		easy_hlsearch               = false,
		easy_focus                  = false,
		easy_window                 = false,
		easy_jumplist               = false,
		easy_scroll                 = false,
		easy_source                 = false,
		easy_lsp                    = false,
		easy_lsp_leader             = false,
		easy_diagnostic             = false,
		easy_diagnostic_leader      = false,
		unruly_seek                 = false,
		unruly_mark                 = false,
		unruly_macro                = false,
		unruly_kopy                 = false,
		unruly_quit                 = false,
		plugin_navigator            = false,
		plugin_comment              = false,
		plugin_luasnip              = false,
		plugin_textobject           = false,
		plugin_telescope_leader     = false,
		plugin_telescope_lsp_leader = false,
		plugin_telescope_easy_jump  = false,
	},
	skip_list = {},
}

--- @param user_config UnrulyConfig?
--- @return UnrulyConfig
function M.normalize_user_config(user_config)
	if user_config == nil then
		return default_config
	end

	local result = vim.tbl_deep_extend("force", {}, default_config)

	if user_config.unruly_options ~= nil then
		result.unruly_options = vim.tbl_extend("force", result.unruly_options, user_config.unruly_options)
	end

	if user_config.booster ~= nil then
		result.booster = vim.tbl_extend("force", result.booster, user_config.booster)
	end

	if user_config.skip_list ~= nil then
		result.skip_list = user_config.skip_list
	end

	if result.unruly_options.swap_q_and_z then
		result.booster.unruly_quit = nil
		result.booster.unruly_macro = nil
		result.booster.unruly_quit_q = true
		result.booster.unruly_macro_z = true
	else
		result.booster.unruly_quit = nil
		result.booster.unruly_macro = nil
		result.booster.unruly_quit_z = true
		result.booster.unruly_macro_q = true
	end

	return result
end

--- set default unruly modes/registers, and vim settings
--- @param config UnrulyConfig
function M.apply_defaults(config)
	if config.unruly_options.mark_mode_is_global then
		boost.mark.set_is_local_mode(false)
	end

	if config.unruly_options.macro_reg ~= nil then
		boost.macro.set_macro_reg(config.unruly_options.macro_reg)
	end

	if config.unruly_options.kopy_reg ~= nil then
		boost.kopy.set_kopy_reg(config.unruly_options.kopy_reg)
	end

	if config.unruly_options.seek_mode ~= nil then
		boost.seek.set_seek_mode(config.unruly_options.seek_mode)
	end

	if config.booster.easy_source then
		-- disable neovim from auto loading matchit
		vim.g.loaded_matchit = true
	end

	if config.booster.easy_hlsearch then
		-- enable hlsearh
		vim.opt.hlsearch = true
	end
end

--- @param config table?
function M.is_config_legacy(config)
	if config == nil then
		return false
	end
	return (config.enable_lsp_map ~= nil)
			or (config.enable_select_map ~= nil)
			or (config.enable_quote_command ~= nil)
			or (config.enable_easy_window_navigate ~= nil)
			or (config.enable_comment_map ~= nil)
			or (config.enable_wrap_navigate ~= nil)
			or (config.enable_visual_navigate ~= nil)
end

return M
