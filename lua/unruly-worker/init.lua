--                       __                         __
--   __ _____  ______ __/ /_ _______    _____  ____/ /_____ ____
--  / // / _ \/ __/ // / / // /___/ |/|/ / _ \/ __/  '_/ -_) __/
--  \_,_/_//_/_/  \_,_/_/\_, /    |__,__/\___/_/ /_/\_\\__/_/
--                      /___/
--
--  Name: unruly-worker
--  License: Unlicense
--  Maintainer: Duncan Marsh (slugbyte@slugbyte.com)
--  Repository: https://github.com/slugbyte/unruly-worker
--
--  TODO: add cmp.insert and cmd presets
--  TODO: add lsp leader commands
--  TODO: add treesitter search commands
--

--- create a key mapper that does nothing when trying
--- to map something to itself
--- @param mode string
--- @param noremap boolean
local create_map = function(mode, noremap)
	-- @param lhs string
	-- @param rhs string
	-- @param desc sring
	return function(lhs, rhs, desc)
		if lhs == rhs then
			vim.keymap.set(mode, lhs, "\\")
			vim.keymap.set(mode, lhs, rhs, { noremap = noremap, desc = desc })
			return
		end
		vim.keymap.set(mode, lhs, rhs, { noremap = noremap, desc = desc })
	end
end

-- noremap
local map = create_map("", true)
local nmap = create_map("n", true)
local imap = create_map("i", true)
local cmap = create_map("c", true)
local vmap = create_map("v", true)

-- remap
local remap_vmap = create_map("v", false)
local remap_map = create_map("", false)

-- actions
local emoticon_list = require("unruly-worker.emoticon-list")
local function write_all()
	vim.cmd("silent! wall")
	print(emoticon_list[math.random(0, #emoticon_list)])
end

local function debug_char()
	local ch_num = vim.fn.getchar()

	print("nums:", ch_num, ch_num == 80, ch_num == 8, ch_num == "<BS>")
	print("num:", ch_num, ch_num == 80, ch_num == 8, string.format("%s", ch_num) == "<80>kb")
	-- local ch = string.char(ch_num)
	-- print("char:", ch)
end

local function register_peek()
	print("REGISTER_PEEK tap to peek")
	local ch_num = vim.fn.getchar()
	local ch = string.char(ch_num)
	if ch_num == 27 then
		print("REGISTER_PEEK abort")
		return
	end

	local reg_content = vim.fn.getreg(ch)
	reg_content = reg_content:gsub("\n", "\\n")
	reg_content = reg_content:gsub("\t", "\\t")
	reg_content = reg_content:gsub("\t", "\\t")
	reg_content = reg_content:gsub(string.char(27), "<esc>")
	reg_content = reg_content:gsub(string.char(8), "<bs>")
	reg_content = reg_content:gsub(string.char(9), "<tab>")
	reg_content = reg_content:gsub(string.char(13), "<enter>")

	if #reg_content > 0 then
		print(string.format("REGISTER_PEEK %s (%s)", ch, reg_content))
	else
		print(string.format("REGISTER_PEEK %s (empty)", ch))
	end
end

local map_undisputed = function()
	map("a", "a", "append")
	map("A", "A", "append line")
	map("b", "%", "brace match")
	map("B", '"', "select register")
	map("c", "c", "delete and insert")
	map("C", "C", "delete and insert to endofline")
	map("d", "d", "delete")
	map("D", "D", "delte to endofline")
	map("e", "k", "up")
	map("E", "e", "end of word")
	map("<C-w>e", "<C-w>k", "focus up")
	map("f", "n", "next search")
	map("F", "N", "reverse search")
	map("g", "g", "g")
	map("G", "G", "goto line")
	map("h", ";", "hop to char search")
	map("H", ",", "hop to char search reverse")
	map("i", "i", "insert")
	map("I", "I", "insert begining of line")
	map("j", "'", "jump to mark")
	map("J", "\\", "")
	map("k", "y", "kopy")
	map("K", "Y", "kopy line")
	map("l", "o", "line create below")
	map("L", "O", "line create above")
	map("m", "m", "create mark")
	map("M", "q", "macro record")
	map("n", "j", "down")
	map("N", "J", "join lines")
	map("<C-w>n", "<C-w>j", "focus down")
	map("o", "l", "right")
	map("O", "$", "end of line")
	map("<C-w>o", "<C-w>l", "focus right")
	map("p", "p", "paste after")
	map("P", "P", "paste before")
	map("q", write_all, "save all")
	map("Q", ":qall<cr>", "quit")
	map("<c-q>", ":qall!<cr>", "quit no write")
	-- map("q", '"', "register select")
	-- map("Q", "q", "macro record")
	-- map("<c-q>", "@", "macro execute")
	map("r", "r", "replace")
	map("R", "R", "replace mode")
	map("s", "s", "delete char into register")
	map("S", "S", "delete line int register")
	map("t", "f", "to char")
	map("T", "F", "to char reverse")
	map("u", "u", "undo")
	map("U", "<c-r>", "redo")
	map("v", "v", "visual mode")
	map("V", "V", "visual line mode")
	map("w", "w", "word forward")
	map("W", "b", "word backbard")
	map("x", "x", "delete under curser")
	map("X", "X", "delete before curser")
	map("y", "h", "left")
	map("Y", "^", "begining of line")
	map("<C-w>y", "<C-w>h", "focus left")
	map("z", '"', "register select")
	map("Z", "q", "macro record")
	map("<c-z>", "@", "macro play")
	map(":", ":", "command mode")
	map("'", "\\", "register peek")
	map("`", register_peek, "register peek")
	map('"', '"', "register select")
	map(",", "&", "repeat last substitue")
	map(".", ".", "repeat last change")
	map("/", "/", "search buffer")
	map("?", "?", "search buffer reverse")
	map("@", "zt", "align top of screen")
	map("#", "zz", "align middle of screen")
	map("$", "zb", "align bottom of screen")
	map("~", "~", "swap case")
	map("%", "\\", "")
	map("^", "\\", "")
	map("&", "\\", "")
	map("*", "\\", "")
	map("-", "\\", "")
	map("_", "\\", "")
	map("+", "\\", "")
	map("=", "\\", "")
	map("|", "\\", "")
	map(";", "\\", "")
	map(")", ")", "next sentence")
	map("(", "(", "prev sentence")
	map("]", "]", "jump forward")
	map("[", "[", "jump backward")
	map(">", ">", "nudge forward")
	map("<", "<", "nudge backward")
	nmap("<C-Down>", ":m .+1<CR>==", "swap down")
	nmap("<C-Up>", ":m .-2<CR>==", "swap up")
	imap("<C-Down>", ":m .+1<CR>==gi", "swap down")
	imap("<C-Up>", ":m .-2<CR>==gi", "swap up")
	vmap("<C-Down>", ":m '>+1<CR>gv=gv", "swap down")
	vmap("<C-Up>", ":m '<-2<CR>gv=gv", "swap up")
	cmap("<C-a>", "<home>", "begining of line")
	cmap("<C-e>", "<end>", "end of line")
	map("ge", "gk", "go up column")
	map("gn", "gj", "go down column")
end

--- add lsp specific mappings if enable is true
--- @param enable boolean
local map_lsp = function(enable)
	if enable then
		map("-", ":lua vim.diagnostic.goto_prev()<CR>", "prev diagnostic")
		map("_", ":lua vim.diagnostic.goto_next()<CR>", "next diagnostic")
		map(";", ":lua vim.lsp.buf.hover()<CR>", "lsp hover")
		map("<c-r>", ":lua vim.lsp.buf.rename()<CR>", "lsp rename")
		map("<c-d>", ":split<CR>:lua vim.lsp.buf.definition()<CR>", "lsp definition")
	end
end

--- c will toggle comment if enable is true
--- @param enable boolean
local map_comment = function(enable)
	if enable then
		vim.keymap.set("", "c", "gcc", { desc = "comment toggle line" })
		vim.keymap.set("", "C", "gcip", { desc = "comment toggle paragraph" })
		vim.keymap.set("v", "c", "gc", { desc = "comment toggle visual" })
		vim.keymap.set("v", "C", "gc", { desc = "comment toggle visual" })
	end
end

--- s will visual select if enable is true
--- @param enable boolean
local map_select = function(enable)
	if enable then
		map("s", "viw", "select word")
		map("S", "vip", "select paragraph")
	end
end

--- e and n will navigate visualy if enable is true
--- @param enable boolean
local map_visual_navigate = function(enable)
	if enable then
		map("e", "gk", "up column")
		map("n", "gj", "down column")
	end
end

--- y and o will wrap lines if enable is true
--- @param enable boolean
local map_wrap_navigate = function(enable)
	if enable then
		vim.cmd("set ww+=<,>")
		map("y", "<left>", "y wrap left")
		map("o", "<right>", "o wrap right")
	end
end

--- ' is equivalent to : if enable is true
--- @param enable boolean
local map_quote_command = function(enable)
	if enable then
		map("'", ":", "command mode")
	end
end

--- <C-(y,n,e,o)> nave windows if enable is true
--- @param enable boolean
local map_easy_window_navigate = function(enable)
	if enable then
		map("<c-n>", "<c-w>j", "focus down")
		map("<c-e>", "<c-w>k", "focus up")
		map("<c-y>", "<c-w>h", "focus left")
		map("<c-o>", "<c-w>l", "focus right")
	end
end

local map_double_jump = function(enable)
	if enable then
		map("m", "ma", "mark a")
		map("M", "mb", "mark b")
		map("j", "'a", "jump a")
		map("J", "'b", "jump b")
	end
end

local map_eazy_macro = function(enable)
	if enable then
		map("z", "qz", "record macro")
		map("Z", "@z", "play macro")
		vim.keymap.del("n", "<c-z>")
	end
end

local load_unruly = function(config)
	local context = {
		enable_lsp_map = true,
		enable_select_map = true,
		enable_quote_command = true,
		enable_easy_window_navigate = true,
		enable_comment_map = true,
		enable_wrap_navigate = true,
		enable_visual_navigate = true,
		enable_double_jump = true,
		enable_easy_macro = true,
	}

	if config then
		context = vim.tbl_extend("force", context, config)
	end

	map_undisputed()
	map_lsp(context.enable_lsp_map)
	map_select(context.enable_select_map)
	map_comment(context.enable_comment_map)
	map_wrap_navigate(context.enable_wrap_navigate)
	map_quote_command(context.enable_quote_command)
	map_visual_navigate(context.enable_visual_navigate)
	map_easy_window_navigate(context.enable_easy_window_navigate)
	map_double_jump(context.enable_double_jump)
	map_eazy_macro(context.enable_easy_macro)
end

---  configure and map unruly worker keymap
--- @param config table
local function setup(config)
	-- dont reload if  loaded
	if vim.g.unruly_worker then
		return
	end
	vim.g.unruly_worker = true

	load_unruly(config)
end

return {
	setup = setup,
	util = {
		write_all = write_all,
		register_peek = register_peek,
		debug_char = debug_char,
		load = load_unruly,
	},
}
