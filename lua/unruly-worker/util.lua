local emoticon_list = require("unruly-worker.data.emoticon-list")
local greeting_list = require("unruly-worker.data.greeting-list")

local M = {}

function M.error(...)
	vim.notify(string.format(...), vim.log.levels.ERROR)
end

function M.info(...)
	vim.notify(string.format(...), vim.log.levels.INFO)
end

function M.emoticon()
	return emoticon_list[math.random(1, #emoticon_list)]
end

function M.greeting()
	local rand = math.random()
	if (rand < 0.65) then
		return greeting_list.hello[math.random(1, #greeting_list.hello)]
	end
	if (rand < 0.95) then
		return greeting_list.hacker[math.random(1, #greeting_list.hacker)]
	end
	return greeting_list.strange[math.random(1, #greeting_list.strange)]
end

function M.key_equal(a, b)
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

function M.should_map(key, skip_list)
	local skip = false
	for _, skip_key in ipairs(skip_list) do
		skip = skip or M.key_equal(key, skip_key)
	end

	return not skip
end

function M.is_int_ascii_num(ch_int)
	return ch_int > 47 and ch_int < 58
end

function M.is_int_ascii_uppercase(ch_int)
	return ch_int > 64 and ch_int < 91
end

function M.is_int_ascii_lowercase(ch_int)
	return ch_int > 96 and ch_int < 123
end

function M.is_int_ascii_alpha(ch_int)
	return M.is_int_ascii_lowercase(ch_int) or M.is_int_ascii_uppercase(ch_int)
end

return M
