local boost = require("unruly-worker.boost")
local spec = require("unruly-worker.spec")

---NOTE: booster order is the precidence order of the keymaps being applied!
---@type UnrulySpecKeymap
return {
	{
		name = "default",
		keymap = {
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
				ge = spec.map("gk", "visual up"),
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
				gn = spec.map("gj", "visual down"),
				N = spec.map("J", "join lines"),
				o = spec.map("l", "right"),
				O = spec.map("$", "right to EOL"),
				p = spec.map("p", "paste after"),
				P = spec.map("P", "paste before"),
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
	},
	{
		name = "easy_window",
		keymap = {
			m = {
				["<C-x>"] = spec.map(":close<CR>", "close pane"),
				["<C-f>"] = spec.map(":on<CR>", "full screen"),
				["<C-h>"] = spec.map(":sp<CR>", "split horizontal"),
				["<C-s>"] = spec.map(":vs<CR>", "split verticle"),
			},
		},
	},
	{
		name = "easy_focus",
		keymap = {
			m = {
				["<C-y>"] = spec.map("<C-w>h", "focus left"),
				["<C-n>"] = spec.map("<C-w>j", "focus down"),
				["<C-e>"] = spec.map("<C-w>k", "focus up"),
				["<C-o>"] = spec.map("<C-w>l", "focus right"),
			},
		},
	},
	{
		name = "easy_source",
		keymap = {
			n = {
				["%"] = spec.map(boost.source.source_file, "source current buffer"),
			},
		},
	},
	{
		name = "easy_scroll",
		keymap = {
			m = {
				["<End>"] = spec.map("9<C-E>", "scroll down fast"),
				["<PageDown>"] = spec.map("3<C-E>", "scroll down"),
				["<PageUp>"] = spec.map("3<C-Y>", "scroll up"),
				["<Home>"] = spec.map("9<C-Y>", "scroll down fast"),
			},
		},
	},
	{
		name = "easy_spellcheck",
		keymap = {
			m = {
				["<leader><leader>c"] = spec.map(boost.telescope.spell_suggest_safe, "[C]heck Spelling"),
			},
		},
	},
	{
		name = "easy_line",
		keymap = {
			m = {
				["<leader><leader>l"] = spec.map("o<esc>^d$<Up>", "[L]ine Below"),
				["<leader><leader>L"] = spec.map("O<esc>^d$<Down>", "[L]ine Above"),
			},
		},
	},
	{
		name = "easy_search",
		keymap = {
			m = {
				["<leader><leader>/"] = spec.map("g*", "[F]ind Word Under Cursor"),
				["<leader><leader>?"] = spec.map("g#", "[F]ind Word Under Cursor Reverse"),
			},
		},
	},
	{
		name = "easy_swap",
		keymap = {
			n = {
				["<C-Down>"] = spec.map(":m .+1<CR>==", "swap down"),
				["<C-Up>"] = spec.map(":m .-2<CR>==", "swap up"),
			},
			v = {
				["<C-Down>"] = spec.map(":m '>+1<CR>gv=gv", "swap down"),
				["<C-Up>"] = spec.map(":m '<-2<CR>gv=gv", "swap up"),
			},
		},
	},
	{
		name = "easy_jumplist",
		keymap = {
			m = {
				["<c-j>"] = spec.map(boost.telescope.jump_list_safe, "jumplist"),
			},
		},
	},
	{
		name = "easy_incrament",
		keymap = {
			v = {
				["<leader><leader>i"] = spec.map("g<C-a>", "[I]ncrament Number Column"),
			},
		},
	},
	{
		name = "easy_hlsearch",
		keymap = {
			n = {
				["<esc>"] = spec.map("<cmd>nohlsearch<CR>", "disable hl search"),
			},
		},
	},
	{
		name = "easy_lsp",
		keymap = {
			m = {
				[";"] = spec.map(vim.lsp.buf.hover, "lsp hover"),
				["="] = spec.map(vim.lsp.buf.code_action, "lsp code action"),
				["<C-r>"] = spec.map(vim.lsp.buf.rename, "lsp rename"),
				["<C-d>"] = spec.map(boost.telescope.lsp_definiton_safe, "lsp definition"),
			},
		},
	},
	{
		name = "easy_lsp_leader",
		keymap = {
			m = {
				["<leader>la"] = spec.map(vim.lsp.buf.code_action, "[L]sp Code [A]ction"),
				["<leader>lh"] = spec.map(vim.lsp.buf.hover, "[L]sp [H]over"),
				["<leader>ld"] = spec.map(boost.telescope.lsp_definiton_safe, "[L]sp goto [D]efinition"),
				["<leader>lD"] = spec.map(vim.lsp.buf.declaration, "[L]sp goto [D]eclaration"),
				["<leader>lf"] = spec.map(vim.lsp.buf.format, "[L]sp [F]ormat"),
				["<leader>lR"] = spec.map(vim.lsp.buf.rename, "[L]sp [R]ename"),
				["<leader>lx"] = spec.map(":LspRestart<CR>", "[L]sp [R]Restart"),
			},
		},
	},
	{
		name = "easy_diagnostic",
		keymap = {
			m = {
				["_"] = spec.map(vim.diagnostic.goto_next, "diagnostic next"),
				["-"] = spec.map(vim.diagnostic.goto_prev, "diagnostic prev"),
			},
		},
	},
	{
		name = "easy_diagnostic_leader",
		keymap = {
			m = {
				["<leader>dn"] = spec.map(vim.diagnostic.goto_next, "diagnostic next"),
				["<leader>dp"] = spec.map(vim.diagnostic.goto_prev, "diagnostic prev"),
			},
		},
	},
	{
		name = "unruly_seek",
		keymap = {
			m = {
				["<leader>sn"] = spec.map(boost.seek.seek_next, "[N]ext Seek"),
				["<leader>sp"] = spec.map(boost.seek.seek_prev, "[P]rev Seek"),
				["<leader>ss"] = spec.map(boost.seek.seek_start, "[S]eek [S]tart"),
				["<leader>se"] = spec.map(boost.seek.seek_end, "[S]eek [E]nd"),
				["<leader>sq"] = spec.map(boost.seek.mode_set_quickfix, "[S]eek mode [Q]uickfix"),
				["<leader>sl"] = spec.map(boost.seek.mode_set_loclist, "[S]eek mode [L]oclist"),
				["<leader>sb"] = spec.map(boost.seek.mode_set_buffer, "[S]eek mode [B]uffer"),
			},
		},
	},
	{
		name = "unruly_mark",
		keymap = {
			m = {
				m = spec.map(boost.mark.toggle_mode, "mark mode toggle"),
				M = spec.map(boost.mark.delete_mode, "mark delete mode"),
				["<c-a>"] = spec.expr(boost.mark.expr_goto_a, "GOTO MARK: a"),
				["<leader>a"] = spec.expr(boost.mark.expr_set_a, "MARK SET: a"),
				["<c-b>"] = spec.expr(boost.mark.expr_goto_b, "GOTO MARK: b"),
				["<leader>b"] = spec.expr(boost.mark.expr_set_b, "MARK SET: b"),
			},
		},
	},
	{
		name = "unruly_macro_z",
		keymap = {
			m = {
				z = spec.map(boost.macro.record, "macro record"),
				Z = spec.map(boost.macro.play, "macro play"),
				["<c-z>"] = spec.map(boost.macro.prompt_macro_reg_select, "select macro register"),
				["<leader>zl"] = spec.map(boost.macro.lock_toggle, "Macro [L]ock Toggle"),
				["<leader>zv"] = spec.map(boost.macro.peek_register, "Macro [V]iew"),
				["<leader>zi"] = spec.map(boost.macro.load_macro, "Macro [I]mport"),
				["<leader>zp"] = spec.expr(boost.macro.expr_paste_macro, "Macro [P]aste"),
			},
		},
	},
	{
		name = "unruly_macro_q",
		keymap = {
			m = {
				q = spec.map(boost.macro.record, "macro record"),
				Q = spec.map(boost.macro.play, "macro play"),
				["<c-q>"] = spec.map(boost.macro.prompt_macro_reg_select, "select macro register"),
				["<leader>ql"] = spec.map(boost.macro.lock_toggle, "Macro [L]ock Toggle"),
				["<leader>qv"] = spec.map(boost.macro.peek_register, "Macro [V]iew"),
				["<leader>qi"] = spec.map(boost.macro.load_macro, "Macro [I]mport"),
				["<leader>qp"] = spec.expr(boost.macro.expr_paste_macro, "Macro [P]aste"),
			},
		},
	},
	{
		name = "unruly_kopy",
		keymap = {
			m = {
				['"'] = spec.map(boost.kopy.prompt_kopy_reg_select, "select kopy_register"),
				-- delete
				c = spec.map(boost.kopy.create_delete_ex_cmd("c"), "change content, store old in reg 0"),
				cc = spec.map(boost.kopy.create_delete_ex_cmd("cc"), "changle lines, store old in reg 0"),
				C = spec.map(boost.kopy.create_delete_ex_cmd("C"), "change to EOL, store old in reg 0"),
				d = spec.map(boost.kopy.create_delete_ex_cmd("d"), "delete motion into reg 0"),
				dd = spec.map(boost.kopy.create_delete_ex_cmd("dd"), "delete motion into reg 0"),
				D = spec.map(boost.kopy.create_delete_ex_cmd("D"), "delete motion into reg 0"),
				s = spec.map(boost.kopy.create_delete_ex_cmd("s"), "subsitute into reg 0"),
				S = spec.map(boost.kopy.create_delete_ex_cmd("S"), "subsitute line into reg 0"),
				x = spec.map(boost.kopy.create_delete_ex_cmd("x"), "delete char into reg 0"),
				X = spec.map(boost.kopy.create_delete_ex_cmd("X"), "delete previous char into reg 0"),
				-- kopy
				k = spec.expr(boost.kopy.expr_kopy, "kopy"),
				K = spec.expr(boost.kopy.expr_kopy_line, "kopy line"),
				-- paste
				-- p = map.basic_expr(action.kopy.expr_paste_below, "paste after")
				-- P = map.basic_expr(action.kopy.expr_paste_above, "paste before"),
				-- paste
				p = spec.expr(boost.kopy.expr_paste_below, "paste after"),
				P = spec.expr(boost.kopy.expr_paste_above, "paste before"),
				["<C-p>"] = spec.expr(boost.kopy.expr_prompt_paste, "paste prompt"),
				[","] = spec.map('"0P', "paste delete_reg above"),
				["."] = spec.map('"0p', "paste delete_reg below"),
			},
			v = {
				["<C-k>"] = spec.expr(boost.kopy.expr_prompt_kopy, "kopy prompt"),
			},
		},
	},
	{
		name = "unruly_quit_q",
		keymap = {
			m = {
				q = spec.map(boost.quit.write_all, "write all", spec.silent_mode.silent),
				Q = spec.map(boost.quit.write_file, "write file", spec.silent_mode.silent),
				["<c-q>"] = spec.expr(boost.quit.expr_prompt_quit_all, "quit prompt", spec.silent_mode.silent),
			},
		},
	},
	{
		name = "unruly_quit_z",
		keymap = {
			m = {
				z = spec.map(boost.quit.write_all, "write all", spec.silent_mode.silent),
				Z = spec.map(boost.quit.write_file, "write file", spec.silent_mode.silent),
				["<c-z>"] = spec.expr(boost.quit.expr_prompt_quit_all, "quit prompt", spec.silent_mode.silent),
			},
		},
	},
	{
		name = "plugin_comment",
		keymap = {
			n = {
				["<C-c>"] = spec.remap("gcc", "comment"),
			},
			v = {
				["<C-c>"] = spec.remap("gc", "comment"),
			},
		},
	},
	{
		name = "plugin_navigator",
		keymap = {
			m = {
				["<C-y>"] = spec.map(boost.navigator.focus_left_safe, "focus left (vim/tmux)"),
				["<C-n>"] = spec.map(boost.navigator.focus_down_safe, "focus down (vim/tmux)"),
				["<C-e>"] = spec.map(boost.navigator.focus_up_safe, "focus up (vim/tmux)"),
				["<C-o>"] = spec.map(boost.navigator.focus_right_safe, "focus right (vim/tmux)"),
			},
		},
	},
	{
		name = "plugin_textobject",
		keymap = {
			n = {
				s = spec.map(boost.textobjects.goto_next, "skip textobject forward"),
				S = spec.map(boost.textobjects.goto_prev, "skip textobject reverse"),
			},
			x = {
				s = spec.map(boost.textobjects.goto_next, "skip textobject forward"),
				S = spec.map(boost.textobjects.goto_prev, "skip textobject reverse"),
			},
			o = {
				s = spec.map(boost.textobjects.goto_next, "skip textobject forward"),
				S = spec.map(boost.textobjects.goto_prev, "skip textobject reverse"),
			},
		},
	},
	{
		name = "plugin_luasnip",
		keymap = {
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
	},
	{
		name = "plugin_telescope_lsp_leader",
		keymap = {
			m = {
				-- telescope lsp
				["<leader>lc"] = spec.map(boost.telescope.lsp_incoming_calls, "[L]sp Incoming [C]alls"),
				["<leader>lC"] = spec.map(boost.telescope.lsp_outgoing_calls, "[L]sp Outgoing [C]alls"),
				["<leader>li"] = spec.map(boost.telescope.lsp_implementations, "[L]sp Goto [I]mplementation"),
				["<leader>lr"] = spec.map(boost.telescope.lsp_references, "[L]sp [R]eferences"),
				["<leader>ls"] = spec.map(boost.telescope.lsp_document_symbols, "[L]sp Document [S]ymbols"),
				["<leader>lS"] = spec.map(boost.telescope.lsp_workspace_symbols, "[L]sp Workspace [S]ymbols"),
				["<leader>l$"] = spec.map(
					boost.telescope.lsp_dynamic_workspace_symbols,
					"[L]sp Dynamic Workspace [S]ymbols"
				),
				["<leader>lt"] = spec.map(boost.telescope.lsp_type_definitions, "[L]sp [T]ypes"),
			},
		},
	},
	{
		name = "plugin_telescope_diagnostic_leader",
		keymap = {
			m = {
				["<leader>d?"] = spec.map(boost.telescope.diagnostics, "[L]sp Diagnostics"),
			},
		},
	},
	{
		name = "plugin_telescope_easy_jump",
		keymap = {
			m = {
				j = spec.map(boost.telescope.find_files, "jump files"),
				J = spec.map(boost.telescope.live_grep, "jump files"),
				["<c-j>"] = spec.map(boost.telescope.jump_list_safe, "jumplist"),
			},
		},
	},
	{
		name = "plugin_telescope_leader",
		keymap = {
			m = {
				["<leader>/"] = spec.map(boost.telescope.buffer_fuzzy_search, "buffer fuzzy find"),
				["<leader>tb"] = spec.map(boost.telescope.buffers, "[T]elescope [B]uffers"),
				["<leader>to"] = spec.map(boost.telescope.oldfiles, "[T]elescope [O]ldfiles"),
				["<leader>tq"] = spec.map(boost.telescope.quickfix, "[T]elescope [Q]uickfix"),
				["<leader>tl"] = spec.map(boost.telescope.loclist, "[T]elescope [L]oclist"),
				["<leader>tj"] = spec.map(boost.telescope.jump_list_safe, "[T]elescope [J]umplist"),
				["<leader>tm"] = spec.map(boost.telescope.man_pages, "[T]elescope [M]an pages"),
				["<leader>th"] = spec.map(boost.telescope.help_tags, "[T]elescope [H]elp Tags"),
				["<leader>tH"] = spec.map(boost.telescope.highlights, "[T]elescope [H]ighlights"),
				["<leader>tt"] = spec.map(boost.telescope.man_pages, "[T]elescope [T]ags"),
				["<leader>tc"] = spec.map(boost.telescope.commands, "[T]elescope [C]ommands"),
				["<leader>tC"] = spec.map(boost.telescope.colorscheme, "[T]elescope [C]olorscheme"),
				["<leader>tk"] = spec.map(boost.telescope.keymaps, "[T]elescope [K]eymaps"),
				["<leader>tp"] = spec.map(boost.telescope.registers, "[T]elescope [P]aste"),
				["<leader>tr"] = spec.map(boost.telescope.resume, "[T]elescope [R]epeat"),
				["<leader>tf"] = spec.map(boost.telescope.find_files, "[T]elescope [F]iles"),
				["<leader>tg"] = spec.map(boost.telescope.live_grep, "[T]elescope [G]rep"),
			},
		},
	},
}
