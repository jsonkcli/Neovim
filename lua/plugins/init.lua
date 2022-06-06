local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end


-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}



return packer.startup(function(use)
    use { "wbthomason/packer.nvim" }
    use 'kristijanhusak/defx-git'
    use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim

    -- UI
    use { 'navarasu/onedark.nvim' }
    use { "rmehri01/onenord.nvim" }
    use { "kyazdani42/nvim-web-devicons", config = require "plugins.configs.icons" }
    use {
        "nvim-lualine/lualine.nvim",
        config = require "plugins.configs.lualine",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    }
    use {
        "akinsho/bufferline.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = require "plugins.configs.bufferline",
    }
    use { "folke/which-key.nvim" }
    use { "karb94/neoscroll.nvim", config = require "plugins.configs.neoscroll" }

    -- Syntax
    use {
        "nvim-treesitter/nvim-treesitter", requires = {
            "windwp/nvim-ts-autotag",
            "p00f/nvim-ts-rainbow",
        },
        run = ":TSUpdate",
        config = require "plugins.configs.treesitter",
    }

    -- Utilities
    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons",
        },
        config = require "plugins.configs.nvimtree",
    }
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = require "plugins.configs.telescope",
    }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "lukas-reineke/indent-blankline.nvim", config = require "plugins.configs.indent" }
    use { "windwp/nvim-autopairs", config = require "plugins.configs.autopairs" }
    use { "tpope/vim-surround" }
    use { "norcalli/nvim-colorizer.lua", config = require "plugins.configs.colorizer" }


    use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

    -- LSP
    use {
        "neovim/nvim-lspconfig",
        requires = {
            "jose-elias-alvarez/typescript.nvim",
        },
    }
    use {
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    }

    -- -- Comment
    use { "numToStr/Comment.nvim", config = require "plugins.configs.comment" }

    -- -- Completion
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "saadparwaiz1/cmp_luasnip", -- snippet completions
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
            'hrsh7th/vim-vsnip-integ',
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        config = require "plugins.configs.cmp",
    }

    -- -- Snippets
    use { "kitagry/vs-snippets" }
    use { "dsznajder/vscode-es7-javascript-react-snippets", run = "npm install --frozen-lockfile && npm compile" }
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use


    -- Tmux
    use { "aserowy/tmux.nvim", config = require "plugins.configs.tmux" }

    -- Git
    use {
        "lewis6991/gitsigns.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = require "plugins.configs.gitsigns",
    }


    -- Toggle Term
    use {"akinsho/toggleterm.nvim", config = require "plugins.configs.toggleterm"}
    -- Markdown
    use {
        "davidgranstrom/nvim-markdown-preview",
        config = function()
            vim.g.nvim_markdown_preview_format = "gfm"
            vim.g.nvim_markdown_preview_theme = "github"
        end,
    }

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
