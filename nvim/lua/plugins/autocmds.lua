vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.cmd([[
  augroup catp_cul_highlight
  autocmd!
  au ColorScheme * highlight CursorColumn guibg=#c4c8da
  augroup END
]])

return {}
