local luasnip_status, luasnip = pcall(require, "luasnip")
local M = {}

--- goto next luasnip stoping point
function M.jump_forward()
	if luasnip_status and (luasnip ~= nil) then
		if luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		end
	end
end

--- goto prev luasnip stoping point
function M.jump_reverse()
	if luasnip.locally_jumpable(-1) then
		luasnip.jump(-1)
	end
end

return M
