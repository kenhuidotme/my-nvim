local M = {}

local escape_terminal_code = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true)

M.common = {
  i = {
    ["<C-v>"] = { '<Esc>"+p', "Paste text from clipboard" },
    ["<C-s>"] = { "<Cmd>w<CR>", "Save file" },

    -- go to beginning and end
    ["<C-b>"] = { "<Esc>^i", "Beginning of line" },
    ["<C-e>"] = { "<End>", "End of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  },

  n = {
    ["<C-s>"] = { "<Cmd>w<CR>", "Save file" },
    ["<Esc>"] = { "<Cmd>noh<CR>", "Clear highlights" },

    -- line numbers
    ["<leader>n"] = { "<Cmd>set nu!<CR>", "Toggle line number" },
    ["<leader>rn"] = { "<Cmd>set rnu!<CR>", "Toggle relative number" },

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
    ["<S-b>"] = { "<Cmd>enew<CR>", "Buffer new" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "Window jump left" },
    ["<C-l>"] = { "<C-w>l", "Window jump right" },
    ["<C-j>"] = { "<C-w>j", "Window jump down" },
    ["<C-k>"] = { "<C-w>k", "Window jump up" },

    -- window resize
    ["<C-Up>"] = { "<Cmd>resize -1<CR>", "Window height -1" },
    ["<C-Down>"] = { "<Cmd>resize +1<CR>", "Window height +1" },
    ["<C-Left>"] = { "<Cmd>vertical resize -1<CR>", "Window width +1" },
    ["<C-Right>"] = { "<Cmd>vertical resize +1<CR>", "Window width -1" },

    -- window split
    ["<C-x>"] = { "<Cmd>sp<CR>", "Window split" },
    ["<C-y>"] = { "<Cmd>vsp<CR>", "Window vertical split" },

    -- new tab
    ["<S-t>"] = { "<Cmd>tabnew<CR>", "Tab new" },

    -- switch between tabs
    ["}"] = { "<Cmd>tabn<CR>", "Tab next" },
    ["{"] = { "<Cmd>tabp<CR>", "Tab prev" },
  },

  t = {
    ["<C-d>"] = { escape_terminal_code, "Terminal escape" },
  },

  v = {
    ["<C-c>"] = { '"+y', "Copy selected text to clipboard" },

    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", options = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", options = { expr = true } },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", options = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", options = { expr = true } },

    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", options = { silent = true } },
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

    ["<S-q>"] = {
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
      "<Esc><Cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
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

    ["<leader>dl"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "LSP diagnostic list",
    },

    ["<leader>df"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "LSP diagnostic floating",
    },

    ["<leader>dt"] = {
      function()
        require("core.utils").toggle_diagnostics()
      end,
      "Toggle diagnostics",
    },

    ["<leader>da"] = {
      function()
        require("core.utils").toggle_diagnostics(true)
      end,
      "Toggle diagnostics all buffers",
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
    ["<C-e>"] = { function () vim.cmd("NvimTreeToggle") end, "Nvim-tree toggle" },
  },
  t = {
    ["<C-e>"] = { function () vim.cmd("NvimTreeToggle") end, "Nvim-tree toggle" },
  },
}

M.telescope = {
  n = {
    -- find
    ["<leader>ff"] = { "<Cmd>Telescope find_files<CR>", "Find files" },
    ["<leader>fa"] = { "<Cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", "Find all" },
    ["<leader>fo"] = { "<Cmd>Telescope oldfiles<CR>", "Find old files" },
    ["<leader>fb"] = { "<Cmd>Telescope buffers<CR>", "Find buffers" },
    ["<leader>fh"] = { "<Cmd>Telescope help_tags<CR>", "Find Help page" },
    ["<leader>fw"] = { "<Cmd>Telescope live_grep<CR>", "Live grep" },
    ["<leader>fz"] = { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy find in current buffer" },

    -- git
    ["<leader>st"] = { "<Cmd>Telescope git_status<CR>", "Git status" },
    ["<leader>cm"] = { "<Cmd>Telescope git_commits<CR>", "Git commits" },

    -- theme switcher
    ["<leader>th"] = { "<Cmd>Telescope themes<CR>", "Select themes" },
  },
}

M.toggleterm = {
  n = {
    ["<C-t>"] = {
      function()
        require("core.utils").toggle_term()
      end,
      "Toggle horizontal terminal"
    },
    ["<C-f>"] = {
      function()
        require("core.utils").toggle_float_term()
      end,
      "Toggle float terminal"
    },
  },
  t = {
    ["<C-t>"] = {
      function()
        require("core.utils").toggle_term()
      end,
      "Toggle horizontal terminal"
    },
    ["<C-f>"] = {
      function()
        require("core.utils").toggle_float_term()
      end,
      "Toggle float terminal"
    },
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

    ["<leader>hv"] = {
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
