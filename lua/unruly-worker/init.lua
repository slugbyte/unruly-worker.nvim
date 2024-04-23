--   __ _____  ______ __/ /_ _______    _____  ____/ /_____ ____
--  / // / _ \/ __/ // / / // /___/ |/|/ / _ \/ __/  '_/ -_) __/
--  \_,_/_//_/_/  \_,_/_/\_, /    |__,__/\___/_/ /_/\_\\__/_/
--                      /___/
--
--  Name: unruly-worker
--  License: Unlicense
--  Maintainer: Duncan Marsh (slugbyte@slugbyte.com)
--  Repository: https://github.com/slugbyte/unruly-worker


local rand = require("unruly-worker.rand")
local boost = require("unruly-worker.boost")
local map = require("unruly-worker.map")
local log = require("unruly-worker.log")
local hud = require("unruly-worker.hud")
local health = require("unruly-worker.health")
local config_util = require("unruly-worker.config-util")

---@class SpecBooster
---@field m table
---@field n table
---@field i table
---@field v table
---@field s table
---@field x table
---@field o table

local map_spec = {
	default = {
		m = {
			-- alphabet
			a = map.spec_custom("a", map.remap, map.no_silent, "append cursor"),
			A = map.spec_basic("A", "append line"),
			b = map.spec_basic("%", "brace match"),
			B = map.spec_basic("g;", "back to last change"),
			c = map.spec_basic("c", "change"),
			C = map.spec_basic("C", "change to end of line"),
			cc = map.spec_basic("C", "change lines"),
			d = map.spec_basic("d", "delete"),
			D = map.spec_basic("D", "delete to end of line"),
			dd = map.spec_basic("dd", "delete lines"),
			e = map.spec_basic("k", "up"),
			E = map.spec_basic("vip", "envelope paraghaph"),
			f = map.spec_basic("n", "find next"),
			F = map.spec_basic("N", "find prev"),
			g = map.spec_basic("g", "g command"),
			G = map.spec_basic("G", "goto line"),
			h = map.spec_basic(";", "hop t/T{char} repeat"),
			H = map.spec_basic(",", "hop t/T{char} reverse"),
			i = map.spec_basic("i", "insert"),
			I = map.spec_basic("I", "insert BOL"),
			j = map.spec_noop(),
			J = map.spec_noop(),
			k = map.spec_basic("y", "kopy"),
			K = map.spec_basic("Y", "kopy line"),
			l = map.spec_basic("o", "line insert below"),
			L = map.spec_basic("O", "line insert above"),
			m = map.spec_basic("'", "m{char} goto mark"),
			M = map.spec_basic("m", "m{char} set mark"),
			n = map.spec_basic("j", "down"),
			N = map.spec_basic("J", "join lines"),
			o = map.spec_basic("l", "right"),
			O = map.spec_basic("$", "right to EOL"),
			p = map.spec_basic("p", "paste after"),
			P = map.spec_basic("P", "paste before"),
			q = map.spec_basic("q", "z{reg} record macro"),
			Q = map.spec_basic("@", "Z{reg} play macro"),
			r = map.spec_basic("r", "replace"),
			R = map.spec_basic("R", "replace mode"),
			s = map.spec_basic("s", "subsitute"),
			S = map.spec_basic("S", "subsitute lines"),
			t = map.spec_basic("f", "f{char} go to char"),
			T = map.spec_basic("F", "T{char} go to char reverse"),
			u = map.spec_basic("u", "undo"),
			U = map.spec_basic("<C-r>", "redo"),
			v = map.spec_basic("v", "visual mode"),
			V = map.spec_basic("V", "visual line mode"),
			w = map.spec_basic("w", "word forward"),
			W = map.spec_basic("b", "word backward"),
			x = map.spec_basic("x", "delete under cursor"),
			X = map.spec_basic("X", "delete before cursor"),
			y = map.spec_basic("h", "left"),
			Y = map.spec_basic("^", "left to BOL"),
			z = map.spec_basic("z", "z command"),
			Z = map.spec_basic("Z", "Z command"),

			-- parens
			[")"] = map.spec_basic(")", "next sentence"),
			["("] = map.spec_basic("(", "prev sentence"),

			["}"] = map.spec_basic("}", "next paragraph"),
			["{"] = map.spec_basic("{", "prev paragraph"),

			["["] = map.spec_basic("<C-o>", "jumplist back"),
			["]"] = map.spec_basic("<C-i>", "jumplist forward"),

			["<"] = map.spec_basic("<", "nudge left"),
			[">"] = map.spec_basic(">", "nudge right"),

			-- case swap
			["~"] = map.spec_basic("~", "case swap"),

			-- command
			[":"] = map.spec_basic(":", "command mode"),
			["'"] = map.spec_basic(":", "command mode"),
			["/"] = map.spec_basic("/", "search down"),
			["?"] = map.spec_basic("?", "search up"),

			-- register
			['"'] = map.spec_basic('"', "register select"),

			-- repeat
			["&"] = map.spec_basic("&", "repeat subsitute"),
			["!"] = map.spec_basic(".", "repeat change"),

			-- cursor align
			["@"] = map.spec_basic("zt", "align top"),
			["$"] = map.spec_basic("zz", "align middle"),
			["#"] = map.spec_basic("zb", "align bottom"),

			-- window nav
			["<C-w>k"] = map.spec_noop(),
			["<C-w>l"] = map.spec_noop(),
			["<C-w>y"] = map.spec_basic("<C-w>h", "focus left"),
			["<C-w>n"] = map.spec_basic("<C-w>j", "focus down"),
			["<C-w>e"] = map.spec_basic("<C-w>k", "focus up"),
			["<C-w>o"] = map.spec_basic("<C-w>l", "focus right"),
			["<C-w>x"] = map.spec_basic(":close<CR>", "close pane"),
			["<C-w>f"] = map.spec_basic(":on<CR>", "full screen"),
			["<C-w>h"] = map.spec_basic(":sp<CR>", "split horizontal"),
			["<C-w>s"] = map.spec_basic(":vs<CR>", "split verticle"),

			-- noop
			["%"] = map.spec_noop(),
			["^"] = map.spec_noop(),
			["="] = map.spec_noop(),
			["*"] = map.spec_noop(),
			["-"] = map.spec_noop(),
			["_"] = map.spec_noop(),
			["+"] = map.spec_noop(),
			["|"] = map.spec_noop(),
			[";"] = map.spec_noop(),
			[","] = map.spec_noop(),
			["."] = map.spec_noop(),
		},
		c = {
			["<C-a>"] = map.spec_basic("<home>", "goto BOL"),
			["<C-e>"] = map.spec_basic("<end>", "goto EOL"),
		},
	},
	unruly_seek = {
		m = {
			["<leader>n"] = map.spec_basic(boost.seek.seek_forward, "[N]ext Seek"),
			["<leader>p"] = map.spec_basic(boost.seek.seek_reverse, "[P]rev Seek"),
			["<leader>sf"] = map.spec_basic(boost.seek.seek_first, "[S]eek [F]irst"),
			["<leader>sl"] = map.spec_basic(boost.seek.seek_last, "[S]eek [L]ast"),
			["<leader>sQ"] = map.spec_basic(boost.seek.mode_set_quickfix, "[S]eek mode [Q]uickfix"),
			["<leader>sL"] = map.spec_basic(boost.seek.mode_set_loclist, "[S]eek mode [L]oclist"),
			["<leader>sB"] = map.spec_basic(boost.seek.mode_set_buffer, "[S]eek mode [B]uffer"),
		},
	},
	unruly_mark = {
		m = {
			m = map.spec_basic(boost.mark.toggle_mode, "mark mode toggle"),
			M = map.spec_basic(boost.mark.delete_mode, "mark delete mode"),
			["<c-a>"] = map.basic_expr(boost.mark.expr_goto_a, "GOTO MARK: a"),
			["<leader>a"] = map.basic_expr(boost.mark.expr_set_a, "MARK SET: a"),
			["<c-b>"] = map.basic_expr(boost.mark.expr_goto_b, "GOTO MARK: b"),
			["<leader>b"] = map.basic_expr(boost.mark.expr_set_b, "MARK SET: b"),
		},
	},
	unruly_macro_z = {
		m = {
			z = map.spec_basic(boost.macro.record, "macro record"),
			Z = map.spec_basic(boost.macro.play, "macro play"),
			["<c-z>"] = map.spec_basic(boost.macro.select_register, "select macro register"),
			["<leader>zl"] = map.spec_basic(boost.macro.lock_toggle, "Macro [L]ock Toggle"),
			['<leader>zp'] = map.spec_basic(boost.macro.peek_register, "Macro [P]eek"),
		},
	},
	unruly_macro_q = {
		m = {
			q = map.spec_basic(boost.macro.record, "macro record"),
			Q = map.spec_basic(boost.macro.play, "macro play"),
			["<c-q>"] = map.spec_basic(boost.macro.select_register, "select macro register"),
			["<leader>ql"] = map.spec_basic(boost.macro.lock_toggle, "Macro [L]ock Toggle"),
			['<leader>qp'] = map.spec_basic(boost.macro.peek_register, "Macro [P]eek"),
		},
	},
	unruly_kopy = {
		m = {
			['"'] = map.spec_basic(boost.kopy.register_select, "select kopy_register"),
			-- delete
			c = map.spec_basic(boost.kopy.create_delete_cmd("c"), "change content, store old in reg 0"),
			cc = map.spec_basic(boost.kopy.create_delete_cmd("cc"), "changle lines, store old in reg 0"),
			C = map.spec_basic(boost.kopy.create_delete_cmd("C"), "change to EOL, store old in reg 0"),
			d = map.spec_basic(boost.kopy.create_delete_cmd("d"), "delete motion into reg 0"),
			dd = map.spec_basic(boost.kopy.create_delete_cmd("dd"), "delete motion into reg 0"),
			D = map.spec_basic(boost.kopy.create_delete_cmd("D"), "delete motion into reg 0"),
			x = map.spec_basic(boost.kopy.create_delete_cmd("x"), "delete char into reg 0"),
			X = map.spec_basic(boost.kopy.create_delete_cmd("X"), "delete previous char into reg 0"),
			-- kopy
			k = map.basic_expr(boost.kopy.expr_yank, "kopy"),
			K = map.basic_expr(boost.kopy.expr_yank_line, "kopy line"),
			-- paste
			-- p = map.basic_expr(action.kopy.expr_paste_below, "paste after")
			-- P = map.basic_expr(action.kopy.expr_paste_above, "paste before"),
			-- paste
			p = map.basic_expr(boost.kopy.expr_paste_below, "paste after"),
			P = map.basic_expr(boost.kopy.expr_paste_above, "paste before"),
			[","] = map.spec_basic('"0P', "paste delete_reg above"),
			["."] = map.spec_basic('"0p', "paste delete_reg below"),
		},
	},
	easy_window = {
		m = {
			["<C-x>"] = map.spec_basic(":close<CR>", "close pane"),
			["<C-f>"] = map.spec_basic(":on<CR>", "full screen"),
			["<C-h>"] = map.spec_basic(":sp<CR>", "split horizontal"),
			["<C-s>"] = map.spec_basic(":vs<CR>", "split verticle"),
		},
	},
	easy_source = {
		n = {
			["%"] = map.spec_custom(function()
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
			q = map.spec_custom(boost.quit.write_all, map.no_remap, map.silent, "write all"),
			Q = map.spec_custom(boost.quit.write_file, map.no_remap, map.silent, "write file"),
			["<c-q>"] = map.spec_custom_expr(boost.quit.quit_all_prompt_expr, map.no_remap, map.silent, "quit prompt"),
		},
	},
	unruly_quit_z = {
		m = {
			z = map.spec_custom(boost.quit.write_all, map.no_remap, map.silent, "write all"),
			Z = map.spec_custom(boost.quit.write_file, map.no_remap, map.silent, "write file"),
			["<c-z>"] = map.spec_custom_expr(boost.quit.quit_all_prompt_expr, map.no_remap, map.silent, "quit prompt"),
		},
	},
	easy_scroll = {
		m = {
			["<End>"] = map.spec_basic("9<C-E>", "scroll down fast"),
			["<PageDown>"] = map.spec_basic("3<C-E>", "scroll down"),
			["<PageUp>"] = map.spec_basic("3<C-Y>", "scroll up"),
			["<Home>"] = map.spec_basic("9<C-Y>", "scroll down fast"),
		},
	},
	easy_focus = {
		m = {
			["<C-y>"] = map.spec_basic("<C-w>h", "focus left"),
			["<C-n>"] = map.spec_basic("<C-w>j", "focus down"),
			["<C-e>"] = map.spec_basic("<C-w>k", "focus up"),
			["<C-o>"] = map.spec_basic("<C-w>l", "focus right"),
		},
	},
	easy_spellcheck = {
		m = {
			["<leader>c"] = map.spec_basic(boost.telescope.spell_suggest_safe, "[S]pell [C]heck"),
		}
	},
	easy_line = {
		m = {
			["<leader>ll"] = map.spec_basic("o<esc>^d$<Up>", "[L]ine Below"),
			["<leader>lL"] = map.spec_basic("O<esc>^d$<Down>", "[L]ine Above"),
		},
	},
	easy_find = {
		m = {
			["<leader>f"] = map.spec_basic("g*", "[F]ind Word Under Cursor"),
			["<leader>F"] = map.spec_basic("g#", "[F]ind Word Under Cursor Reverse"),
		},
	},
	easy_swap = {
		n = {
			["<C-Down>"] = map.spec_basic(":m .+1<CR>==", "swap down"),
			["<C-Up>"] = map.spec_basic(":m .-2<CR>==", "swap up"),
		},
		v = {
			["<C-Down>"] = map.spec_basic(":m '>+1<CR>gv=gv", "swap down"),
			["<C-Up>"] = map.spec_basic(":m '<-2<CR>gv=gv", "swap up"),
		},
	},
	easy_jumplist = {
		m = {
			["<c-j>"] = map.spec_basic(boost.telescope.jump_list_safe, "jumplist"),
		},
	},
	easy_incrament = {
		v = {
			["<leader>i"] = map.spec_basic("g<C-a>", "[I]ncrament Number Column"),
		},
	},
	easy_hlsearch = {
		n = {
			["<esc>"] = map.spec_basic("<cmd>nohlsearch<CR>", "disable hl search"),
		},
	},
	easy_lsp = {
		m = {
			[";"] = map.spec_basic(vim.lsp.buf.hover, "lsp hover"),
			["="] = map.spec_basic(vim.lsp.buf.code_action, "lsp code action"),
			["<C-r>"] = map.spec_basic(vim.lsp.buf.rename, "lsp rename"),
			["<C-d>"] = map.spec_basic(boost.telescope.lsp_definiton_safe, "lsp definition"),
		},
	},
	easy_lsp_leader = {
		m = {
			["<leader>la"] = map.spec_basic(vim.lsp.buf.code_action, "[L]sp Code [A]ction"),
			["<leader>lh"] = map.spec_basic(vim.lsp.buf.hover, "[L]sp [H]over"),
			["<leader>ld"] = map.spec_basic(boost.telescope.lsp_definiton_safe, "[L]sp goto [D]efinition"),
			["<leader>lD"] = map.spec_basic(vim.lsp.buf.declaration, "[L]sp goto [D]eclaration"),
			["<leader>lf"] = map.spec_basic(vim.lsp.buf.format, "[L]sp [F]ormat"),
			["<leader>lR"] = map.spec_basic(vim.lsp.buf.rename, "[L]sp [R]ename"),
		},
	},
	easy_diagnostic = {
		m = {
			["_"] = map.spec_basic(vim.diagnostic.goto_next, "diagnostic next"),
			["-"] = map.spec_basic(vim.diagnostic.goto_prev, "diagnostic prev"),
		},
	},
	easy_diagnostic_leader = {
		m = {
			["<leader>dn"] = map.spec_basic(vim.diagnostic.goto_next, "diagnostic next"),
			["<leader>dp"] = map.spec_basic(vim.diagnostic.goto_prev, "diagnostic prev"),
			["<leader>d?"] = map.spec_basic(boost.telescope.diagnostics, "[L]sp Diagnostics"),
		},
	},
	plugin_comment = {
		n = {
			["<C-c>"] = map.spec_custom("gcc", map.remap, map.no_silent, "comment"),
		},
		v = {
			["<C-c>"] = map.spec_custom("gc", map.remap, map.no_silent, "comment"),
		},
	},
	plugin_navigator = {
		m = {
			["<C-y>"] = map.spec_custom(boost.navigator.focus_left_safe, map.no_remap, map.silent, "focus left (vim/tmux)"),
			["<C-n>"] = map.spec_custom(boost.navigator.focus_down_safe, map.no_remap, map.silent, "focus down (vim/tmux)"),
			["<C-e>"] = map.spec_custom(boost.navigator.focus_up_safe, map.no_remap, map.silent, "focus up (vim/tmux)"),
			["<C-o>"] = map.spec_custom(boost.navigator.focus_right_safe, map.no_remap, map.silent, "focus right (vim/tmux)"),
		},
	},
	plugin_textobject = {
		n = {
			s = map.spec_basic(boost.textobjects.goto_next, "skip textobject forward"),
			S = map.spec_basic(boost.textobjects.goto_prev, "skip textobject reverse")
		},
		x = {
			s = map.spec_basic(boost.textobjects.goto_next, "skip textobject forward"),
			S = map.spec_basic(boost.textobjects.goto_prev, "skip textobject reverse")
		},
		o = {
			s = map.spec_basic(boost.textobjects.goto_next, "skip textobject forward"),
			S = map.spec_basic(boost.textobjects.goto_prev, "skip textobject reverse")
		},
	},
	plugin_luasnip = {
		i = {
			["<C-Right>"] = map.spec_basic(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-Left>"] = map.spec_basic(boost.luasnip.jump_reverse, "luasnip jump prev"),
			["<C-l>"] = map.spec_basic(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-k>"] = map.spec_basic(boost.luasnip.jump_reverse, "luasnip jump prev"),
		},
		s = {
			["<C-Right>"] = map.spec_basic(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-Left>"] = map.spec_basic(boost.luasnip.jump_reverse, "luasnip jump prev"),
			["<C-l>"] = map.spec_basic(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-k>"] = map.spec_basic(boost.luasnip.jump_reverse, "luasnip jump prev"),
		},
	},
	plugin_telescope_lsp_leader = {
		m = {
			-- telescope lsp
			["<leader>lc"] = map.spec_basic(boost.telescope.lsp_incoming_calls, "[L]sp Incoming [C]alls"),
			["<leader>lC"] = map.spec_basic(boost.telescope.lsp_outgoing_calls, "[L]sp Outgoing [C]alls"),
			["<leader>li"] = map.spec_basic(boost.telescope.lsp_implementations, "[L]sp Goto [I]mplementation"),
			["<leader>lr"] = map.spec_basic(boost.telescope.lsp_references, "[L]sp [R]eferences"),
			["<leader>ls"] = map.spec_basic(boost.telescope.lsp_document_symbols, "[L]sp Document [S]ymbols"),
			["<leader>lS"] = map.spec_basic(boost.telescope.lsp_workspace_symbols, "[L]sp Workspace [S]ymbols"),
			["<leader>l$"] = map.spec_basic(boost.telescope.lsp_dynamic_workspace_symbols, "[L]sp Dynamic Workspace [S]ymbols"),
			["<leader>lt"] = map.spec_basic(boost.telescope.lsp_type_definitions, "[L]sp [T]ypes"),
		}
	},
	plugin_telescope_easy_jump = {
		m = {
			j = map.spec_basic(boost.telescope.find_files, "jump files"),
			J = map.spec_basic(boost.telescope.live_grep, "jump files"),
		}
	},
	plugin_telescope_easy_paste = {
		m = {
			["<C-p>"] = map.spec_basic(boost.telescope.registers, "Telescope Registers [P]aste"),
		}
	},
	plugin_telescope_leader = {
		m = {
			["<leader>/"] = map.spec_basic(boost.telescope.buffer_fuzzy_search, "buffer fuzzy find"),
			["<leader>tb"] = map.spec_basic(boost.telescope.buffers, "[T]elescope [B]uffers"),
			["<leader>to"] = map.spec_basic(boost.telescope.oldfiles, "[T]elescope [O]ldfiles"),
			["<leader>tq"] = map.spec_basic(boost.telescope.quickfix, "[T]elescope [Q]uickfix"),
			["<leader>tl"] = map.spec_basic(boost.telescope.loclist, "[T]elescope [L]oclist"),
			["<leader>tj"] = map.spec_basic(boost.telescope.jump_list_safe, "[T]elescope [J]umplist"),
			["<leader>tm"] = map.spec_basic(boost.telescope.man_pages, "[T]elescope [M]an pages"),
			["<leader>th"] = map.spec_basic(boost.telescope.help_tags, "[T]elescope [H]elp Tags"),
			["<leader>tt"] = map.spec_basic(boost.telescope.man_pages, "[T]elescope [T]ags"),
			["<leader>tc"] = map.spec_basic(boost.telescope.commands, "[T]elescope [C]ommands"),
			["<leader>tk"] = map.spec_basic(boost.telescope.keymaps, "[T]elescope [K]eymaps"),
			["<leader>tp"] = map.spec_basic(boost.telescope.registers, "[T]elescope [P]aste"),
			["<leader>tr"] = map.spec_basic(boost.telescope.resume, "[T]elescope [R]epeat"),
		}
	},
}

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
---	  	plugin_telescope_easy_paste = true,
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
	local config = config_util.normalize_user_config(user_config)

	if is_config_legacy then
		log.error("UNRULY SETUP ERROR: unruly-worker had and update and your setup() config is incompatable!")
	end

	config_util.apply_default_options(config)
	map.create_keymaps(map_spec, config)

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
