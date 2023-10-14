-- adapted from kickstart.nvim
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- begin plugins
require('lazy').setup({
  'tpope/vim-surround',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'tpope/vim-rsi',
  'tpope/vim-speeddating',
  'tpope/vim-repeat',
  'tpope/vim-eunuch',
  'tpope/vim-vinegar',
  'tpope/vim-sleuth',
  'godlygeek/tabular',
  'dbakker/vim-paragraph-motion',
  'airblade/vim-gitgutter',
  'kshenoy/vim-signature',
  'jlanzarotta/bufexplorer',
  'frioux/vim-regedit',
  'vimwiki/vimwiki',
  { 'junegunn/fzf', build = './install --bin' },
  'junegunn/fzf.vim',
  'junegunn/vim-easy-align',
  'mbbill/undotree',
  'ThePrimeagen/harpoon',
  'axvr/photon.vim',
  'zigford/vim-powershell',

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      'folke/neodev.nvim',
    },
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-path',
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- autoformat
  {
    'neovim/nvim-lspconfig',
    config = function()
      local format_is_enabled = true
      vim.api.nvim_create_user_command('AutoFormatToggle', function()
        format_is_enabled = not format_is_enabled
        print('Setting autoformatting to: ' .. tostring(format_is_enabled))
      end, {})
      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = 'auto-lsp-format-' .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end
        return _augroups[client.id]
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('auto-lsp-attach-format', { clear = true }),
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          local bufnr = args.buf
          if not client.server_capabilities.documentFormattingProvider then
            return
          end
          if client.name == 'tsserver' then
            return
          end
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
              if not format_is_enabled then
                return
              end
              vim.lsp.buf.format {
                async = false,
                filter = function(c)
                  return c.id == client.id
                end,
              }
            end,
          })
        end,
      })
    end,
  },

  -- debug.lua
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      -- 'leoluz/nvim-dap-go',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        automatic_setup = true,
        handlers = {},
        ensure_installed = {},
      }
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }
      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
      -- require('dap-go').setup()
    end,
  },

  {
    'vladdoster/remember.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- null-ls, mason-null-ls: replace soon
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('null-ls').setup {}
    end,
  },
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
      local mason_null_ls = require 'mason-null-ls'
      local null_ls = require 'null-ls'
      mason_null_ls.setup {
        ensure_installed = { 'markdownlint', 'flake8', 'black', 'isort', 'stylua', 'yamllint' },
        automatic_installation = false,
        handlers = {
          function() end,
          markdownlint = function()
            null_ls.register(null_ls.builtins.formatting.markdownlint)
          end,
          flake8 = function()
            null_ls.register(null_ls.builtins.diagnostics.flake8.with {
              extra_args = {
                '--max-line-length',
                '100',
              },
            })
          end,
          black = function()
            null_ls.register(null_ls.builtins.formatting.black.with {
              extra_args = {
                '--max-line-length',
                '100',
              },
            })
          end,
          isort = function()
            null_ls.register(null_ls.builtins.formatting.isort)
          end,
          stylua = function()
            null_ls.register(null_ls.builtins.formatting.stylua)
          end,
          yamllint = function()
            null_ls.register(null_ls.builtins.diagnostics.yamllint)
          end,
          -- ruff = function()
          --   null_ls.register(null_ls.builtins.formatting.ruff)
          --   null_ls.register(null_ls.builtins.diagnostics.ruff)
          -- end,
        },
      }
    end,
  },
  -- null-ls, mason-null-ls look for replacment
}, {})
-- end plugins

-- options
vim.o.backup = true
vim.o.breakindent = true
vim.o.cmdheight = 2
vim.o.complete = '.,w,b,u,t,kspell'
vim.o.completeopt = 'menuone,noselect'
vim.o.display = 'truncate'
vim.o.expandtab = true
vim.o.fileformats = 'unix,dos'
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = 'tab:»·,trail:·'
vim.o.scrollback = 20000
vim.o.scrolloff = 8
vim.o.shiftwidth = 2
vim.o.showmatch = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.spelloptions = 'camel'
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.textwidth = 100
-- vim.o.timeoutlen = 500
-- vim.o.ttimeoutlen = 500
vim.o.undodir = os.getenv 'TEMP' .. '/nvim'
vim.o.undofile = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.visualbell = true
vim.o.whichwrap = '<,>,h,l'
vim.o.wildignorecase = true
vim.o.wrapscan = false

-- vim.opt.iskeyword:append '-'
-- vim.opt.iskeyword:remove '_'
vim.opt.nrformats:append 'alpha'

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- my keymaps
local keymap = vim.keymap
local noremap = { noremap = true }
local silent = { silent = true }
local ns = { noremap = true, silent = true }
-- quick save
keymap.set('i', '<C-s>', '<Esc>:up<CR>gi', noremap)
keymap.set('n', '<C-s>', ':up<CR>', noremap)
-- finer grain undo
keymap.set('i', '<C-u>', '<C-g>u<C-u>', noremap)
-- quick undo
keymap.set('i', '<C-z>', '<C-o>u', noremap)
-- custom maps
keymap.set('i', '`u', 'µ', ns)
keymap.set('i', '`l', [[-------------------------------------------<CR><CR>]], ns)
keymap.set('i', '`d', [[============<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>============<CR><CR>]], ns)
-- very magic
keymap.set('n', '/', [[/\v]], noremap)
keymap.set('n', '?', [[?\v]], noremap)
-- redo
keymap.set('n', 'U', [[:redo<CR>]], ns)
-- clear hls
keymap.set('n', '<leader>l', ':nohl<CR><C-l>', ns)
-- depending on terminal, might need this
keymap.set('n', '<F12>', ':set paste!<CR>', ns)
-- show columns at 80 and 120
keymap.set('n', '<leader>cc', [[:exe "set cc=" . (&cc == "" ? "80,120" : "")<CR>]], ns)
keymap.set('n', '<leader>nn', [[:exe "set nu! rnu! list!"<CR>]], ns)
keymap.set('n', '<leader>cl', [[:exe "set cuc! cul!"<CR>]], ns)
-- function toggle_rnu()
--   vim.o.relativenumber = not vim.o.relativenumber
-- end
-- keymap.set('n', '<leader>rr', [[:lua toggle_rnu()<CR>]], noremap)
-- toggle rnu doesn't appear to restore the rnu leave for now
keymap.set('n', '<leader>rr', [[:exe "set rnu!"<CR>]], noremap)
-- undotree
keymap.set('n', '<F9>', vim.cmd.UndotreeToggle, noremap)
-- tabularize
keymap.set('v', '<leader>a=', [[:Tabularize /=<CR>]], noremap)
keymap.set('v', '<leader>a:', [[:Tabularize /:\zs<CR>]], noremap)
-- visual indent stays in visual
keymap.set('v', '<', '<gv', noremap)
keymap.set('v', '>', '>gv', noremap)
-- terminal escape is double C-\
keymap.set('t', [[<C-\><C-\>]], [[<C-\><C-n>]], noremap)
keymap.set('t', [[<C-b>[]], [[<C-\><C-n>]], noremap)
-- visual line moves
keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]], noremap)
keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]], noremap)
-- cursor remains in place after J
keymap.set('n', 'J', [[mzJ`z]], noremap)
-- C-u/d stays in middle of the page
keymap.set('n', '<C-u>', '<C-u>zz', noremap)
keymap.set('n', '<C-d>', '<C-d>zz', noremap)
-- search stays in the middle of the page
-- keymap.set('n', 'n', 'nzzzv', noremap)
-- keymap.set('n', 'N', 'Nzzzv', noremap)
-- paste over highlight, which deletes to void register
keymap.set('x', '<leader>p', [["_dPa]], noremap)
-- yank into clipboard(+)keymap.set('n', '<leader>y', [["+y]], noremap)
-- keymap.set('v', '<leader>y', [["+y]], noremap)
-- keymap.set('n', '<leader>Y', [["+Y]], noremap)
-- disable Q
keymap.set('n', 'Q', '<nop>', noremap)
-- quickfix navigation
keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz', noremap)
keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz', noremap)
keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', noremap)
keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', noremap)
-- experiment with these
-- keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')
-- keymap.set('n', '<leader>f', function()
--   vim.lsp.buf.format()
-- end)
-- keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', silent)
keymap.set('v', '<Enter>', '<Plug>(EasyAlign)')

-- autocommands
local api = vim.api
local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.opt.relativenumber = true
      vim.opt.cursorline = false
      vim.opt.cursorcolumn = false
    end
  end,
})
api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.opt.cursorline = true
      vim.opt.cursorcolumn = true
      vim.cmd.redraw()
    end
  end,
})

local terminal = api.nvim_create_augroup('terminal', { clear = true })
api.nvim_create_autocmd({ 'TermOpen', 'TermEnter' }, {
  pattern = '*',
  group = terminal,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
  end,
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}
pcall(require('telescope').load_extension, 'fzf')
-- keymaps for telescope
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {},
    sync_install = true,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  -- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

require('neodev').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- harpoon config
local ui = require 'harpoon.ui'
local mark = require 'harpoon.mark'
-- local cmd = require('harpoon.cmd-ui')
-- local term = require('harpoon.term')
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)
vim.keymap.set('n', '<leader>af', mark.add_file)
vim.keymap.set('n', '<leader>hn', function()
  ui.nav_next()
end)
vim.keymap.set('n', '<leader>hp', function()
  ui.nav_prev()
end)
vim.keymap.set('n', '<leader>1', function()
  ui.nav_file(1)
end)
vim.keymap.set('n', '<leader>2', function()
  ui.nav_file(2)
end)
vim.keymap.set('n', '<leader>3', function()
  ui.nav_file(3)
end)
vim.keymap.set('n', '<leader>4', function()
  ui.nav_file(4)
end)
vim.keymap.set('n', '<leader>5', function()
  ui.nav_file(5)
end)
vim.keymap.set('n', '<leader>6', function()
  ui.nav_file(6)
end)
vim.keymap.set('n', '<leader>7', function()
  ui.nav_file(7)
end)
vim.keymap.set('n', '<leader>8', function()
  ui.nav_file(8)
end)
vim.keymap.set('n', '<leader>9', function()
  ui.nav_file(9)
end)
-- vim.keymap.set('n', '<leader>t0', function()
--   term.gotoTerminal(10)
-- end)
-- vim.keymap.set('n', '<leader>t1', function()
--   cmd.toggle_quick_meu()
-- end)
-- lua require('harpoon.term').sendCommand(1, 'ls -La')    -- sends ls -La to tmux window 1
-- lua require('harpoon.term').sendCommand(1, 1)           -- sends command 1 to term 1
require('harpoon').setup {}
-- :Telescope harpoon marks
require('telescope').load_extension 'harpoon'

-- vimwiki
vim.g.vimwiki_listsyms = '󰂎󰁻󰁽󰂁'
vim.g.vimwiki_list = {
  {
    path = '~/vimwiki/',
    links_space_char = '_',
  },
}

-- local snippets
local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local mydate = function()
  return { os.date '%Y-%m-%d %H:%M:%S' }
end
ls.add_snippets('all', {
  s('myaddline', {
    t '-------------------------------------------',
    t { '', '' },
    t { '', '' },
  }),
  s('myadddate', {
    t '============',
    f(mydate),
    t '============',
    t { '', '' },
    t { '', '' },
  }),
  s('autotrigger', {
    t 'autosnippet',
  }),
})
ls.filetype_extend('all', { '_' })

-- windows vs linux here
if vim.fn.has 'win32' == 1 then
  vim.o.shell = 'powershell'
else
  vim.o.shell = 'zsh'
  vim.o.timeoutlen = 500
end

-- some providers
-- cpanm -n Neovim::Ext
vim.g.python3_host_prog = os.getenv 'NVIM_PYTHON3_HOST'
vim.g.node_host_prog = os.getenv 'NVIM_NODE_HOST'

-- vim stuff
vim.cmd [[
  if !empty($VIM_LIGHT)
    colorscheme antiphoton
  else
    colorscheme photon
  endif
  inorea <buffer> Francais Français
  inorea <buffer> naive naïve
  inorea <buffer> um µm
  inorea <buffer> usec µs
  set statusline=%<%{&paste?'[PASTE]\ ':''}%f%=\ %{fugitive#statusline()}\ %1*%M%*%{','.&fileformat}%R%Y,L:%l/%L,C:%c%V
]]
-- vim: ts=2 sts=2 sw=2 et
