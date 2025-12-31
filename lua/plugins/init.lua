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
    lazy = false,
    config = function()
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "nvim_treesitter")
      local opts = require("plugins.configs.nvim_treesitter")
      require("nvim-treesitter").setup(opts)
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
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "RenderMarkdown" },
    init = function()
      require("core.utils").load_mappings("render_markdown")
    end,
    ft = { "markdown", "codecompanion" },
    opts = {
      enabled = false,
      code = {
        border = "thick",
        language = false,
      },
      render_modes = { "n", "no", "c", "t", "i", "v" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    lazy = false,
    init = function()
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
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Auto pairs integration
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

      -- Adds vscode-like pictograms to nvim-cmp completions
      {
        "onsails/lspkind.nvim",
        config = function()
          require("lspkind").setup()
        end,
      },

      -- Snippet engine
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        config = function()
          require("plugins.configs.friendly_snippets").setup()
        end,
      },

      -- GitHub Copilot integration
      {
        "zbirenbaum/copilot.lua",
        cmd = { "Copilot" },
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false }, -- Disable default ghost text
            panel = { enabled = false }, -- Disable default panel
          })
        end,
      },

      -- nvim-cmp source for GitHub Copilot
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },

      {
        -- nvim-cmp source for LuaSnip
        "saadparwaiz1/cmp_luasnip",
        -- nvim-cmp source for neovim's built-in language server client.
        "hrsh7th/cmp-nvim-lsp",
        -- nvim-cmp source for neovim Lua API.
        "hrsh7th/cmp-nvim-lua",
        -- nvim-cmp source for buffer words.
        "hrsh7th/cmp-buffer",
        -- nvim-cmp source for filesystem paths.
        "hrsh7th/cmp-path",
        -- nvim-cmp source for vim's cmdline.
        "hrsh7th/cmp-cmdline",
      },
    },

    config = function()
      dofile(vim.g.base46_cache .. "nvim_cmp")
      local opts = require("plugins.configs.nvim_cmp")
      require("cmp").setup(opts)
    end,
  },

  {
    "kkrampis/codex.nvim",
    cmd = { "Codex", "CodexToggle" },
    keys = {
      {
        "<C-f>",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex CLI float",
        mode = { "n" },
      },
    },
    opts = {
      keymaps = {
        quit = "<C-f>",
      },
      border = "rounded",
    },
  },

  -- {
  --   "isovector/cornelis",
  --   name = "cornelis",
  --   ft = { "agda" },
  --   build = "stack install",
  --   dependencies = { "neovimhaskell/nvim-hs.vim", "kana/vim-textobj-user" },
  --   init = function()
  --     require("core.utils").load_mappings("cornelis")
  --   end,
  -- },
}

local opts = require("plugins.configs.lazy_nvim")
require("lazy").setup(plugins, opts)
