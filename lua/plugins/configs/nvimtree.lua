local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function options(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.del("n", "g?", { buffer = bufnr })
  vim.keymap.set("n", "?", api.tree.toggle_help, options("Help"))

  vim.keymap.del("n", "<C-k>", { buffer = bufnr })
  vim.keymap.set("n", "i", api.node.show_info_popup, options("Info"))

  vim.keymap.del("n", "<C-v>", { buffer = bufnr })
  vim.keymap.set(
    "n",
    "<C-y>",
    api.node.open.vertical,
    options("Open: Vertical Split")
  )

  vim.keymap.del("n", "<C-]>", { buffer = bufnr })
  vim.keymap.set("n", "=", api.tree.change_root_to_node, options("CD"))

  vim.keymap.del("n", "<Tab>", { buffer = bufnr })
  vim.keymap.del("n", "<C-t>", { buffer = bufnr })
  vim.keymap.del("n", "<C-e>", { buffer = bufnr })

  vim.keymap.set("n", "<Esc>", api.tree.close, options("Close"))
end

-- https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
local opts = {
  on_attach = my_on_attach,
  filters = {
    git_ignored = false,
  },
  disable_netrw = true,
  hijack_directories = {
    enable = false,
  },
  view = {
    side = "left",
    preserve_window_proportions = true,
    width = {
      max = -1,
    },
    float = {
      enable = true,
      open_win_config = {
        border = "single",
        height = math.floor(vim.o.lines * 0.6),
      },
    },
  },
  renderer = {
    root_folder_label = function(path)
      return ".../" .. vim.fn.fnamemodify(path, ":t")
    end,
    icons = {
      git_placement = "after",
      glyphs = {
        default = "󰈚",
      },
    },
  },
}

local M = {}

M.setup = function()
  vim.g.nvimtree_side = opts.view.side
  require("nvim-tree").setup(opts)
end

return M
