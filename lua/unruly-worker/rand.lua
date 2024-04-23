local emoticon_list = require("unruly-worker.data.emoticon-list")
local greeting_list = require("unruly-worker.data.greeting-list")

local M = {}

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

return M
