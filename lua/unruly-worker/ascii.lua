local M = {}

function M.is_int__num(ch_int)
	return ch_int > 47 and ch_int < 58
end

function M.is_int_uppercase(ch_int)
	return ch_int > 64 and ch_int < 91
end

function M.is_int_lowercase(ch_int)
	return ch_int > 96 and ch_int < 123
end

function M.is_int_alpha(ch_int)
	return M.is_int_lowercase(ch_int) or M.is_int_uppercase(ch_int)
end

return M
