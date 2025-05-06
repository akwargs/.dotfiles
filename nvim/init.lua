-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd([[
let g:loaded_perl_provider = 0
if !empty($NVIM_PYTHON3_HOST)
  let g:python3_host_prog = "$NVIM_PYTHON3_HOST"
endif
if !empty($NVIM_NODE_HOME)
  let g:node_host_prog = "$NVIM_NODE_HOST"
endif
]])

local opt = vim.opt
opt.mouse = "n"
