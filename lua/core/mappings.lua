local M = {}

M.common = {
  i = {
    -- go to beginning and end
    ["<C-b>"] = { "<esc>^i", "Beginning of line" },
    ["<C-e>"] = { "<end>", "End of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  },

  n = {
    ["<Esc>"] = { "<cmd> noh <cr>", "Clear highlights" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <cr>", "Toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <cr>", "Toggle relative number" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", options = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", options = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", options = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", options = { expr = true } },

    -- restore jump forward
    ["<C-i>"] = { "<C-i>", "Jump forward" },

    -- new buffer
    ["<S-b>"] = { "<cmd> enew <cr>", "Buffer new" },

    -- new terminal
    ["<S-t>"] = { "<cmd> execute 'terminal' | startinsert <cr>", "Terminal new" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "Window jump left" },
    ["<C-l>"] = { "<C-w>l", "Window jump right" },
    ["<C-j>"] = { "<C-w>j", "Window jump down" },
    ["<C-k>"] = { "<C-w>k", "Window jump up" },

    -- window resize
    ["<C-Up>"] = { "<cmd> resize -1 <cr>", "Window height -1" },
    ["<C-Down>"] = { "<cmd> resize +1 <cr>", "Window height +1" },
    ["<C-Left>"] = { "<cmd> vertical resize -1 <cr>", "Window width +1" },
    ["<C-Right>"] = { "<cmd> vertical resize +1 <cr>", "Window width -1" },

    -- window split
    ["<C-x>"] = { "<cmd> sp <cr>", "Window split" },
    ["<C-y>"] = { "<cmd> vsp <cr>", "Window vertical split" },

    -- new tab
    ["<C-t>"] = { "<cmd> tabnew <cr>", "Tab new" },

    -- switch between tabs
    ["}"] = { "<cmd> tabn <cr>", "Tab next" },
    ["{"] = { "<cmd> tabp <cr>", "Tab prev" },
  },

  t = {
    ["<C-d>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), "Terminal escape" },
  },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", options = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", options = { expr = true } },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", options = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", options = { expr = true } },

    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<cr>:let @"=@0<cr>', "Dont copy replaced text", options = { silent = true } },
  },
}

M.tabline = {
  n = {
    -- cycle through buffers
    [">"] = {
      function()
        require("ui.tabline").next_buffer()
      end,
      "Buffer next",
    },

    ["<"] = {
      function()
        require("ui.tabline").prev_buffer()
      end,
      "Buffer prev",
    },

    ["_"] = {
      function()
        require("ui.tabline").move_buffer(-1)
      end,
      "Buffer move left",
    },

    ["+"] = {
      function()
        require("ui.tabline").move_buffer(1)
      end,
      "Buffer move right",
    },

    ["<S-c>"] = {
      function()
        require("ui.tabline").close_buffer()
      end,
      "Buffer close",
    },

    ["<C-q>"] = {
      function()
        require("ui.tabline").close_win()
      end,
      "Window close",
    },

    ["<C-c>"] = {
      function()
        require("ui.tabline").close_tab()
      end,
      "Tab close",
    },
  },
}

M.comment = {
  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd> lua require('Comment.api').toggle.linewise(vim.fn.visualmode()) <cr>",
      "Toggle comment",
    },
  },
}

M.lspconfig = {
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  n = {
    ["gh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },

    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "LSP definition",
    },

    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "LSP declaration",
    },

    ["gt"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "LSP type definition",
    },

    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },

    ["gr"] = {
      function()
        vim.lsp.buf.references()
      end,
      "LSP references",
    },

    ["gs"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "LSP signature",
    },

    ["<leader>dn"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "LSP diagnostic next",
    },

    ["<leader>dp"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "LSP diagnostic prev",
    },

    ["<leader>df"] = {
      function()
        vim.diagnostic.open_float({ border = "rounded" })
      end,
      "LSP diagnostic floating",
    },

    ["<leader>dl"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "LSP diagnostic list",
    },

    ["<leader>ra"] = {
      function()
        vim.lsp.buf.rename()
      end,
      "LSP rename",
    },

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      "LSP formatting",
    },

    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },

    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "LSP workspace list",
    },

    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "LSP workspace add",
    },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "LSP workspace remove",
    },
  },
}

M.nvimtree = {
  n = {
    -- toggle
    ["<C-e>"] = { "<cmd> NvimTreeToggle <cr>", "Nvim-tree toggle" },

    -- focus
    ["<C-f>"] = { "<cmd> NvimTreeFindFile! <cr>", "Nvim-tree Focus" },
  },
}

M.telescope = {
  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <cr>", "Find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <cr>", "Find all" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <cr>", "Find old files" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <cr>", "Find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <cr>", "Find Help page" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <cr>", "Live grep" },
    ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <cr>", "Fuzzy find in current buffer" },

    -- git
    ["<leader>gc"] = { "<cmd> Telescope git_commits <cr>", "Git commits" },
    ["<leader>gs"] = { "<cmd> Telescope git_status <cr>", "Git status" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <cr>", "Select themes" },
  },
}

M.gitsigns = {
  n = {
    ["<leader>hn"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Git next hunk",
      options = { expr = true },
    },

    ["<leader>hp"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Git prev hunk",
      options = { expr = true },
    },

    -- Actions
    ["<leader>hr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Git hunk reset",
    },

    ["<leader>hs"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Git hunk preview",
    },

    ["<leader>hb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Git hunk blame",
    },

    ["<leader>hd"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Git hunk deleted",
    },
  },
}

return M
