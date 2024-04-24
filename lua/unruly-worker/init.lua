--   __ _____  ______ __/ /_ _______    _____  ____/ /_____ ____
--  / // / _ \/ __/ // / / // /___/ |/|/ / _ \/ __/  '_/ -_) __/
--  \_,_/_//_/_/  \_,_/_/\_, /    |__,__/\___/_/ /_/\_\\__/_/
--                      /___/
--
--  Name: unruly-worker
--  License: Unlicense
--  Maintainer: Duncan Marsh (slugbyte@slugbyte.com)
--  Repository: https://github.com/slugbyte/unruly-worker

local hud = require("unruly-worker.hud")
local log = require("unruly-worker.log")
local map = require("unruly-worker.map")
local rand = require("unruly-worker.rand")
local boost = require("unruly-worker.boost")
local health = require("unruly-worker.health")
local keymap = require("unruly-worker.keymap")
local config_util = require("unruly-worker.config-util")

--- Setup unruly-worker
---
--- For a detailed explination of setup config see:
--- https://github.com/slugbyte/unruly-worker
---
--- Usage:
--- ```lua
--- require("unruly-worker").setup({
--    -- setup default unruly registers
---	  unruly_kopy_register = "n",
---	  unruly_macro_register = "q",
---   -- set unruly mark and seek modes
---	  unruly_mark_global_mode = false,
---	  unruly_seek_mode = unruly_worker.seek_mode.buffer,
---   -- swap unruly_macro and unruly_quit keybinds
---	  unruly_swap_q_and_z = false,
---   -- list keymaps that should be skipped
---	  skip_list = {},
---	  booster = {
---	  	-- easy stuff are just additional opt in keymaps
---	  	easy_swap                   = true,
---	  	easy_find                   = true,
---	  	easy_line                   = true,
---	  	easy_spellcheck             = true,
---	  	easy_incrament              = true,
---	  	easy_hlsearch               = true,
---	  	easy_focus                  = true,
---	  	easy_window                 = true,
---	  	easy_jumplist               = true,
---	  	easy_scroll                 = true,
---	  	easy_source                 = true,
---	  	easy_kopy                  = true,
---	  	easy_lsp                    = true,
---	  	easy_lsp_leader             = true,
---	  	easy_diagnostic             = true,
---	  	easy_diagnostic_leader      = true,
---	  	-- unruly stuff change neovim's normal behavior
---	  	unruly_seek                 = true,
---	  	unruly_mark                 = true,
---	  	unruly_macro                = true,
---	  	unruly_kopy                 = true,
---	  	unruly_quit                 = true,
---	  	-- plugin stuff have external dependencies
---	  	plugin_navigator            = true,
---	  	plugin_comment              = true,
---	  	plugin_luasnip              = true,
---	  	plugin_textobject           = true,
---	  	plugin_telescope_leader     = true,
---	  	plugin_telescope_lsp_leader = true,
---	  	plugin_telescope_easy_jump  = true,
---	  	plugin_telescope_easy_kopy = true,
---	  },
--- })
--- ```
---@param user_config UnrulyConfig?
local function setup(user_config)
	-- dont reload if  loaded
	if vim.g.unruly_worker then
		return
	end
	vim.g.unruly_worker = true

	local is_config_legacy = config_util.is_config_legacy(user_config)
	if is_config_legacy then
		log.error("UNRULY SETUP ERROR: unruly-worker had and update and your setup() config is incompatable!")
		log.error("see https://github.com/slugbyte/unruly-worker for help.")
	end

	local config = config_util.normalize_user_config(user_config)
	config_util.apply_default_options(config)
	map.create_keymaps(keymap, config)

	-- NOTE: unruly_greeting is an easter egg, you wont find this in the docs
	if config.unruly_greeting then
		log.info(rand.emoticon() .. " " .. rand.greeting())
	end

	health.setup_complete(is_config_legacy, config)
end

return {
	setup = setup,
	boost = boost,
	hud = hud,
	seek_mode = boost.seek.seek_mode,
}
