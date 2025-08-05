local M = {}
local api = vim.api

-- Toggle between relative/absolute line numbers
local numbertoggle = api.nvim_create_augroup("numbertoggle", { clear = true })
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})
api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd.redraw()
    end
  end,
})

-- Terminal options
local terminal = api.nvim_create_augroup("terminal", { clear = true })
api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
  pattern = "*",
  group = terminal,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "text" },
  callback = function()
    vim.opt.spell = false
  end,
})

return M
