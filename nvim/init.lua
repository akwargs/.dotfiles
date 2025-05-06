-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.g.loaded_perl_provider = 0
vim.g.node_host_prog = vim.env.NVIM_NODE_HOST
vim.g.python3_host_prog = vim.env.NVIM_PYTHON3_HOST
vim.opt.mouse = "n"
