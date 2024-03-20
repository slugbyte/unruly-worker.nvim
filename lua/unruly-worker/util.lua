local textobject_staus, textobject = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
local telescope_status, telescope_builtin = pcall(require, "telescope.builtin")

local emoticon_list = require("unruly-worker.data.emoticon-list")

local function textobject_seek_forward()
	if textobject_staus and (textobject ~= nil) then
		textobject.repeat_last_move_next()
	end
end

local function textobject_seek_reverse()
	if textobject_staus and (textobject ~= nil) then
		textobject.repeat_last_move_previous()
	end
end

local function lsp_definiton()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.lsp_definitions()
	else
		vim.lsp.buf.definition()
	end
end

local function telescope_find_files()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.find_files()
		return
	end
	print("UNRULY ERROR: telescope not found")
end

local function telescope_live_grep()
	if telescope_status and (telescope_builtin ~= nil) then
		telescope_builtin.live_grep()
		return
	end
	print("UNRULY ERROR: telescope not found")
end

local function write_all()
	vim.cmd("wall")
	print(emoticon_list[math.random(0, #emoticon_list)])
end

local function register_peek()
	print("REGISTER_PEEK tap to peek")
	local ch_num = vim.fn.getchar()
	local ch = string.char(ch_num)
	if ch_num == 27 then
		print("REGISTER_PEEK abort")
		return
	end

	if ch_num < 21 or ch_num > 126 then
		print("REGISTER_PEEK invalid key")
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
		vim.print(string.format("REGISTER_PEEK %s (%s)", ch, reg_content))
	else
		vim.print(string.format("REGISTER_PEEK %s (empty)", ch))
	end
end

local key_equal = function(a, b)
	local len_a = #a
	local len_b = #b
	if len_a ~= len_b then
		return false
	end

	if len_a == 1 then
		return a == b
	end

	if (string.find(a, "leader") ~= nil) then
		return a == b
	end

	return string.lower(a) == string.lower(b)
end

local should_map = function(key, skip_list)
	local skip = false
	for _, skip_key in ipairs(skip_list) do
		skip = skip or key_equal(key, skip_key)
	end

	return not skip
end

return {
	register_peek = register_peek,
	write_all = write_all,
	key_equal = key_equal,
	should_map = should_map,
	textobject_seek_forward = textobject_seek_forward,
	textobject_seek_reverse = textobject_seek_reverse,
	telescope_find_files = telescope_find_files,
	telescope_live_grep = telescope_live_grep,
	lsp_definiton = lsp_definiton,
}
