local prettier_supported = {
  "css",
  "graphql",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

local opts = {
  formatters_by_ft = {
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
