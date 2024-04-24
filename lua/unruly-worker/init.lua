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
local spec = require("unruly-worker.spec")

---@type UnrulySpecKeymap
local keymap = {
	default = {
		m = {
			-- alphabet
			a = spec.remap("a", "append cursor"),
			A = spec.map("A", "append line"),
			b = spec.map("%", "brace match"),
			B = spec.map("g;", "back to last change"),
			c = spec.map("c", "change"),
			C = spec.map("C", "change to end of line"),
			cc = spec.map("C", "change lines"),
			d = spec.map("d", "delete"),
			D = spec.map("D", "delete to end of line"),
			dd = spec.map("dd", "delete lines"),
			e = spec.map("k", "up"),
			E = spec.map("vip", "envelope paraghaph"),
			f = spec.map("n", "find next"),
			F = spec.map("N", "find prev"),
			g = spec.map("g", "g command"),
			G = spec.map("G", "goto line"),
			h = spec.map(";", "hop t/T{char} repeat"),
			H = spec.map(",", "hop t/T{char} reverse"),
			i = spec.map("i", "insert"),
			I = spec.map("I", "insert BOL"),
			j = spec.noop(),
			J = spec.noop(),
			k = spec.map("y", "kopy"),
			K = spec.map("Y", "kopy line"),
			l = spec.map("o", "line insert below"),
			L = spec.map("O", "line insert above"),
			m = spec.map("'", "m{char} goto mark"),
			M = spec.map("m", "m{char} set mark"),
			n = spec.map("j", "down"),
			N = spec.map("J", "join lines"),
			o = spec.map("l", "right"),
			O = spec.map("$", "right to EOL"),
			p = spec.map("p", "paste after"),
			P = spec.map("P", "paste before"),
			["<C-p>"] = spec.expr(boost.kopy.expr_prompt_paste, "paste before"),
			q = spec.map("q", "z{reg} record macro"),
			Q = spec.map("@", "Z{reg} play macro"),
			r = spec.map("r", "replace"),
			R = spec.map("R", "replace mode"),
			s = spec.map("s", "subsitute"),
			S = spec.map("S", "subsitute lines"),
			t = spec.map("f", "f{char} go to char"),
			T = spec.map("F", "T{char} go to char reverse"),
			u = spec.map("u", "undo"),
			U = spec.map("<C-r>", "redo"),
			v = spec.map("v", "visual mode"),
			V = spec.map("V", "visual line mode"),
			w = spec.map("w", "word forward"),
			W = spec.map("b", "word backward"),
			x = spec.map("x", "delete under cursor"),
			X = spec.map("X", "delete before cursor"),
			y = spec.map("h", "left"),
			Y = spec.map("^", "left to BOL"),
			z = spec.map("z", "z command"),
			Z = spec.map("Z", "Z command"),

			-- parens
			[")"] = spec.map(")", "next sentence"),
			["("] = spec.map("(", "prev sentence"),

			["}"] = spec.map("}", "next paragraph"),
			["{"] = spec.map("{", "prev paragraph"),

			["["] = spec.map("<C-o>", "jumplist back"),
			["]"] = spec.map("<C-i>", "jumplist forward"),

			["<"] = spec.map("<", "nudge left"),
			[">"] = spec.map(">", "nudge right"),

			-- case swap
			["~"] = spec.map("~", "case swap"),

			-- command
			[":"] = spec.map(":", "command mode"),
			["'"] = spec.map(":", "command mode"),
			["/"] = spec.map("/", "search down"),
			["?"] = spec.map("?", "search up"),

			-- register
			['"'] = spec.map('"', "register select"),

			-- repeat
			["&"] = spec.map("&", "repeat subsitute"),
			["!"] = spec.map(".", "repeat change"),

			-- cursor align
			["@"] = spec.map("zt", "align top"),
			["$"] = spec.map("zz", "align middle"),
			["#"] = spec.map("zb", "align bottom"),

			-- window nav
			["<C-w>k"] = spec.noop(),
			["<C-w>l"] = spec.noop(),
			["<C-w>y"] = spec.map("<C-w>h", "focus left"),
			["<C-w>n"] = spec.map("<C-w>j", "focus down"),
			["<C-w>e"] = spec.map("<C-w>k", "focus up"),
			["<C-w>o"] = spec.map("<C-w>l", "focus right"),
			["<C-w>x"] = spec.map(":close<CR>", "close pane"),
			["<C-w>f"] = spec.map(":on<CR>", "full screen"),
			["<C-w>h"] = spec.map(":sp<CR>", "split horizontal"),
			["<C-w>s"] = spec.map(":vs<CR>", "split verticle"),

			-- noop
			["%"] = spec.noop(),
			["^"] = spec.noop(),
			["="] = spec.noop(),
			["*"] = spec.noop(),
			["-"] = spec.noop(),
			["_"] = spec.noop(),
			["+"] = spec.noop(),
			["|"] = spec.noop(),
			[";"] = spec.noop(),
			[","] = spec.noop(),
			["."] = spec.noop(),
		},
		c = {
			["<C-a>"] = spec.map("<home>", "goto BOL"),
			["<C-e>"] = spec.map("<end>", "goto EOL"),
		},
	},
	unruly_seek = {
		m = {
			["<leader>sn"] = spec.map(boost.seek.seek_forward, "[N]ext Seek"),
			["<leader>sp"] = spec.map(boost.seek.seek_reverse, "[P]rev Seek"),
			["<leader>sf"] = spec.map(boost.seek.seek_first, "[S]eek [F]irst"),
			["<leader>sl"] = spec.map(boost.seek.seek_last, "[S]eek [L]ast"),
			["<leader>sQ"] = spec.map(boost.seek.mode_set_quickfix, "[S]eek mode [Q]uickfix"),
			["<leader>sL"] = spec.map(boost.seek.mode_set_loclist, "[S]eek mode [L]oclist"),
			["<leader>sB"] = spec.map(boost.seek.mode_set_buffer, "[S]eek mode [B]uffer"),
		},
	},
	unruly_mark = {
		m = {
			m = spec.map(boost.mark.toggle_mode, "mark mode toggle"),
			M = spec.map(boost.mark.delete_mode, "mark delete mode"),
			["<c-a>"] = spec.expr(boost.mark.expr_goto_a, "GOTO MARK: a"),
			["<leader>a"] = spec.expr(boost.mark.expr_set_a, "MARK SET: a"),
			["<c-b>"] = spec.expr(boost.mark.expr_goto_b, "GOTO MARK: b"),
			["<leader>b"] = spec.expr(boost.mark.expr_set_b, "MARK SET: b"),
		},
	},
	unruly_macro_z = {
		m = {
			z = spec.map(boost.macro.record, "macro record"),
			Z = spec.map(boost.macro.play, "macro play"),
			["<c-z>"] = spec.map(boost.macro.select_register, "select macro register"),
			["<leader>zl"] = spec.map(boost.macro.lock_toggle, "Macro [L]ock Toggle"),
			['<leader>zp'] = spec.map(boost.macro.peek_register, "Macro [P]eek"),
		},
	},
	unruly_macro_q = {
		m = {
			q = spec.map(boost.macro.record, "macro record"),
			Q = spec.map(boost.macro.play, "macro play"),
			["<c-q>"] = spec.map(boost.macro.select_register, "select macro register"),
			["<leader>ql"] = spec.map(boost.macro.lock_toggle, "Macro [L]ock Toggle"),
			['<leader>qp'] = spec.map(boost.macro.peek_register, "Macro [P]eek"),
		},
	},
	unruly_kopy = {
		m = {
			['"'] = spec.map(boost.kopy.register_select, "select kopy_register"),
			-- delete
			c = spec.map(boost.kopy.create_delete_cmd("c"), "change content, store old in reg 0"),
			cc = spec.map(boost.kopy.create_delete_cmd("cc"), "changle lines, store old in reg 0"),
			C = spec.map(boost.kopy.create_delete_cmd("C"), "change to EOL, store old in reg 0"),
			d = spec.map(boost.kopy.create_delete_cmd("d"), "delete motion into reg 0"),
			dd = spec.map(boost.kopy.create_delete_cmd("dd"), "delete motion into reg 0"),
			D = spec.map(boost.kopy.create_delete_cmd("D"), "delete motion into reg 0"),
			x = spec.map(boost.kopy.create_delete_cmd("x"), "delete char into reg 0"),
			X = spec.map(boost.kopy.create_delete_cmd("X"), "delete previous char into reg 0"),
			-- kopy
			k = spec.expr(boost.kopy.expr_yank, "kopy"),
			K = spec.expr(boost.kopy.expr_yank_line, "kopy line"),
			-- paste
			-- p = map.basic_expr(action.kopy.expr_paste_below, "paste after")
			-- P = map.basic_expr(action.kopy.expr_paste_above, "paste before"),
			-- paste
			p = spec.expr(boost.kopy.expr_paste_below, "paste after"),
			P = spec.expr(boost.kopy.expr_paste_above, "paste before"),
			[","] = spec.map('"0P', "paste delete_reg above"),
			["."] = spec.map('"0p', "paste delete_reg below"),
		},
	},
	easy_window = {
		m = {
			["<C-x>"] = spec.map(":close<CR>", "close pane"),
			["<C-f>"] = spec.map(":on<CR>", "full screen"),
			["<C-h>"] = spec.map(":sp<CR>", "split horizontal"),
			["<C-s>"] = spec.map(":vs<CR>", "split verticle"),
		},
	},
	easy_source = {
		n = {
			["%"] = spec.map(boost.source.source_file, "source current buffer"),
		},
	},
	unruly_quit_q = {
		m = {
			q = spec.map(boost.quit.write_all, "write all", map.silent),
			Q = spec.map(boost.quit.write_file, "write file", map.silent),
			["<c-q>"] = spec.expr(boost.quit.quit_all_prompt_expr, "quit prompt", map.silent),
		},
	},
	unruly_quit_z = {
		m = {
			z = spec.map(boost.quit.write_all, "write all", map.silent),
			Z = spec.map(boost.quit.write_file, "write file", map.silent),
			["<c-z>"] = spec.expr(boost.quit.quit_all_prompt_expr, "quit prompt", map.silent),
		},
	},
	easy_scroll = {
		m = {
			["<End>"] = spec.map("9<C-E>", "scroll down fast"),
			["<PageDown>"] = spec.map("3<C-E>", "scroll down"),
			["<PageUp>"] = spec.map("3<C-Y>", "scroll up"),
			["<Home>"] = spec.map("9<C-Y>", "scroll down fast"),
		},
	},
	easy_focus = {
		m = {
			["<C-y>"] = spec.map("<C-w>h", "focus left"),
			["<C-n>"] = spec.map("<C-w>j", "focus down"),
			["<C-e>"] = spec.map("<C-w>k", "focus up"),
			["<C-o>"] = spec.map("<C-w>l", "focus right"),
		},
	},
	easy_spellcheck = {
		m = {
			["<leader>c"] = spec.map(boost.telescope.spell_suggest_safe, "[S]pell [C]heck"),
		}
	},
	easy_line = {
		m = {
			["<leader>ll"] = spec.map("o<esc>^d$<Up>", "[L]ine Below"),
			["<leader>lL"] = spec.map("O<esc>^d$<Down>", "[L]ine Above"),
		},
	},
	easy_find = {
		m = {
			["<leader>f"] = spec.map("g*", "[F]ind Word Under Cursor"),
			["<leader>F"] = spec.map("g#", "[F]ind Word Under Cursor Reverse"),
		},
	},
	easy_swap = {
		n = {
			["<C-Down>"] = spec.map(":m .+1<CR>==", "swap down"),
			["<C-Up>"] = spec.map(":m .-2<CR>==", "swap up"),
		},
		v = {
			["<C-Down>"] = spec.map(":m '>+1<CR>gv=gv", "swap down"),
			["<C-Up>"] = spec.map(":m '<-2<CR>gv=gv", "swap up"),
		},
	},
	easy_jumplist = {
		m = {
			["<c-j>"] = spec.map(boost.telescope.jump_list_safe, "jumplist"),
		},
	},
	easy_incrament = {
		v = {
			["<leader>i"] = spec.map("g<C-a>", "[I]ncrament Number Column"),
		},
	},
	easy_hlsearch = {
		n = {
			["<esc>"] = spec.map("<cmd>nohlsearch<CR>", "disable hl search"),
		},
	},
	easy_lsp = {
		m = {
			[";"] = spec.map(vim.lsp.buf.hover, "lsp hover"),
			["="] = spec.map(vim.lsp.buf.code_action, "lsp code action"),
			["<C-r>"] = spec.map(vim.lsp.buf.rename, "lsp rename"),
			["<C-d>"] = spec.map(boost.telescope.lsp_definiton_safe, "lsp definition"),
		},
	},
	easy_lsp_leader = {
		m = {
			["<leader>la"] = spec.map(vim.lsp.buf.code_action, "[L]sp Code [A]ction"),
			["<leader>lh"] = spec.map(vim.lsp.buf.hover, "[L]sp [H]over"),
			["<leader>ld"] = spec.map(boost.telescope.lsp_definiton_safe, "[L]sp goto [D]efinition"),
			["<leader>lD"] = spec.map(vim.lsp.buf.declaration, "[L]sp goto [D]eclaration"),
			["<leader>lf"] = spec.map(vim.lsp.buf.format, "[L]sp [F]ormat"),
			["<leader>lR"] = spec.map(vim.lsp.buf.rename, "[L]sp [R]ename"),
		},
	},
	easy_diagnostic = {
		m = {
			["_"] = spec.map(vim.diagnostic.goto_next, "diagnostic next"),
			["-"] = spec.map(vim.diagnostic.goto_prev, "diagnostic prev"),
		},
	},
	easy_diagnostic_leader = {
		m = {
			["<leader>dn"] = spec.map(vim.diagnostic.goto_next, "diagnostic next"),
			["<leader>dp"] = spec.map(vim.diagnostic.goto_prev, "diagnostic prev"),
			["<leader>d?"] = spec.map(boost.telescope.diagnostics, "[L]sp Diagnostics"),
		},
	},
	plugin_comment = {
		n = {
			["<C-c>"] = spec.remap("gcc", "comment"),
		},
		v = {
			["<C-c>"] = spec.remap("gc", "comment"),
		},
	},
	plugin_navigator = {
		m = {
			["<C-y>"] = spec.map(boost.navigator.focus_left_safe, "focus left (vim/tmux)"),
			["<C-n>"] = spec.map(boost.navigator.focus_down_safe, "focus down (vim/tmux)"),
			["<C-e>"] = spec.map(boost.navigator.focus_up_safe, "focus up (vim/tmux)"),
			["<C-o>"] = spec.map(boost.navigator.focus_right_safe, "focus right (vim/tmux)"),
		},
	},
	plugin_textobject = {
		n = {
			s = spec.map(boost.textobjects.goto_next, "skip textobject forward"),
			S = spec.map(boost.textobjects.goto_prev, "skip textobject reverse")
		},
		x = {
			s = spec.map(boost.textobjects.goto_next, "skip textobject forward"),
			S = spec.map(boost.textobjects.goto_prev, "skip textobject reverse")
		},
		o = {
			s = spec.map(boost.textobjects.goto_next, "skip textobject forward"),
			S = spec.map(boost.textobjects.goto_prev, "skip textobject reverse")
		},
	},
	plugin_luasnip = {
		i = {
			["<C-Right>"] = spec.map(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-Left>"] = spec.map(boost.luasnip.jump_reverse, "luasnip jump prev"),
			["<C-l>"] = spec.map(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-k>"] = spec.map(boost.luasnip.jump_reverse, "luasnip jump prev"),
		},
		s = {
			["<C-Right>"] = spec.map(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-Left>"] = spec.map(boost.luasnip.jump_reverse, "luasnip jump prev"),
			["<C-l>"] = spec.map(boost.luasnip.jump_forward, "luasnip jump next"),
			["<C-k>"] = spec.map(boost.luasnip.jump_reverse, "luasnip jump prev"),
		},
	},
	plugin_telescope_lsp_leader = {
		m = {
			-- telescope lsp
			["<leader>lc"] = spec.map(boost.telescope.lsp_incoming_calls, "[L]sp Incoming [C]alls"),
			["<leader>lC"] = spec.map(boost.telescope.lsp_outgoing_calls, "[L]sp Outgoing [C]alls"),
			["<leader>li"] = spec.map(boost.telescope.lsp_implementations, "[L]sp Goto [I]mplementation"),
			["<leader>lr"] = spec.map(boost.telescope.lsp_references, "[L]sp [R]eferences"),
			["<leader>ls"] = spec.map(boost.telescope.lsp_document_symbols, "[L]sp Document [S]ymbols"),
			["<leader>lS"] = spec.map(boost.telescope.lsp_workspace_symbols, "[L]sp Workspace [S]ymbols"),
			["<leader>l$"] = spec.map(boost.telescope.lsp_dynamic_workspace_symbols, "[L]sp Dynamic Workspace [S]ymbols"),
			["<leader>lt"] = spec.map(boost.telescope.lsp_type_definitions, "[L]sp [T]ypes"),
		}
	},
	plugin_telescope_easy_jump = {
		m = {
			j = spec.map(boost.telescope.find_files, "jump files"),
			J = spec.map(boost.telescope.live_grep, "jump files"),
		}
	},
	plugin_telescope_leader = {
		m = {
			["<leader>/"] = spec.map(boost.telescope.buffer_fuzzy_search, "buffer fuzzy find"),
			["<leader>tb"] = spec.map(boost.telescope.buffers, "[T]elescope [B]uffers"),
			["<leader>to"] = spec.map(boost.telescope.oldfiles, "[T]elescope [O]ldfiles"),
			["<leader>tq"] = spec.map(boost.telescope.quickfix, "[T]elescope [Q]uickfix"),
			["<leader>tl"] = spec.map(boost.telescope.loclist, "[T]elescope [L]oclist"),
			["<leader>tj"] = spec.map(boost.telescope.jump_list_safe, "[T]elescope [J]umplist"),
			["<leader>tm"] = spec.map(boost.telescope.man_pages, "[T]elescope [M]an pages"),
			["<leader>th"] = spec.map(boost.telescope.help_tags, "[T]elescope [H]elp Tags"),
			["<leader>tt"] = spec.map(boost.telescope.man_pages, "[T]elescope [T]ags"),
			["<leader>tc"] = spec.map(boost.telescope.commands, "[T]elescope [C]ommands"),
			["<leader>tk"] = spec.map(boost.telescope.keymaps, "[T]elescope [K]eymaps"),
			["<leader>tp"] = spec.map(boost.telescope.registers, "[T]elescope [P]aste"),
			["<leader>tr"] = spec.map(boost.telescope.resume, "[T]elescope [R]epeat"),
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
