vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.cmd([[
  augroup _Highlights
  autocmd!
  " au ColorScheme * highlight CursorColumn guibg=#c4c8da
  au ColorScheme * highlight CursorLine guibg=#ececec
  au ColorScheme * highlight CursorColumn guibg=#ececec
  au ColorScheme * highlight SignColumn guibg=#ececec
  augroup END
]])

return {}
