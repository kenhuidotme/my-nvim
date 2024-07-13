local supported = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

local opts = {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
}

for _, ft in ipairs(supported) do
  opts.formatters_by_ft[ft] = { "prettierd", "prettier" }
end

return opts
