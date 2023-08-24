vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- begin vim plugins
  'tpope/vim-surround',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'tpope/vim-rsi',
  'tpope/vim-endwise',
  'godlygeek/tabular',
  'dbakker/vim-paragraph-motion',
  'axvr/photon.vim',
}, {})

-- For minimal only
vim.cmd [[ set statusline=%<%f%=\ %{fugitive#statusline()}\ [%1*%M%*%{','.&fileformat}%R%Y]\ [%6l,%4c%V]\ %3b\ 0x%02Bh\ %P ]]

-- See `:help vim.o`
vim.o.backup = true
vim.o.breakindent = true
vim.o.cmdheight = 2
vim.o.completeopt = 'menuone,noselect'
vim.o.display = 'truncate'
vim.o.expandtab = true
vim.o.fileformats = 'unix,dos'
vim.o.foldmethod = 'syntax'
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = 'tab:»·,trail:·'
vim.o.modelines = 1
-- vim.o.mouse = ''
vim.o.showmatch = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
-- vim.o.undodir = vim.fn.expand('~/temp/nvim')
vim.o.undodir = os.getenv("HOME") .. '/temp/nvim'
vim.o.undofile = true
vim.o.visualbell = true
vim.o.whichwrap = '<,>,h,l'
vim.o.wildignorecase = true
vim.o.wrapscan = false

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.cmd [[
  au BufWinEnter * normal zR
  augroup Python
    au!
    autocmd FileType python setlocal foldmethod=indent
  augroup END
  augroup TwoSpaces
    au!
    autocmd FileType vim setlocal sw=2 ts=2 sts=2
    autocmd FileType lua setlocal sw=2 ts=2 sts=2
  augroup END
  augroup Logs
    au!
    autocmd FileType log setlocal syntax=off
  augroup END
  augroup vimStartup
    au!
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
  augroup END
  if !&diff
    augroup signcolumngroup
      au!
      autocmd BufEnter,FocusGained,InsertLeave * if &signcolumn == "yes" | set nu rnu | endif
      autocmd BufLeave,FocusLost,InsertEnter   * if &signcolumn == "yes" | set nornu | endif
    augroup END
  endif

  inoremap <C-S> <Esc>:up<CR>gi
  inoremap <C-U> <C-G>u<C-U>
  inoremap <C-Z> <C-O>u
  inoremap <S-Insert> <C-R>+
  inoremap ..l -------------------------------------------<CR><CR>
  inoremap ..d ============<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>============<CR><CR>
  nnoremap / /\v
  nnoremap <leader>l  :nohl<CR>
  nnoremap <silent> <leader>nn :exe "set nu! rnu! list!"<CR>
  nnoremap <silent> <leader>cc :exe "set cc=" . (&cc == "" ? "80,120" : "")<CR>
  nnoremap <silent> <leader>cl :exe "set cuc! cul!"<CR>
  vnoremap <silent> <leader>a= :Tabularize /=<CR>
  vnoremap <silent> <leader>a: :Tabularize /:\zs<CR>
  vnoremap <S-Insert> +gp

  iab <buffer> um µm
  iab <buffer> usec µs

  colorscheme antiphoton
  " highlight clear specialkey
  " highlight clear signcolumn
  " highlight clear foldcolumn

]]
-- vim: ts=2 sts=2 sw=2 et
