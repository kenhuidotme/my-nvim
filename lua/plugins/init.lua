-- All plugins have lazy=true by default, to load a plugin on startup just lazy=false
-- List of all plugins & their definitions
local plugins = {

  "nvim-lua/plenary.nvim",

  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      dofile(vim.g.base46_cache .. "devicons")
      local opts = require("plugins.configs.devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    init = function()
      require("core.utils").lazy_load("nvim-treesitter")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
      local opts = require("plugins.configs.treesitter")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    ft = { "gitcommit", "diff" },
    init = function()
      require("plugins.configs.gitsigns").init()
    end,
    config = function()
      dofile(vim.g.base46_cache .. "gitsigns")
      require("plugins.configs.gitsigns").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
      return require("plugins.configs.conform")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      require("core.utils").lazy_load("nvim-lspconfig")
      require("plugins.configs.lspconfig").init()
    end,
    config = function()
      dofile(vim.g.base46_cache .. "lspconfig")
      require("plugins.configs.lspconfig").setup()
    end,
  },

  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialPrev", "AerialNext" },
    init = function()
      require("core.utils").load_mappings("aerial")
    end,
    opts = function()
      return require("plugins.configs.aerial")
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        config = function()
          require("plugins.configs.snippets").setup()
        end,
      },
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup({
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
          })
          require("cmp").event:on(
            "confirm_done",
            require("nvim-autopairs.completion.cmp").on_confirm_done()
          )
        end,
      },
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    config = function()
      dofile(vim.g.base46_cache .. "cmp")
      local opts = require("plugins.configs.cmp")
      require("cmp").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    init = function()
      require("core.utils").load_mappings("comment")
    end,
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle" },
    init = function()
      require("core.utils").load_mappings("nvimtree")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "nvimtree")
      require("plugins.configs.nvimtree").setup()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = {
          "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release",
          "cmake --build build --config Release",
          "cmake --install build --prefix build",
        },
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    -- lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      require("core.utils").load_mappings("telescope")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "telescope")
      require("plugins.configs.telescope").setup()
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    init = function()
      require("core.utils").load_mappings("toggleterm")
    end,
    config = function()
      require("plugins.configs.terminal").setup()
    end,
  },
}

local opts = require("plugins.configs.lazy_nvim")
require("lazy").setup(plugins, opts)
