local prettier_supported = {
  "css",
  "graphql",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

local opts = {
  formatters_by_ft = {
    -- go install mvdan.cc/sh/v3/cmd/shfmt@latest
    sh = { "shfmt" },
    -- cargo install stylua
    lua = { "stylua" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
}

-- npm install -g prettier
for _, ft in ipairs(prettier_supported) do
  opts.formatters_by_ft[ft] = { "prettier" }
end

return opts
