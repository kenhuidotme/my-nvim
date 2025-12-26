local cmp = require("cmp")

local lspkind_icons = {
  Namespace = "󰌗",
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰆧",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈚",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
  Table = "",
  Object = "󰅩",
  Tag = "",
  Array = "[]",
  Boolean = "",
  Number = "",
  Null = "󰟢",
  String = "󰉿",
  Calendar = "",
  Watch = "󰥔",
  Package = "",
  Copilot = "",
  Codeium = "",
  TabNine = "",
}

local formatting_style = {
  fields = { "abbr", "kind", "menu" },
  format = function(_, item)
    local icon = lspkind_icons[item.kind]
    if icon then
      item.kind = " " .. icon .. "  " .. item.kind
    end
    return item
  end,
}

local function gen_border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local opts = {
  completion = {
    completeopt = "menu,menuone",
  },

  window = {
    completion = {
      side_padding = 1,
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
      scrollbar = false,
      border = gen_border("CmpBorder"),
    },
    documentation = {
      border = gen_border("CmpDocBorder"),
      winhighlight = "Normal:CmpDoc",
    },
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = formatting_style,

  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping.confirm({
      select = true,
      behavior = cmp.SelectBehavior.Insert,
    }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
  },
  sources = cmp.config.sources({
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lua" },
    { name = "buffer" },
    { name = "path" },
  }),
}

-- Configuration for ':' command-line
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" }, -- Source for file paths
  }, {
    {
      name = "cmdline", -- Source for actual Ex commands
      option = {
        ignore_cmds = { "Man", "!" }, -- Example: ignore completions for these commands
      },
    },
  }),
})

-- Configuration for '/' and '?' search command-line
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }, -- Source for words in the current buffer
  },
})

return opts
