local M = {}

local opts = { noremap = true }

-- quick save
-- vim.keymap.set('i', '<C-s>', '<Esc>:up<CR>gi')
-- vim.keymap.set('n', '<C-s>', ':up<CR>')

-- finer grain undo
-- vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>', opts)

-- quick undo
-- vim.keymap.set('i', '<C-z>', '<C-o>u')

-- custom maps
vim.keymap.set("i", "`u", "µ", opts)
vim.keymap.set("i", "`l", [[-------------------------------------------<CR><CR>]], opts)
vim.keymap.set("i", "`d", [[============<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>============<CR><CR>]], opts)

-- clear hls
vim.keymap.set("n", "<C-l>", ":nohl<CR><C-l>")

-- show columns at 80 and 120
vim.keymap.set("n", "<leader>co", [[:exe "set cc=" . (&cc == "" ? "80,120" : "")<CR>]])

-- vim.keymap.set('n', '<leader>cl', [[:exe "set cuc! cul!"<CR>]])
-- vim.keymap.set('n', '<leader>rr', [[:exe "set rnu!"<CR>]])

-- visual indent stays in visual
-- vim.keymap.set('v', '<', '<gv', opts)
-- vim.keymap.set('v', '>', '>gv', opts)

-- terminal escape is double C-\
-- vim.keymap.set('t', [[<C-\><C-\>]], [[<C-\><C-n>]])
-- vim.keymap.set('t', [[<C-b>[]], [[<C-\><C-n>]])

-- visual line moves
-- vim.keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]])
-- vim.keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]])

-- cursor remains in place after J
-- vim.keymap.set('n', 'J', [[mzJ`z]], opts)

-- C-u/d stays in middle of the page
-- vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
-- vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)

-- search stays in the middle of the page
-- vim.keymap.set('n', 'n', 'nzzzv', opts)
-- vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- paste over highlight, which deletes to void register
-- vim.keymap.set('x', '<leader>p', [["_dPa]])

-- yank into clipboard(+)keymap.set('n', '<leader>y', [["+y]])
-- vim.keymap.set('v', '<leader>y', [["+y]])
-- vim.keymap.set('n', '<leader>Y', [["+Y]])

-- disable Q
-- vim.keymap.set('n', 'Q', '<nop>')

-- quickfix navigation
-- vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
-- vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
-- vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
-- vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')

return M
