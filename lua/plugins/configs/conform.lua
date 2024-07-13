local prettier_supported = {
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
    -- go install mvdan.cc/sh/v3/cmd/gosh@latest
    sh = { "shfmt" },
    -- cargo install stylua
    lua = { "stylua" },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
}

-- npm install -g @fsouza/prettierd
for _, ft in ipairs(prettier_supported) do
  opts.formatters_by_ft[ft] = { "prettierd" }
end

return opts
