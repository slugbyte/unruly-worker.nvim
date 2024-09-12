local M = {}

M.select_keymaps = {
	["oa"] = { query = "@assignment.outer", desc = "select outer assigment" },
	["oc"] = { query = "@call.outer", desc = "selct outer call" },
	["of"] = { query = "@function.outer", desc = "select outer function" },
	["ol"] = { query = "@loop.outer", desc = "select outer loop" },
	["op"] = { query = "@parameter.outer", desc = "select outer parameter" },
	["os"] = { query = "@class.outer", desc = "select outer struct" },
	["oi"] = { query = "@conditional.outer", desc = "select outer conditional" },
	["od"] = { query = "@comment.outer", desc = "select outer comment (doc)" },
	["or"] = { query = "@return.outer", desc = "select outer return" },
	["ob"] = { query = "@block.outer", desc = "select outer block" },

	["ia"] = { query = "@assignment.inner", desc = "select inner assigment" },
	["ic"] = { query = "@call.inner", desc = "selct inner call" },
	["if"] = { query = "@function.inner", desc = "select inner function" },
	["il"] = { query = "@loop.inner", desc = "select inner loop" },
	["ip"] = { query = "@parameter.inner", desc = "select inner parameter" },
	["is"] = { query = "@class.inner", desc = "select inner struct" },
	["ii"] = { query = "@conditional.inner", desc = "select inner conditional" },
	["id"] = { query = "@comment.inner", desc = "select inner comment (doc)" },
	["ir"] = { query = "@return.inner", desc = "select inner return" },
	["ib"] = { query = "@block.inner", desc = "select inner block" },
}

M.move_goto_next_start = {
	["goa"] = { query = "@assignment.outer", desc = "next outer assignment" },
	["goc"] = { query = "@call.outer", desc = "next outer call" },
	["gof"] = { query = "@function.outer", desc = "next outer function" },
	["gol"] = { query = "@loop.outer", desc = "next outer loop" },
	["gop"] = { query = "@parameter.outer", desc = "next outer parameter" },
	["gos"] = { query = "@class.outer", desc = "next outer struct" },
	["goi"] = { query = "@conditional.outer", desc = "next outer conditional" },
	["gor"] = { query = "@return.outer", desc = "next outer return" },
	["god"] = { query = "@comment.outer", desc = "next outer comment" },
	["gob"] = { query = "@block.outer", desc = "next outer block" },

	["gia"] = { query = "@assignment.inner", desc = "next inner assignment" },
	["gic"] = { query = "@call.inner", desc = "next inner call" },
	["gif"] = { query = "@function.inner", desc = "next inner function" },
	["gil"] = { query = "@loop.inner", desc = "next inner loop" },
	["gip"] = { query = "@parameter.inner", desc = "next inner parameter" },
	["gis"] = { query = "@class.inner", desc = "next inner struct" },
	["gii"] = { query = "@conditional.inner", desc = "next inner conditional" },
	["gir"] = { query = "@return.inner", desc = "next inner return" },
	["gid"] = { query = "@comment.inner", desc = "next inner comment" },
	["gib"] = { query = "@block.inner", desc = "next inner block" },
}

M.move_goto_previous_start = {
	["Goa"] = { query = "@assignment.outer", desc = "prev outer assignment" },
	["Goc"] = { query = "@call.outer", desc = "prev outer call" },
	["Gof"] = { query = "@function.outer", desc = "prev outer function" },
	["Gol"] = { query = "@loop.outer", desc = "prev outer loop" },
	["Gop"] = { query = "@parameter.outer", desc = "prev outer parameter" },
	["Gos"] = { query = "@class.outer", desc = "prev outer struct" },
	["Goi"] = { query = "@conditional.outer", desc = "prev outer conditional" },
	["Gor"] = { query = "@return.outer", desc = "prev outer return" },
	["God"] = { query = "@comment.outer", desc = "prev outer comment" },
	["Gob"] = { query = "@block.outer", desc = "prev outer block" },

	["Gia"] = { query = "@assignment.inner", desc = "prev inner assignment" },
	["Gic"] = { query = "@call.inner", desc = "prev inner call" },
	["Gif"] = { query = "@function.inner", desc = "prev inner function" },
	["Gil"] = { query = "@loop.inner", desc = "prev inner loop" },
	["Gip"] = { query = "@parameter.inner", desc = "prev inner parameter" },
	["Gis"] = { query = "@class.inner", desc = "prev inner struct" },
	["Gii"] = { query = "@conditional.inner", desc = "prev inner conditional" },
	["Gir"] = { query = "@return.inner", desc = "prev inner return" },
	["Gid"] = { query = "@comment.inner", desc = "prev inner comment" },
	["Gib"] = { query = "@block.inner", desc = "prev inner block" },
}

M.move_goto_next_end = {
	["gea"] = { query = "@assignment.outer", desc = "next end assignment" },
	["gec"] = { query = "@call.outer", desc = "next end call" },
	["gef"] = { query = "@function.outer", desc = "next end function" },
	["gel"] = { query = "@loop.outer", desc = "next end loop" },
	["gep"] = { query = "@parameter.outer", desc = "next end parameter" },
	["ges"] = { query = "@class.outer", desc = "next end struct" },
	["gei"] = { query = "@conditional.outer", desc = "next end conditional" },
	["ger"] = { query = "@return.outer", desc = "next end return" },
	["ged"] = { query = "@comment.outer", desc = "next end comment" },
	["geb"] = { query = "@block.outer", desc = "next end block" },
}

M.move_goto_previous_end = {
	["Gea"] = { query = "@assignment.outer", desc = "prev end assignment" },
	["Gec"] = { query = "@call.outer", desc = "prev end call" },
	["Gef"] = { query = "@function.outer", desc = "prev end function" },
	["Gel"] = { query = "@loop.outer", desc = "prev end loop" },
	["Gep"] = { query = "@parameter.outer", desc = "prev end parameter" },
	["Ges"] = { query = "@class.outer", desc = "prev end struct" },
	["Gei"] = { query = "@conditional.outer", desc = "prev end conditional" },
	["Ger"] = { query = "@return.outer", desc = "prev end return" },
	["Ged"] = { query = "@comment.outer", desc = "prev end comment" },
	["Geb"] = { query = "@block.outer", desc = "prev end block" },
}

return M
