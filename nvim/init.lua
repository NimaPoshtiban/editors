-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Set mapleader and maplocalleader before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>w', ':w<CR>', vim.tbl_extend('force', opts, { desc = 'Save file' }))
vim.keymap.set('n', '<leader>q', ':q<CR>', vim.tbl_extend('force', opts, { desc = 'Quit' }))
vim.keymap.set('n', '<C-h>', '<C-w>h', vim.tbl_extend('force', opts, { desc = 'Move to left window' }))
vim.keymap.set('n', '<C-j>', '<C-w>j', vim.tbl_extend('force', opts, { desc = 'Move to below window' }))
vim.keymap.set('n', '<C-k>', '<C-w>k', vim.tbl_extend('force', opts, { desc = 'Move to above window' }))
vim.keymap.set('n', '<C-l>', '<C-w>l', vim.tbl_extend('force', opts, { desc = 'Move to right window' }))
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', vim.tbl_extend('force', opts, { desc = 'Next buffer' }))
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', vim.tbl_extend('force', opts, { desc = 'Previous buffer' }))
vim.keymap.set('i', 'jj', '<Esc><CR>', vim.tbl_extend('force', opts, { desc = 'Exit insert mode' }))
-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "vhyrro/luarocks.nvim",
            priority = 1000,
            config = true,
        },
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd([[colorscheme tokyonight]])
            end,
        },
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
            },
            config = function()
            	local cmp = require('cmp')
		cmp.setup({
			mapping = {
			['<C-Space>'] = cmp.mapping.complete(),  -- Trigger completion
                        ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm selection
                        ['<Tab>'] = cmp.mapping.select_next_item(),  -- Next suggestion
                        ['<S-Tab>'] = cmp.mapping.select_prev_item(),  -- Previous suggestion
			},
  sources = {
                        { name = 'nvim_lsp' },
                        { name = 'buffer' },
                    },
		})
            end,
        },
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup({
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗",
                        },
                    },
                })
            end,
        },
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            config = function()
                require("mason-tool-installer").setup({
                    ensure_installed = {
                        "clangd",
                        "lua-language-server",
                        "stylua",
                        "shellcheck",
                        "editorconfig-checker",
                        "pylyzer",
                        "json-to-struct",
                        "misspell",
                        "staticcheck",
                        "vint",
                    },
                    auto_update = false,
                    run_on_start = true,
                    start_delay = 3000,
                    debounce_hours = 5,
                    integrations = {
                        ["mason-lspconfig"] = true,
                        ["mason-null-ls"] = true,
                        ["mason-nvim-dap"] = true,
                    },
                })
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup()
                require("mason-lspconfig").setup_handlers({
                    function(server_name)
                        local opts = {
                            capabilities = require("cmp_nvim_lsp").default_capabilities(),
                            on_attach = function(client, bufnr)
                               local bufopts = { noremap = true, silent = true, buffer = bufnr }
                                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', bufopts, { desc = 'Go to definition' }))
                                vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', bufopts, { desc = 'Show hover info' }))
                                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code action' }))
                                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = 'Rename symbol' }))  -- Add custom keybindings here if desired
                            end,
                        }
                        if server_name == "clangd" then
                            opts.cmd = {
                                "clangd",
                                "--clang-tidy",
                                "--background-index",
                                "--offset-encoding=utf-8",
                            }
                            opts.root_dir = require("lspconfig").util.root_pattern(".clangd", "compile_commands.json")
                        end
                        require("lspconfig")[server_name].setup(opts)
                    end,
                })
            end,
        },
        {
            "neovim/nvim-lspconfig",
            -- No config function needed here as mason-lspconfig handles setup
        },
        {
            "jay-babu/mason-null-ls.nvim",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "williamboman/mason.nvim",
                "nvimtools/none-ls.nvim",
            },
            config = function()
                require("mason-null-ls").setup({
                    methods = {
                        diagnostics = true,
                        formatting = true,
                        code_actions = true,
                        completion = true,
                        hover = true,
                    },
                })
            end,
        },
        {
            "mfussenegger/nvim-dap",
        },
        {
            "jay-babu/mason-nvim-dap.nvim",
            config = function()
                require("mason-nvim-dap").setup()
            end,
        },
        {
            "mfussenegger/nvim-lint",
        },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
})

-- Global LSP and diagnostic settings
vim.lsp.set_log_level("debug")
vim.diagnostic.enable()
vim.diagnostic.config({ virtual_text = true })
