local emoticon_list = require("unruly-worker.data.emoticon-list")

local function notify_error(error)
	vim.notify("UNRULY ERROR: " .. error, vim.log.levels.ERROR)
end

local function notify_warn(warn)
	vim.notify("UNRULY ERROR: " .. warn, vim.log.levels.WARN)
end

local function notify_info(info)
	vim.notify(info, vim.log.levels.INFO)
end

local function emoticon()
	return emoticon_list[math.random(1, #emoticon_list)]
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
	emoticon = emoticon,
	notify_error = notify_error,
	notify_warn = notify_warn,
	notify_info = notify_info,
	key_equal = key_equal,
	should_map = should_map,
}
