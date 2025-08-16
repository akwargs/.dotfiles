vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.node_host_prog = vim.env.NVIM_NODE_HOST
vim.g.python3_host_prog = vim.env.NVIM_PYTHON3_HOST
vim.opt.background = "light"
vim.opt.backup = true
if vim.env.TMUX then
	vim.opt.clipboard = "unnamedplus,unnamed"
else
	vim.opt.clipboard = ""
end
vim.opt.copyindent = true
vim.opt.cursorline = false
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = "tab:»·,trail:·,nbsp:·"
vim.opt.mouse = ""
vim.opt.preserveindent = true
vim.opt.undofile = true
vim.opt.undodir = { "." }
