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
    au ColorScheme * set background=light
  augroup end

  augroup _CLIAnalyzer
    au!
    au BufRead session-capture.*.txt setlocal ft=log
    au BufRead *.log setlocal ft=log
  augroup end

  augroup _logs
    au!
    au filetype log let g:indent_blankline_enabled = v:false
  augroup end

  if !&diff
    augroup _rnu_toggle
      autocmd!
      autocmd InsertEnter * if &signcolumn == "yes" | set nornu | endif
      autocmd InsertLeave * if &signcolumn == "yes" | set rnu | endif
    augroup end
  endif

  augroup _logs
    au!
    au filetype help setlocal cul! cuc!
  augroup end
]])

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "json" },
	callback = function()
		vim.b.autoformat = false
	end,
})
