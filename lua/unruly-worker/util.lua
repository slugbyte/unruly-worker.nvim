local emoticon_list = require("unruly-worker.data.emoticon-list")

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

return {
	register_peek = register_peek,
	write_all = write_all,
}
