-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("n", "<leader>RC", ":set cuc! cul!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-PageUp>", ":bp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":bn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-PageUp>", "<ESC>:bp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-PageDown>", "<ESC>:bn<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>NN", ":IndentBlanklineToggle<CR>", { noremap = true, silent = true })
