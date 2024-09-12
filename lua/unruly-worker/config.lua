local log = require("unruly-worker.log")
local keymap = require("unruly-worker.keymap")
local map = require("unruly-worker.map")
local rand = require("unruly-worker.rand")
local boost = require("unruly-worker.boost")

local M = {}

---@class UnrulyConfigBooster
---@field default boolean
---@field easy_swap boolean
---@field easy_search boolean
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
---@field plugin_telescope_diagnostic_leader boolean
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

---@class UnrulySetupReport
---@field is_setup boolean
---@field user_config UnrulyConfig?
---@field is_kopy_reg_ok boolean
---@field is_macro_reg_ok boolean
---@field is_seek_mode_valid boolean
---@field is_greeting_enable boolean
---@field is_user_config_legacy boolean

---NOTE: used to impl checkhealth behavior in health.lua
---@type UnrulySetupReport
local setup_report = {
	user_config = nil,
	is_setup = false,
	is_kopy_reg_ok = true,
	is_macro_reg_ok = true,
	is_seek_mode_valid = true,
	is_greeting_enable = false,
	is_user_config_legacy = false,
}

--- get the state setup
---@return UnrulySetupReport
function M.get_setup_report()
	return setup_report
end

--- @param config table?
local function check_is_config_legacy(config)
	if config == nil then
		return
	end
	local is_config_legacy = (config.enable_lsp_map ~= nil)
		or (config.enable_select_map ~= nil)
		or (config.enable_quote_command ~= nil)
		or (config.enable_easy_window_navigate ~= nil)
		or (config.enable_comment_map ~= nil)
		or (config.enable_wrap_navigate ~= nil)
		or (config.enable_visual_navigate ~= nil)

	if is_config_legacy then
		setup_report.is_user_config_legacy = true
		log.error("UNRULY SETUP ERROR: unruly-worker had and update and your setup() config is incompatable!")
		log.error("see https://github.com/slugbyte/unruly-worker for help.")
	end
end

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
		default = true,
		easy_swap = false,
		easy_search = false,
		easy_line = false,
		easy_spellcheck = false,
		easy_incrament = false,
		easy_hlsearch = false,
		easy_focus = false,
		easy_window = false,
		easy_jumplist = false,
		easy_scroll = false,
		easy_source = false,
		easy_lsp = false,
		easy_lsp_leader = false,
		easy_diagnostic = false,
		easy_diagnostic_leader = false,
		unruly_seek = false,
		unruly_mark = false,
		unruly_macro = false,
		unruly_kopy = false,
		unruly_quit = false,
		plugin_navigator = false,
		plugin_comment = false,
		plugin_luasnip = false,
		plugin_textobject = false,
		plugin_telescope_leader = false,
		plugin_telescope_easy_jump = false,
		plugin_telescope_lsp_leader = false,
		plugin_telescope_diagnostic_leader = false,
	},
	skip_list = {},
}

---create a normalized config from the user_config
---update state to store the normalized config
---@param user_config UnrulyConfig?
---@return UnrulyConfig
local function create_normalized_config(user_config)
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

	setup_report.user_config = result

	return result
end

---set default unruly modes/registers, and vim settings
---update state to refect any problems that occur
---@param config UnrulyConfig
local function apply_settings(config)
	if config.unruly_options.mark_mode_is_global then
		boost.mark.set_is_local_mode(false)
	end

	if config.unruly_options.macro_reg ~= nil then
		if not boost.macro.set_default_macro_reg(config.unruly_options.macro_reg) then
			setup_report.is_macro_reg_ok = false
		end
	end

	if config.unruly_options.kopy_reg ~= nil then
		if not boost.kopy.set_default_kopy_reg(config.unruly_options.kopy_reg) then
			setup_report.is_kopy_reg_ok = false
		end
	end

	if config.unruly_options.seek_mode ~= nil then
		if not boost.seek.set_seek_mode(config.unruly_options.seek_mode) then
			setup_report.is_seek_mode_valid = false
		end
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

--- apply keymaps
--- @param config UnrulyConfig
local function apply_keymaps(config)
	map.create_keymaps(keymap, config)
end

---apply settings and set kemaps
---@param user_config UnrulyConfig?
function M.apply_config(user_config)
	check_is_config_legacy(user_config)
	user_config = create_normalized_config(user_config)
	apply_settings(user_config)
	apply_keymaps(user_config)
	-- NOTE: unruly_greeting is an easter egg, you wont find this in the docs
	if user_config.unruly_options.enable_greeting then
		vim.schedule(function()
			log.info(rand.emoticon() .. " " .. rand.greeting())
		end)
	end
	setup_report.is_setup = true
end

return M
