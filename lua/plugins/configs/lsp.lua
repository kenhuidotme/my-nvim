local lsp_symbol = function(name, icon)
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

local lsp_config = function()
  lsp_symbol("Error", "󰅙")
  lsp_symbol("Info", "󰋼")
  lsp_symbol("Hint", "󰌵")
  lsp_symbol("Warn", "")

  vim.diagnostic.config({
    virtual_text = {
      prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
  })

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
    })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
      focusable = false,
      relative = "cursor",
    })

  -- Borders for LspInfo winodw
  local win = require("lspconfig.ui.windows")
  local _default_opts = win.default_opts

  win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = "single"
    return opts
  end
end

local on_attach = function(client, bufnr)
  require("core.utils").load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("ui.lsp.signature").setup(client)
  end

  -- needs nvim v0.9
  if vim.version().api_level >= 11 then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local M = {}


M.setup = function()
  lsp_config()

  local lspconfig = require("lspconfig")

  -- Lua
  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
        },
      },
    },
  })

  -- Typescript
  --
  lspconfig.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Rust
  -- https://rust-analyzer.github.io/manual.html#nvim-lsp
  lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true
        },
      }
    }
  })

end

return M
