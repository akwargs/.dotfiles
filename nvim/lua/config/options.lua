-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.backup = true
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.diffopt:append({ "vertical" })
vim.opt.fileformats = "unix,dos"
vim.opt.listchars = "tab:»·,trail:·,nbsp:·"
vim.opt.mouse = ""
-- vim.opt.statuscolumn = "%s %C %l %=%{v:relnum?v:relnum:v:lnum}   "
vim.opt.ttimeout = false
vim.opt.undodir = "."

if vim.g.neovide then
	vim.opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h10"
end
