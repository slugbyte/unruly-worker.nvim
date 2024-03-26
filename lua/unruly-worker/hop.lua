local util = require("unruly-worker.util")

-- module
local M = {}

-- state
local S = {}


M.mode_option = {
	mark = "MARK",
	text_object = "TEXT OBJECT",
	quick_fix = "QUICK FIX",
	buffer = "BUFFER"
}
S.hop_mode = M.mode_option.mark

local function NewHopModeSet(mode_option)
	return function()
		S.hop_mode = mode_option
	end
end


-- hop quick fix list
M.HopModeSetMark = NewHopModeSet(M.mode_option.mark)
M.HopModeSetTextObject = NewHopModeSet(M.mode_option.text_object)
M.HopModeSetQuickFix = NewHopModeSet(M.mode_option.quick_fix)
M.HopModeSetBuffer = NewHopModeSet(M.mode_option.buffer)


-- hop mode rotate
function M.HopModeRotate()
	if S.hop_mode == M.mode_option.mark then
		M.HopModeSetTextObject()
		return
	end
	if S.hop_mode == M.mode_option.text_object then
		M.HopModeSetQuickFix()
		return
	end
	if S.hop_mode == M.mode_option.quick_fix then
		M.HopModeSetBuffer()
		return
	end
	M.HopModeSetMark()
end

function M.HopModeGet()
	return S.hop_mode
end

function M.HopForward()
	if S.hop_mode == M.mode_option.text_object then
		util.info("hopping text_object forward")
		util.textobject_seek_forward()
		return
	end
	util.error(string.format("no hop forward impl for %s", M.HopModeGet()))
end

function M.HopReverse()
	if S.hop_mode == M.mode_option.text_object then
		util.info("hopping text_object reverse")
		util.textobject_seek_reverse()
		return
	end
	util.error(string.format("no hop reverse impl for %s", M.HopModeGet()))
end

return M
