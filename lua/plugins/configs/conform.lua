local prettier_supported = {
  "css",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "markdown",
  "markdown.mdx",
  "typescript",
  "typescriptreact",
  "yaml",
}

local prettier_has_config = function(ctx)
  if vim.fn.executable('prettier') == 1 then
    vim.fn.system({ "prettier", "--find-config-path", ctx.filename })
    return vim.v.shell_error == 0
  end
  return false
end

local prettier_setup = function(opts)
  opts.formatters_by_ft = opts.formatters_by_ft or {}
  for _, ft in ipairs(prettier_supported) do
    opts.formatters_by_ft[ft] = { "prettier" }
  end

  opts.formatters = opts.formatters or {}
  opts.formatters.prettier = {
    condition = function(_, ctx)
      local ft = vim.bo[ctx.buf].filetype
      return vim.tbl_contains(prettier_supported, ft) and prettier_has_config(ctx)
    end,
  }
end

local opts = {
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
}

local M = {}

M.setup = function()
  prettier_setup(opts)
  require("conform").setup(opts)
end

return M
