--   __ _____  ______ __/ /_ _______    _____  ____/ /_____ ____
--  / // / _ \/ __/ // / / // /___/ |/|/ / _ \/ __/  '_/ -_) __/
--  \_,_/_//_/_/  \_,_/_/\_, /    |__,__/\___/_/ /_/\_\\__/_/
--                      /___/
--
--  Name: unruly-worker
--  License: Unlicense
--  Maintainer: Duncan Marsh (slugbyte@slugbyte.com)
--  Repository: https://github.com/slugbyte/unruly-worker

local state = {
	is_setup = false,
	is_config_legacy = false,
	config = nil,
}

local boost = require("unruly-worker.boost")
local map = require("unruly-worker.map")
local log = require("unruly-worker.log")

local mapping = {
	general = {
		m = {
			-- alphabet
			a = map.custom("a", map.remap, map.no_silent, "append cursor"),
			A = map.basic("A", "append line"),
			b = map.basic("%", "brace match"),
			B = map.basic("g;", "back to last change"),
			c = map.basic("c", "change"),
			C = map.basic("C", "change to end of line"),
			cc = map.basic("C", "change lines"),
			d = map.basic("d", "delete"),
			D = map.basic("D", "delete to end of line"),
			dd = map.basic("dd", "delete lines"),
			e = map.basic("k", "up"),
			E = map.cmd("vip", "envelope paraghaph"),
			f = map.basic("n", "find next"),
			F = map.basic("N", "find prev"),
			g = map.basic("g", "g command"),
			G = map.basic("G", "goto line"),
			h = map.basic(";", "hop t/T{char} repeat"),
			H = map.basic(",", "hop t/T{char} reverse"),
			i = map.basic("i", "insert"),
			I = map.basic("I", "insert BOL"),
			j = map.noop(),
			J = map.noop(),
			k = map.basic("y", "kopy"),
			K = map.basic("Y", "kopy line"),
			l = map.basic("o", "line insert below"),
			L = map.basic("O", "line insert above"),
			m = map.basic("'", "m{char} goto mark"),
			M = map.basic("m", "m{char} set mark"),
			n = map.basic("j", "down"),
			N = map.basic("J", "join lines"),
			o = map.basic("l", "right"),
			O = map.basic("$", "right to EOL"),
			p = map.basic("p", "paste after"),
			P = map.basic("P", "paste before"),
			q = map.basic("q", "z{reg} record macro"),
			Q = map.basic("@", "Z{reg} play macro"),
			r = map.basic("r", "replace"),
			R = map.basic("R", "replace mode"),
			s = map.basic("s", "subsitute"),
			S = map.basic("S", "subsitute lines"),
			t = map.basic("f", "f{char} go to char"),
			T = map.basic("F", "T{char} go to char reverse"),
			u = map.basic("u", "undo"),
			U = map.basic("<C-r>", "redo"),
			v = map.basic("v", "visual mode"),
			V = map.basic("V", "visual line mode"),
			w = map.basic("w", "word forward"),
			W = map.basic("b", "word backward"),
			x = map.basic("x", "delete under cursor"),
			X = map.basic("X", "delete before cursor"),
			y = map.basic("h", "left"),
			Y = map.basic("^", "left to BOL"),
			z = map.basic("z", "z command"),
			Z = map.basic("Z", "Z command"),

			-- parens
			[")"] = map.basic(")", "next sentence"),
			["("] = map.basic("(", "prev sentence"),

			["}"] = map.basic("}", "next paragraph"),
			["{"] = map.basic("{", "prev paragraph"),

			["["] = map.basic("<C-o>", "jumplist back"),
			["]"] = map.basic("<C-i>", "jumplist forward"),

			["<"] = map.basic("<", "nudge left"),
			[">"] = map.basic(">", "nudge right"),

			-- case swap
			["~"] = map.basic("~", "case swap"),

			-- command
			[":"] = map.basic(":", "command mode"),
			["'"] = map.basic(":", "command mode"),
			["/"] = map.basic("/", "search down"),
			["?"] = map.basic("?", "search up"),

			-- register
			['"'] = map.basic('"', "register select"),

			-- repeat
			["&"] = map.basic("&", "repeat subsitute"),
			["!"] = map.basic(".", "repeat change"),

			-- cursor align
			["@"] = map.basic("zt", "align top"),
			["$"] = map.basic("zz", "align middle"),
			["#"] = map.basic("zb", "align bottom"),

			-- window nav
			["<C-w>k"] = map.noop(),
			["<C-w>l"] = map.noop(),
			["<C-w>y"] = map.basic("<C-w>h", "focus left"),
			["<C-w>n"] = map.basic("<C-w>j", "focus down"),
			["<C-w>e"] = map.basic("<C-w>k", "focus up"),
			["<C-w>o"] = map.basic("<C-w>l", "focus right"),
			["<C-w>x"] = map.basic(":close<CR>", "close pane"),
			["<C-w>f"] = map.basic(":on<CR>", "full screen"),
			["<C-w>h"] = map.basic(":sp<CR>", "split horizontal"),
			["<C-w>s"] = map.basic(":vs<CR>", "split verticle"),

			-- noop
			["%"] = map.noop(),
			["^"] = map.noop(),
			["="] = map.noop(),
			["*"] = map.noop(),
			["-"] = map.noop(),
			["_"] = map.noop(),
			["+"] = map.noop(),
			["|"] = map.noop(),
			[";"] = map.noop(),
			[","] = map.noop(),
			["."] = map.noop(),
		},
		c = {
			["<C-a>"] = map.basic("<home>", "goto BOL"),
			["<C-e>"] = map.basic("<end>", "goto EOL"),
		},
	},
	unruly_seek = {
		m = {
			["<leader>n"] = map.basic(boost.seek.seek_forward, "[N]ext Seek"),
			["<leader>p"] = map.basic(boost.seek.seek_reverse, "[P]rev Seek"),
			["<leader>sf"] = map.basic(boost.seek.seek_first, "[S]eek [F]irst"),
			["<leader>sl"] = map.basic(boost.seek.seek_last, "[S]eek [L]ast"),
			["<leader>sQ"] = map.basic(boost.seek.mode_set_quickfix, "[S]eek mode [Q]uickfix"),
			["<leader>sL"] = map.basic(boost.seek.mode_set_loclist, "[S]eek mode [L]oclist"),
			["<leader>sB"] = map.basic(boost.seek.mode_set_buffer, "[S]eek mode [B]uffer"),
		},
	},
	unruly_mark = {
		m = {
			m = map.basic(boost.mark.toggle_mode, "mark mode toggle"),
			M = map.basic(boost.mark.delete_mode, "mark delete mode"),
			["<c-a>"] = map.basic_expr(boost.mark.expr_goto_a, "GOTO MARK: a"),
			["<leader>a"] = map.basic_expr(boost.mark.expr_set_a, "MARK SET: a"),
			["<c-b>"] = map.basic_expr(boost.mark.expr_goto_b, "GOTO MARK: b"),
			["<leader>b"] = map.basic_expr(boost.mark.expr_set_b, "MARK SET: b"),
		},
	},
	unruly_macro_z = {
		m = {
			z = map.basic(boost.macro.record, "macro record"),
			Z = map.basic(boost.macro.play, "macro play"),
			["<c-z>"] = map.basic(boost.macro.select_register, "select macro register"),
			["<leader>zl"] = map.basic(boost.macro.lock_toggle, "Macro [L]ock Toggle"),
			['<leader>zp'] = map.basic(boost.macro.peek_register, "Macro [P]eek"),
		},
	},
	unruly_macro_q = {
		m = {
			q = map.basic(boost.macro.record, "macro record"),
			Q = map.basic(boost.macro.play, "macro play"),
			["<c-q>"] = map.basic(boost.macro.select_register, "select macro register"),
			["<leader>ql"] = map.basic(boost.macro.lock_toggle, "Macro [L]ock Toggle"),
			['<leader>qp'] = map.basic(boost.macro.peek_register, "Macro [P]eek"),
		},
	},
	unruly_kopy = {
		m = {
			['"'] = map.basic(boost.kopy.register_select, "select kopy_register"),
			-- delete
			c = map.basic(boost.kopy.create_delete_cmd("c"), "change content, store old in reg 0"),
			cc = map.basic(boost.kopy.create_delete_cmd("cc"), "changle lines, store old in reg 0"),
			C = map.basic(boost.kopy.create_delete_cmd("C"), "change to EOL, store old in reg 0"),
			d = map.basic(boost.kopy.create_delete_cmd("d"), "delete motion into reg 0"),
			dd = map.basic(boost.kopy.create_delete_cmd("dd"), "delete motion into reg 0"),
			D = map.basic(boost.kopy.create_delete_cmd("D"), "delete motion into reg 0"),
			x = map.basic(boost.kopy.create_delete_cmd("x"), "delete char into reg 0"),
			X = map.basic(boost.kopy.create_delete_cmd("X"), "delete previous char into reg 0"),
			-- kopy
			k = map.basic_expr(boost.kopy.expr_yank, "kopy"),
			K = map.basic_expr(boost.kopy.expr_yank_line, "kopy line"),
			-- paste
			-- p = map.basic_expr(action.kopy.expr_paste_below, "paste after")
			-- P = map.basic_expr(action.kopy.expr_paste_above, "paste before"),
			-- paste
			p = map.basic_expr(boost.kopy.expr_paste_below, "paste after"),
			P = map.basic_expr(boost.kopy.expr_paste_above, "paste before"),
			[","] = map.basic('"0P', "paste delete_reg above"),
			["."] = map.basic('"0p', "paste delete_reg below"),
		},
	},
	easy_window = {
		m = {
			["<C-x>"] = map.basic(":close<CR>", "close pane"),
			["<C-f>"] = map.basic(":on<CR>", "full screen"),
			["<C-h>"] = map.basic(":sp<CR>", "split horizontal"),
			["<C-s>"] = map.basic(":vs<CR>", "split verticle"),
		},
	},
	easy_source = {
		n = {
			["%"] = map.custom(function()
				local current_file = vim.fn.expandcmd("%")
				if current_file == "%" then
					log.error("cannot source noname buffer, try to save file beforce sourcing")
					return
				end
				local keys = vim.api.nvim_replace_termcodes(":source %<cr>", true, false, true)
				vim.api.nvim_feedkeys(keys, "n", false)
			end, map.no_remap, map.no_silent, "source current buffer"),
		},
	},
	unruly_quit_q = {
		m = {
			q = map.basic(boost.quit.write_all, "write all"),
			Q = map.basic(boost.quit.quit_all, "quit all"),
			-- Q = map.basic(":qall<cr>", "quit all"),
			-- ["<C-q>"] = map.basic(":qall!<cr>", "quit all force"),
			["<C-q>"] = map.basic(boost.quit.quit_force, "quit all force"),
		},
	},
	unruly_quit_z = {
		m = {
			z = map.basic(boost.quit.write_all, "write all"),
			Z = map.basic(boost.quit.quit_all, "quit all"),
			["<C-z>"] = map.basic(boost.quit.quit_force, "quit all force"),
		},
	},
	easy_scroll = {
		m = {
			["<End>"] = map.basic("9<C-E>", "scroll down fast"),
			["<PageDown>"] = map.basic("3<C-E>", "scroll down"),
			["<PageUp>"] = map.basic("3<C-Y>", "scroll up"),
			["<Home>"] = map.basic("9<C-Y>", "scroll down fast"),
		},
	},
	easy_focus = {
		m = {
			["<C-y>"] = map.basic("<C-w>h", "focus left"),
			["<C-n>"] = map.basic("<C-w>j", "focus down"),
			["<C-e>"] = map.basic("<C-w>k", "focus up"),
			["<C-o>"] = map.basic("<C-w>l", "focus right"),
		},
	},
	easy_spellcheck = {
		m = {
			["<leader>c"] = map.basic(boost.telescope.spell_suggest_safe, "[S]pell [C]heck"),
		}
	},
	easy_line = {
		m = {
			["<leader>ll"] = map.basic("o<esc>^d$<Up>", "[L]ine Below"),
			["<leader>lL"] = map.basic("O<esc>^d$<Down>", "[L]ine Above"),
		},
	},
	easy_find = {
		m = {
			["<leader>f"] = map.basic("g*", "[F]ind Word Under Cursor"),
			["<leader>F"] = map.basic("g#", "[F]ind Word Under Cursor Reverse"),
		},
	},
	easy_swap = {
		n = {
			["<C-Down>"] = map.basic(":m .+1<CR>==", "swap down"),
			["<C-Up>"] = map.basic(":m .-2<CR>==", "swap up"),
		},
		v = {
			["<C-Down>"] = map.basic(":m '>+1<CR>gv=gv", "swap down"),
			["<C-Up>"] = map.basic(":m '<-2<CR>gv=gv", "swap up"),
		},
	},
	easy_jumplist = {
		m = {
			["<c-j>"] = map.basic(boost.telescope.jump_list_safe, "jumplist"),
		},
	},
	easy_incrament = {
		v = {
			["<leader>i"] = map.basic("g<C-a>", "[I]ncrament Number Column"),
		},
	},
	easy_hlsearch = {
		n = {
			["<esc>"] = map.basic("<cmd>nohlsearch<CR>", "disable hl search"),
		},
	},
	easy_lsp = {
		m = {
			[";"] = map.basic(vim.lsp.buf.hover, "lsp hover"),
			["="] = map.basic(vim.lsp.buf.code_action, "lsp code action"),
			["<C-r>"] = map.basic(vim.lsp.buf.rename, "lsp rename"),
			["<C-d>"] = map.basic(boost.telescope.lsp_definiton_safe, "lsp definition"),
		},
	},
	easy_lsp_leader = {
		m = {
			["<leader>la"] = map.basic(vim.lsp.buf.code_action, "[L]sp Code [A]ction"),
			["<leader>lh"] = map.basic(vim.lsp.buf.hover, "[L]sp [H]over"),
			["<leader>ld"] = map.basic(boost.telescope.lsp_definiton_safe, "[L]sp goto [D]efinition"),
			["<leader>lD"] = map.basic(vim.lsp.buf.declaration, "[L]sp goto [D]eclaration"),
			["<leader>lf"] = map.basic(vim.lsp.buf.format, "[L]sp [F]ormat"),
			["<leader>lR"] = map.basic(vim.lsp.buf.rename, "[L]sp [R]ename"),
		},
	},
	easy_diagnostic = {
		m = {
			["_"] = map.basic(vim.diagnostic.goto_next, "diagnostic next"),
			["-"] = map.basic(vim.diagnostic.goto_prev, "diagnostic prev"),
		},
	},
	easy_diagnostic_leader = {
		m = {
			["<leader>dn"] = map.basic(vim.diagnostic.goto_next, "diagnostic next"),
			["<leader>dp"] = map.basic(vim.diagnostic.goto_prev, "diagnostic prev"),
		},
	},
	plugin_comment = {
		n = {
			["<C-c>"] = map.custom("gcc", map.remap, map.no_silent, "comment"),
		},
		v = {
			["<C-c>"] = map.custom("gc", map.remap, map.no_silent, "comment"),
		},
	},
	plugin_navigator = {
		m = {
			["<C-y>"] = map.custom(boost.navigator.focus_left_safe, map.no_remap, map.silent, "focus left (vim/tmux)"),
			["<C-n>"] = map.custom(boost.navigator.focus_down_safe, map.no_remap, map.silent, "focus down (vim/tmux)"),
			["<C-e>"] = map.custom(boost.navigator.focus_up_safe, map.no_remap, map.silent, "focus up (vim/tmux)"),
			["<C-o>"] = map.custom(boost.navigator.focus_right_safe, map.no_remap, map.silent, "focus right (vim/tmux)"),
		},
	},
	plugin_textobject = {
		n = {
			s = map.basic(boost.textobjects.goto_next, "seek textobject forward"),
			S = map.basic(boost.textobjects.goto_prev, "seek textobject reverse")
		},
		x = {
			s = map.basic(boost.textobjects.goto_next, "seek textobject forward"),
			S = map.basic(boost.textobjects.goto_prev, "seek textobject reverse")
		},
		o = {
			s = map.basic(boost.textobjects.goto_next, "seek textobject forward"),
			S = map.basic(boost.textobjects.goto_prev, "seek textobject reverse")
		},
	},
	plugin_luasnip = {
		i = {
			["<C-Right>"] = map.basic(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-Left>"] = map.basic(boost.luasnip.jump_reverse, "luasnip jump prev"),
			["<C-l>"] = map.basic(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-k>"] = map.basic(boost.luasnip.jump_reverse, "luasnip jump prev"),
		},
		s = {
			["<C-Right>"] = map.basic(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-Left>"] = map.basic(boost.luasnip.jump_reverse, "luasnip jump prev"),
			["<C-l>"] = map.basic(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-k>"] = map.basic(boost.luasnip.jump_reverse, "luasnip jump prev"),
		},
	},
	plugin_telescope_lsp_leader = {
		m = {
			-- telescope lsp
			["<leader>l?"] = map.basic(boost.telescope.diagnostics, "[L]sp Diagnostics"),
			["<leader>lc"] = map.basic(boost.telescope.lsp_incoming_calls, "[L]sp Incoming [C]alls"),
			["<leader>lC"] = map.basic(boost.telescope.lsp_outgoing_calls, "[L]sp Outgoing [C]alls"),
			["<leader>li"] = map.basic(boost.telescope.lsp_implementations, "[L]sp Goto [I]mplementation"),
			["<leader>lr"] = map.basic(boost.telescope.lsp_references, "[L]sp [R]eferences"),
			["<leader>ls"] = map.basic(boost.telescope.lsp_document_symbols, "[L]sp Document [S]ymbols"),
			["<leader>lS"] = map.basic(boost.telescope.lsp_workspace_symbols, "[L]sp Workspace [S]ymbols"),
			["<leader>l$"] = map.basic(boost.telescope.lsp_dynamic_workspace_symbols, "[L]sp Dynamic Workspace [S]ymbols"),
			["<leader>lt"] = map.basic(boost.telescope.lsp_type_definitions, "[L]sp [T]ypes"),
		}
	},
	plugin_telescope_easy_jump = {
		m = {
			j = map.basic(boost.telescope.find_files, "jump files"),
			J = map.basic(boost.telescope.live_grep, "jump files"),
		}
	},
	plugin_telescope_easy_paste = {
		m = {
			["<C-p>"] = map.basic(boost.telescope.registers, "Telescope Registers [P]aste"),
		}
	},
	plugin_telescope_leader = {
		m = {
			["<leader>/"] = map.basic(boost.telescope.buffer_fuzzy_search, "buffer fuzzy find"),
			["<leader>tb"] = map.basic(boost.telescope.buffers, "[T]elescope [B]uffers"),
			["<leader>to"] = map.basic(boost.telescope.oldfiles, "[T]elescope [O]ldfiles"),
			["<leader>tq"] = map.basic(boost.telescope.quickfix, "[T]elescope [Q]uickfix"),
			["<leader>tl"] = map.basic(boost.telescope.loclist, "[T]elescope [L]oclist"),
			["<leader>tj"] = map.basic(boost.telescope.jump_list_safe, "[T]elescope [J]umplist"),
			["<leader>tm"] = map.basic(boost.telescope.man_pages, "[T]elescope [M]an pages"),
			["<leader>th"] = map.basic(boost.telescope.help_tags, "[T]elescope [H]elp Tags"),
			["<leader>tt"] = map.basic(boost.telescope.man_pages, "[T]elescope [T]ags"),
			["<leader>tc"] = map.basic(boost.telescope.commands, "[T]elescope [C]ommands"),
			["<leader>tk"] = map.basic(boost.telescope.keymaps, "[T]elescope [K]eymaps"),
			["<leader>tp"] = map.basic(boost.telescope.registers, "[T]elescope [P]aste"),
			["<leader>tr"] = map.basic(boost.telescope.resume, "[T]elescope [R]epeat"),
		}
	},
}

local map_config = function(config, skip_list, boost_name)
	if config == nil then
		log.error("UNRULY SETUP ERROR: unknown boost (" .. boost_name .. ")")
		return
	end
	for mode, mode_map in pairs(config) do
		if mode == "m" then
			mode = ""
		end
		-- print("mode", mode, "config", config_name)
		for key, key_map in pairs(mode_map) do
			if map.should_map(key, skip_list) then
				vim.keymap.set(mode, key, key_map.value, {
					desc = key_map.desc,
					silent = key_map.is_silent,
					remap = key_map.is_remap,
					noremap = not key_map.is_remap,
					expr = key_map.is_expr,
				})
			end
		end
	end
end

local function is_config_legacy(config)
	return (config.enable_lsp_map ~= nil)
			or (config.enable_select_map ~= nil)
			or (config.enable_quote_command ~= nil)
			or (config.enable_easy_window_navigate ~= nil)
			or (config.enable_comment_map ~= nil)
			or (config.enable_wrap_navigate ~= nil)
			or (config.enable_visual_navigate ~= nil)
end

local setup_force = function(config)
	if config == nil then
		config = {}
	end

	local context = {
		booster   = {
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
			plugin_telescope_easy_paste = false,
		},
		skip_list = {},
	}

	if config.booster then
		context.booster = vim.tbl_extend("force", context.booster, config.booster)
	end

	if config.skip_list then
		context.skip_list = config.skip_list
	end

	if config.unruly_mark_global_mode then
		boost.mark.set_is_local_mode_silent(false)
	end

	if config.unruly_macro_register ~= nil then
		boost.macro.set_register_silent(config.unruly_macro_register)
	end

	if config.unruly_kopy_register ~= nil then
		boost.kopy.set_register_silent(config.unruly_kopy_register)
	end


	state.config = context
	state.is_config_legacy = is_config_legacy(config)

	if state.is_config_legacy then
		log.error("UNRULY_WARNING: unruly-worker had and update and your config is incompatable!")
	end

	-- TODO: figure out if i really want this
	if context.booster.unruly_macro ~= nil then
		if config.unruly_swap_q_and_z then
			context.booster.unruly_macro = nil
			context.booster.unruly_macro_z = true
		else
			context.booster.unruly_macro = nil
			context.booster.unruly_macro_q = true
		end
	end

	if context.booster.unruly_quit ~= nil then
		if config.unruly_swap_q_and_z then
			context.booster.unruly_quit = nil
			context.booster.unruly_quit_q = true
		else
			context.booster.unruly_quit = nil
			context.booster.unruly_quit_z = true
		end
	end

	if context.booster.easy_source then
		-- disable neovim from auto loading matchit
		vim.g.loaded_matchit = true
	end

	if context.booster.easy_hlsearch then
		-- enable hlsearh
		vim.opt.hlsearch = true
	end

	if context.booster.easy_focus and context.booster.plugin_navigator then
		context.booster.easy_focus = false
	end

	map_config(mapping.general, context.skip_list)

	-- TODO: force boost load order
	for booster, is_enabled in pairs(context.booster) do
		if is_enabled then
			map_config(mapping[booster], context.skip_list, booster)
		end
	end

	if config.unruly_greeting then
		log.info(log.emoticon() .. " " .. log.greeting())
	end

	state.is_setup = true
end

---@class UnrulyConfigBooster
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
---@field unruly_macro boolean
---@field unruly_kopy boolean
---@field unruly_quit boolean
---@field plugin_navigator boolean
---@field plugin_comment boolean
---@field plugin_luasnip boolean
---@field plugin_textobject boolean
---@field plugin_telescope_leader boolean
---@field plugin_telescope_lsp_leader boolean
---@field plugin_telescope_easy_jump boolean
---@field plugin_telescope_easy_paste boolean

---@class UnrulyConfig
---@field unruly_mark_global_mode boolean?
---@field unruly_swap_q_and_z boolean?
---@field unruly_macro_register string?
---@field unruly_kopy_register string?
---@field unruly_seek_mode SeekMode?
---@field unruly_greeting boolean?
---@field booster UnrulyConfigBooster?
---@field skip_list string[]?

---  configure and map unruly worker keymap
--- @param config UnrulyConfig?
local function setup(config)
	-- dont reload if  loaded
	if vim.g.unruly_worker then
		return
	end
	vim.g.unruly_worker = true
	setup_force(config)
end

local function get_status_text()
	local seek_status_text = ""
	if state.config ~= nil then
		if state.config.boost.unruly_seek then
			seek_status_text = " " .. boost.seek.get_status_text()
		end
	end
	return boost.mark.get_status_text()
			.. " " .. boost.macro.get_status_text()
			.. " " .. boost.kopy.get_status_text()
			.. seek_status_text
end


return {
	setup = setup,
	boost = boost,
	get_status_text = get_status_text,
	seek_mode = boost.seek.mode_option,
	_get_state = function()
		return state
	end
}
