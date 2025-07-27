-- bootstrap lazy.nvim, LazyVim and your plugins
-- git clone https://github.com/LazyVim/starter ~/AppData/Local/nvim
require("config.lazy")
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.node_host_prog = vim.env.NVIM_NODE_HOST
vim.g.python3_host_prog = vim.env.NVIM_PYTHON3_HOST
vim.opt.background = "light"
vim.opt.cursorline = false
vim.opt.mouse = "n"
