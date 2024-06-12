-- All plugins have lazy=true by default, to load a plugin on startup just lazy=false
-- List of all plugins & their definitions
local plugins = {

  "nvim-lua/plenary.nvim",

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return require("plugins.configs.devicons")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      require("core.utils").lazy_load("nvim-treesitter")
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require("plugins.configs.treesitter")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { 'BufReadPost', 'BufNewFile' },
    ft = { "gitcommit", "diff" },
    init = function()
      local group_name = "GitSignsLazyLoad"
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup(group_name, { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name(group_name)
            vim.schedule(function()
              require("lazy").load({ plugins = { "gitsigns.nvim" } })
            end)
          end
        end,
      })
    end,
    opts = function()
      return require("plugins.configs.git")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      require("core.utils").lazy_load("nvim-lspconfig")
      require("plugins.configs.lsp").init()
    end,
    opts = {
      inlay_hints = { enabled = true },
    },
    config = function()
      dofile(vim.g.base46_cache .. "lsp")
      require("plugins.configs.lsp").setup()
    end,
  },

  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
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
        opts = { history = true, updateevents = "TextChanged, TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.snippets").setup(opts)
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)
          require("cmp").event:on(
            "confirm_done",
            require("nvim-autopairs.completion.cmp").on_confirm_done())
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
    opts = function()
      return require("plugins.configs.cmp")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "cmp")
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
    opts = function()
      return require("plugins.configs.nvimtree")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
      vim.g.nvimtree_side = opts.view.side
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    lazy = false,
    init = function()
      require("core.utils").load_mappings("telescope")
    end,
    opts = function()
      return require("plugins.configs.telescope")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require("telescope")
      telescope.setup(opts)
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    init = function()
      require("core.utils").load_mappings("toggleterm")
    end,
    opts = function()
      return require("plugins.configs.terminal").opts
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)
      require("plugins.configs.terminal").setup()
    end,
  },
}

require("lazy").setup(plugins, require("plugins.configs.lazy_nvim"))
