local M = {}

--NOTE: these magic numbers are just ascii char codes
M.escape = 27
M.enter = 13
M.space = 32
M.zero = 48
M.plus = 43
M.letter_y = 121
M.letter_f = 102

--- check if a number is in ascii number range
---@param ch_int number
function M.is_int__num(ch_int)
	return ch_int > 47 and ch_int < 58
end

--- check if a number is in upercase range
---@param ch_int number
function M.is_int_uppercase(ch_int)
	return ch_int > 64 and ch_int < 91
end

--- check if a number is in lowercase range
---@param ch_int number
function M.is_int_lowercase(ch_int)
	return ch_int > 96 and ch_int < 123
end

--- check if a number is in alpma range
---@param ch_int number
function M.is_int_alpha(ch_int)
	return M.is_int_lowercase(ch_int) or M.is_int_uppercase(ch_int)
end

return M
