-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[
  augroup _Highlights
    autocmd!
    au ColorScheme * highlight CursorLine guibg=#ececec
    au ColorScheme * highlight CursorColumn guibg=#ececec
    " au ColorScheme * highlight CursorColumn guibg=#c4c8da
    au ColorScheme * highlight SignColumn guibg=#ececec
    au ColorScheme * highlight Pmenu guibg=#ececec
    au ColorScheme * highlight WhiteSpace guifg=#c4c8da
  augroup END

  augroup _CLIAnalyzer
    au!
    au BufRead session-capture.*.txt setlocal ft=log
    au BufRead *.log setlocal ft=log
  augroup END

  augroup _logs
    au!
    au filetype log let g:indent_blankline_enabled = v:false
  augroup end
]])

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "json" },
	callback = function()
		vim.b.autoformat = false
	end,
})
