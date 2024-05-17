local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.del("n", "q", { buffer = bufnr })

  vim.keymap.del("n", "<C-k>", { buffer = bufnr })
  vim.keymap.set("n", "i", api.node.show_info_popup, opts("Info"))

  vim.keymap.del("n", "<C-v>", { buffer = bufnr })
  vim.keymap.set("n", "<C-y>", api.node.open.vertical, opts("Open: Vertical Split"))

  vim.keymap.del("n", "<C-]>", { buffer = bufnr })
  vim.keymap.set("n", "=", api.tree.change_root_to_node, opts("CD"))

  vim.keymap.del("n", "<2-LeftMouse>", { buffer = bufnr })
  vim.keymap.del("n", "<2-RightMouse>", { buffer = bufnr })
  vim.keymap.del("n", "<BS>", { buffer = bufnr })
  vim.keymap.del("n", "<CR>", { buffer = bufnr })
  vim.keymap.del("n", "<Tab>", { buffer = bufnr })
  vim.keymap.del("n", "<C-e>", { buffer = bufnr })
  vim.keymap.del("n", "<C-t>", { buffer = bufnr })
  vim.keymap.del("n", "<C-r>", { buffer = bufnr })
end

local options = {
  on_attach = my_on_attach,
  filters = {
    dotfiles = false,
  },
  disable_netrw = true,
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
      },
    },
  },
  renderer = {
    icons = {
      glyphs = {
        default = "󰈚",
      },
    },
  },
}

return options
