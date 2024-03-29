return {
  -- MASON
  {
    'williamboman/mason.nvim',
    ft = { 'lua', 'astro', 'go' },
    config = function()
      require('mason').setup()
    end,
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    ft = { 'rust', 'lua', 'go', 'python', 'astro' },
    -- event = 'VeryLazy',
    config = function()
      local lspconfig = require('lspconfig')

      local signs = {
        Error = ' ',
        Warn = ' ',
        Hint = '⊕ ',
        Info = ' ',
      }

      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        -- stylua: ignore
        callback = function(event)
          local opts = { buffer = event.buf, remap = true }
          -- local telescope = require('telescope.builtin')

          vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set('n', 'gD', function() vim.lsp.buf.references() end, opts)-- telescope.lsp_references(require('telescope.themes').get_dropdown({}))
          vim.keymap.set('n', 'gI', function() vim.lsp.buf.implementation() end, opts)
          vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set('n', '<leader>cd', function() vim.diagnostic.open_float() end, opts)
          vim.keymap.set('n', '<leader>c[', function() vim.diagnostic.goto_next() end, opts)
          vim.keymap.set('n', '<leader>c]', function() vim.diagnostic.goto_prev() end, opts)
          vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
          vim.keymap.set('n', 'ge', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, opts)
          vim.keymap.set('n', 'gE', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, opts)
          vim.keymap.set('n', 'gw', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, opts)
          vim.keymap.set('n', 'gW', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, opts)
          vim.keymap.set('n', '<leader>cr', function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
        end,
      })

      -- #### Server specific configuration ####
      -- ### Lua ###
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim', 'describe', 'it', 'before_each', 'after_each', 'notity' },
              disable = { 'missing-parameters', 'missing-fields' },
            },
          },
        },
      })

      -- ### Python ###
      -- lspconfig.pyright.setup({})

      -- ### Go ###
      lspconfig.gopls.setup({})

      -- ### Rust ###
      -- lspconfig.rust_analyzer.setup({})

      -- ### Astro ###
      lspconfig.astro.setup({})
    end,
  },
}
