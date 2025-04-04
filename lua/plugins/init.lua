-- All plugins have lazy=true by default, to load a plugin on startup just lazy=false
-- List of all plugins & their definitions
local plugins = {

  "nvim-lua/plenary.nvim",

  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      dofile(vim.g.base46_cache .. "nvim_web_devicons")
      local opts = require("plugins.configs.nvim_web_devicons")
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
      dofile(vim.g.base46_cache .. "nvim_treesitter")
      local opts = require("plugins.configs.nvim_treesitter")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    ft = { "gitcommit", "diff" },
    init = function()
      require("plugins.configs.gitsigns_nvim").init()
    end,
    config = function()
      dofile(vim.g.base46_cache .. "gitsigns_nvim")
      require("plugins.configs.gitsigns_nvim").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
      return require("plugins.configs.conform_nvim")
    end,
  },

  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "HighlightColors" },
    init = function()
      require("core.utils").load_mappings("highlight_colors")
    end,
    config = function()
      require("nvim-highlight-colors").setup()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      require("core.utils").lazy_load("nvim-lspconfig")
      require("plugins.configs.nvim_lspconfig").init()
    end,
    config = function()
      dofile(vim.g.base46_cache .. "nvim_lspconfig")
      require("plugins.configs.nvim_lspconfig").setup()
    end,
  },

  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialPrev", "AerialNext" },
    init = function()
      require("core.utils").load_mappings("aerial_nvim")
    end,
    opts = function()
      return require("plugins.configs.aerial_nvim")
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
          require("plugins.configs.friendly_snippets").setup()
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
      dofile(vim.g.base46_cache .. "nvim_cmp")
      local opts = require("plugins.configs.nvim_cmp")
      require("cmp").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    init = function()
      require("core.utils").load_mappings("comment_nvim")
    end,
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle" },
    init = function()
      require("core.utils").load_mappings("nvim_tree")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "nvim_tree")
      require("plugins.configs.nvim_tree").setup()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      -- {
      --   "nvim-telescope/telescope-fzf-native.nvim",
      --   build = {
      --     "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release",
      --     "cmake --build build --config Release",
      --     "cmake --install build --prefix build",
      --   },
      -- },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    -- lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      require("core.utils").load_mappings("telescope_nvim")
    end,
    config = function()
      dofile(vim.g.base46_cache .. "telescope_nvim")
      require("plugins.configs.telescope_nvim").setup()
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    init = function()
      require("core.utils").load_mappings("toggleterm_nvim")
    end,
    config = function()
      require("plugins.configs.toggleterm_nvim").setup()
    end,
  },
}

local opts = require("plugins.configs.lazy_nvim")
require("lazy").setup(plugins, opts)
