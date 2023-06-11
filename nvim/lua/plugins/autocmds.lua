vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.cmd([[
  augroup catp_cul_highlight
  autocmd!
  au ColorScheme * highlight CursorColumn guibg=#2a2b3c
  augroup END
]])

return {}
