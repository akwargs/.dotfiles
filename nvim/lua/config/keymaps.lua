-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--Remap space as leader key
-- This is set in plugins.lua
-- vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "
vim.api.nvim_set_keymap("n", "<leader>RC", ":set cuc! cul!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-PageUp>", ":bp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":bn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-PageUp>", "<ESC>:bp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-PageDown>", "<ESC>:bn<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>NN", ":IndentBlanklineToggle<CR>", { noremap = true, silent = true })

-- Sensical splits - match tmux
vim.api.nvim_set_keymap("n", "<C-w>%", "<C-w>s", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", '<C-w>"', "<C-w>v", { noremap = true, silent = true })
-- Dissuade use of <C-w>c
-- vim.api.nvim_set_keymap("n", "<C-w>c", "<C-l>", { noremap = true, silent = true })
-- Use 'x' to remove region instead like tmux/screen
-- vim.api.nvim_set_keymap("n", "<C-w>x", "<C-w>c", { noremap = true, silent = true })

-- Resizing
vim.api.nvim_set_keymap("n", "<C-w><Down>", ":resize -2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w><Up>", ":resize +2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w><Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w><Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Stay in indent mode after shifting left or right
-- vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- Redraw turns off search highlighting
-- <C-L> used by tmux navigator (see tmux.lua)
-- vim.api.nvim_set_keymap("n", "<C-l>",     ":nohl<CR><C-l>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>l", ":nohl<CR><C-l>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>l", ":nohl<CR>", { noremap = true, silent = true })

-- Quick lines
vim.api.nvim_set_keymap(
  "i",
  "..l",
  "--------------------------------------------<CR><CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "i",
  "..d",
  '=======<C-R>=strftime("%a %Y-%m-%d %H:%M:%S %z")<CR>========<CR><CR>',
  { noremap = true, silent = true }
)

-- Very magic mode
-- vim.api.nvim_set_keymap("n", "/", "/\\v", { noremap = true, silent = true })

-- JSON
-- vim.api.nvim_set_keymap("n", "<leader>jq", ":%!jq .<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>JQ", ":%!jq . -c<CR>", { noremap = true, silent = true })

-- ToggleTerm - set in plugin
-- vim.api.nvim_set_keymap("n", "<leader>tt", ":ToggleTerm<CR>", { noremap = true, silent = true })

-- Cursorline Toggle
-- vim.api.nvim_set_keymap("n", "<leader>cl", ":set cursorline!<CR>", { noremap = true, silent = true })
-- Clear gutter vim.api.nvim_set_keymap("n", "<leader>H", ":highlight clear signcolumn<CR>:highlight clear foldcolumn<CR>", { noremap = true, silent = true })

-- Toggle Indent blankline
-- vim.api.nvim_set_keymap("n", "<leader>NN", ":IndentBlanklineToggle<CR>", { noremap = true, silent = true })

-- For vim-tmux-navigator
-- vim.api.nvim_set_keymap("n", "<C-h>", '"<cmd> TmuxNavigateLeft<CR>", "window left"', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap(
--   "n",
--   "<C-l>",
--   '"<cmd> TmuxNavigateRight<CR>", "window right"',
--   { noremap = true, silent = true }
-- )
-- vim.api.nvim_set_keymap("n", "<C-j>", '"<cmd> TmuxNavigateDown<CR>", "window down"', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-k>", '"<cmd> TmuxNavigateUp<CR>", "window up"', { noremap = true, silent = true })

-- Haven't yet updated these
vim.cmd([[
  nnoremap <leader>nn :execute "set signcolumn="  .  (&signcolumn == "yes" ? "yes:4" : "yes") \| set nonu nornu nocul nolist<CR> :IndentBlanklineDisable<CR> :lua vim.b.miniindentscope_disable=true<CR>
  nnoremap <leader>NN :execute "set signcolumn="  .  (&signcolumn == "yes" ? "yes:4" : "yes") \| set nu rnu cul list<CR> :IndentBlanklineEnable<CR> :lua vim.b.miniindentscope_disable=false<CR>
  " nnoremap <leader>nn :execute "set signcolumn="  .  (&signcolumn == "yes" ? "yes:4" : "yes") \| set nu! rnu! \| set cul!<CR> :IndentBlanklineToggle<CR>
  nnoremap <leader>cc :execute "set colorcolumn=" . (&colorcolumn == "" ? "80,120" : "")<CR>
]])
