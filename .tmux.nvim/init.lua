-- git clone https://github.com/spywhere/tmux.nvim .tmux.nvim
vim.opt.rtp:append({'~/.tmux.nvim', '~/vimfiles', '~/.vim'})
local tmux = require('tmux')
vim.cmd [[source ~/vimfiles/vimrc]]
tmux.start()
