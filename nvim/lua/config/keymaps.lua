local M = {}
local opts = { noremap = true }
vim.keymap.set("i", "umeter", "µ", opts)
vim.keymap.set("i", ";;l", [[-------------------------------------------<CR><CR>]], opts)
vim.keymap.set("i", ";;d", [[============<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>============<CR><CR>]], opts)
vim.keymap.set("n", "<C-l>", ":nohl<CR><C-l>", opts)
vim.keymap.set("n", "<leader>ro", [[:exe "set cc=" . (&cc == "" ? "80,120" : "")<CR>]], opts)
vim.keymap.set("n", "<leader>rl", [[:exe "set cuc! cul!"<CR>]])
vim.keymap.set("n", "<leader>rr", [[:exe "set rnu! nu! list!"<CR>]])
-- cursor remains in place after J
vim.keymap.set("n", "J", [[mzJ`z]], opts)
-- paste over highlight, which deletes to void register
vim.keymap.set("x", "<leader>p", [["_dPa]], opts)
vim.keymap.set("n", "<leader>Y", [["+Y]], opts)
vim.keymap.set("n", "<leader>y", [["+y]], opts)
vim.keymap.set("v", "<leader>y", [["+y]], opts)
vim.keymap.set("n", "Q", "<nop>", opts)
return M
