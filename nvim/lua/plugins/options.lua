vim.opt.backup = true
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
vim.opt.fileformats = "unix,dos"
vim.opt.undodir = "."
vim.opt.mouse = ""
vim.opt.statuscolumn = "%s %C %l %=%{v:relnum?v:relnum:v:lnum}   "

if vim.g.neovide then
  vim.opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h10"
end
return {}
