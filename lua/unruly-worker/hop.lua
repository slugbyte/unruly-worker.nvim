-- state
local S = {}

-- module
local M = {}

M.mode_option = {
	mark = "MARK",
	textobject = "TEXT OBJECT",
	quick_fix = "QUICK FIX",
}

S.hop_mode = M.mode_option.mark

-- hop marks
function M.HopModeSetMark()
	S.hop_mode = M.mode_option.mark
end

-- hop text objects
function M.HopModeSetTextObject()
	S.hop_mode = M.mode_option.textobject
end

-- hop quick fix list
function M.HopModeSetQuickFix()
	S.hop_mode = M.mode_option.quick_fix
end

function M.HopModeGet()
	return S.hop_mode
end

return M
