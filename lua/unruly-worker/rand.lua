local emoticon_list = require("unruly-worker.data.emoticon-list")
local yabber = require("unruly-worker.data.yabber")

local M = {}

function M.emoticon()
	return emoticon_list[math.random(1, #emoticon_list)]
end

function M.greeting()
	local rand = math.random()
	if (rand < 0.65) then
		return yabber.hello[math.random(1, #yabber.hello)]
	end
	if (rand < 0.95) then
		return yabber.hacker[math.random(1, #yabber.hacker)]
	end
	return yabber.strange[math.random(1, #yabber.strange)]
end

function M.feedback()
	local rand = math.random()
	if rand < 0.98 then
		return ""
	end
	return " " .. yabber.feedback[math.random(1, #yabber.feedback)]
end

return M
