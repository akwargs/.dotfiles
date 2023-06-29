-- TODO: test
-- NOTE: this is a test
-- FIXME: blah
-- BUG: blah
-- WARN: blah
-- HACK: blah
-- PERF: blah
-- TEST: test
return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "BufRead",
	config = function()
		require("todo-comments").setup()
	end,
}
