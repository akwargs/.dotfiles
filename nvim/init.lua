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
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-rsi',
  'tpope/vim-speeddating',
  'tpope/vim-repeat',
  'tpope/vim-eunuch',
  'tpope/vim-vinegar',
  'tpope/vim-sleuth',
  'godlygeek/tabular',
  'dbakker/vim-paragraph-motion',
  'mbbill/undotree',
  'ThePrimeagen/harpoon',
  'jlanzarotta/bufexplorer',
  'axvr/photon.vim',

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
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

  { 'folke/which-key.nvim',  opts = {} },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  -- keep this in case i find a colorscheme i like
  -- {
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onelight',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          'mode',
          {
            'buffers',
            mode = 4,
          },
        },
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  { 'numToStr/Comment.nvim', opts = {} },

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
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {},
  },

  {
    'vladdoster/remember.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  {
    'chentoast/marks.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('marks').setup {
        default_mappings = true,
        builtin_marks = { '.', '<', '>', '^' },
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 250,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        excluded_filetypes = {},
        bookmark_0 = {
          sign = '󰉀',
          virt_text = 'hello world',
          annotate = false,
        },
        mappings = {},
      }
    end,
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
        ensure_installed = { 'markdownlint', 'flake8', 'black', 'isort', 'stylua' },
        automatic_installation = false,
        handlers = {
          function() end,
          markdownlint = function(source_name, methods)
            null_ls.register(null_ls.builtins.formatting.markdownlint)
          end,
          flake8 = function(source_name, methods)
            null_ls.register(null_ls.builtins.diagnostics.flake8.with {
              extra_args = {
                '--max-line-length',
                '100',
              },
            })
          end,
          black = function(source_name, methods)
            null_ls.register(null_ls.builtins.formatting.black.with {
              extra_args = {
                '--max-line-length',
                '100',
              },
            })
          end,
          isort = function(source_name, methods)
            null_ls.register(null_ls.builtins.formatting.isort)
          end,
          stylua = function(source_name, methods)
            null_ls.register(null_ls.builtins.formatting.stylua)
          end,
          -- ruff = function(source_name, methods)
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
vim.o.mouse = 'a'
vim.o.scrollback = 20000
vim.o.scrolloff = 8
vim.o.shiftwidth = 2
vim.o.showmatch = true
vim.o.showmode = false
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.textwidth = 100
vim.o.ttimeoutlen = 300
vim.o.undodir = os.getenv 'TEMP' .. '/nvim'
vim.o.undofile = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.visualbell = true
vim.o.whichwrap = '<,>,h,l'
vim.o.wildignorecase = true
vim.o.wrapscan = false

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'

-- keymaps
local keymap = vim.keymap
local opts = { noremap = true }
keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- quick save
keymap.set('i', '<C-s>', '<Esc>:up<CR>gi')
keymap.set('n', '<C-s>', ':up<CR>')
-- finer grain undo
keymap.set('i', '<C-u>', '<C-g>u<C-u>', opts)
-- quick undo
keymap.set('i', '<C-z>', '<C-o>u')
-- custom maps
keymap.set('i', '`u', 'µ')
keymap.set('i', '`l', [[-------------------------------------------<CR><CR>]])
keymap.set('i', '`d', [[============<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>============<CR><CR>]])
-- very magic
keymap.set('n', '/', [[/\v]], opts)
keymap.set('n', '?', [[?\v]], opts)
-- clear hls
keymap.set('n', '<leader>l', ':nohl<CR><C-l>')
-- depending on terminal, might need this
keymap.set('n', '<F12>', ':set paste!<CR>')
-- show columns at 80 and 120
keymap.set('n', '<leader>cc', [[:exe "set cc=" . (&cc == "" ? "80,120" : "")<CR>]])
keymap.set('n', '<leader>nn', [[:exe "set nu! rnu! list!"<CR>:Gitsigns toggle_signs<CR>:MarksToggleSigns<CR>]])
keymap.set('n', '<leader>cl', [[:exe "set cuc! cul!"<CR>]])
-- function toggle_rnu()
--   vim.o.relativenumber = not vim.o.relativenumber
-- end
-- keymap.set('n', '<leader>rr', [[:lua toggle_rnu()<CR>]])
-- toggle rnu doesn't appear to restore the rnu leave for now
keymap.set('n', '<leader>rr', [[:exe "set rnu!"<CR>]])
-- undotree
keymap.set('n', '<F5>', vim.cmd.UndotreeToggle)
-- tabularize
keymap.set('v', '<leader>a=', [[:Tabularize /=<CR>]])
keymap.set('v', '<leader>a:', [[:Tabularize /:\zs<CR>]])
-- visual indent stays in visual
keymap.set('v', '<', '<gv', opts)
keymap.set('v', '>', '>gv', opts)
-- terminal escape is double C-\
keymap.set('t', [[<C-\><C-\>]], [[<C-\><C-n>]])
keymap.set('t', [[<C-b>[]], [[<C-\><C-n>]])
-- visual line moves
keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]])
keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]])
-- cursor remains in place after J
keymap.set('n', 'J', [[mzJ`z]], opts)
-- C-u/d stays in middle of the page
keymap.set('n', '<C-u>', '<C-u>zz', opts)
keymap.set('n', '<C-d>', '<C-d>zz', opts)
-- search stays in the middle of the page
-- keymap.set('n', 'n', 'nzzzv', opts)
-- keymap.set('n', 'N', 'Nzzzv', opts)
-- paste over highlight, which deletes to void register
keymap.set('x', '<leader>p', [["_dPa]])
-- yank into clipboard(+)keymap.set('n', '<leader>y', [["+y]])
-- keymap.set('v', '<leader>y', [["+y]])
-- keymap.set('n', '<leader>Y', [["+Y]])
-- disable Q
keymap.set('n', 'Q', '<nop>')
-- quickfix navigation
keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')
-- experiment with these
-- keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')
-- keymap.set('n', '<leader>f', function()
--   vim.lsp.buf.format()
-- end)
-- keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })
keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- autocommands
local api = vim.api
local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
})
api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
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
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'c',
    'comment',
    'cpp',
    'csv',
    'diff',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'perl',
    'python',
    'regex',
    'rust',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
    'yang',
  },
  modules = {},
  auto_install = true,
  highlight = { enable = true },
  ignore_install = {},
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
  sync_install = true,
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
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
      set_jumps = true,
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

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
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
  vim.o.shell = 'pwsh'
else
  vim.o.shell = 'zsh'
  vim.o.timeoutlen = 300
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
  iab <buffer> Francais Français
  iab <buffer> naive naïve
  iab <buffer> um µm
  iab <buffer> usec µs
]]
-- vim: ts=2 sts=2 sw=2 et
