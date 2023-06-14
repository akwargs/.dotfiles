vim.api.nvim_set_keymap("n", "<leader>RC", ":set cuc! cul!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-PageUp>", ":bp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":bn<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>NN", ":IndentBlanklineToggle<CR>", { noremap = true, silent = true })

return {}
