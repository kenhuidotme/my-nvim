local lsp_symbol = function(name, icon)
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

local lsp_client_setup = function()
  lsp_symbol("Error", "󰅙")
  lsp_symbol("Info", "󰋼")
  lsp_symbol("Hint", "󰌵")
  lsp_symbol("Warn", "")

  vim.diagnostic.config({
    float = {
      border = "single",
    },
    virtual_text = {
      spacing = 2,
      prefix = "",
      severity = { min = vim.diagnostic.severity.ERROR },
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
      relative = "cursor",
      focusable = false,
    })
end

local on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local on_attach = function(client, bufnr)
  require("core.utils").load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("ui.lsp.signature").setup(client)
  end
end

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  snippetSupport = true,
  commitCharactersSupport = true,
  documentationFormat = { "markdown", "plaintext" },
  deprecatedSupport = true,
  preselectSupport = true,
  tagSupport = { valueSet = { 1 } },
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
  insertTextModeSupport = { valueSet = { 1 } },
}

local lua_server_on_init = function(client)
  on_init(client)
  local path = client.workspace_folders[1].name
  if vim.loop.fs_stat(path.."/.luarc.json") or vim.loop.fs_stat(path.."/.luarc.jsonc") then
    return
  end
end

-- Lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
local lua_server_setup = function()
  require("lspconfig").lua_ls.setup({
    on_init = lua_server_on_init,
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
end

-- Rust
-- https://rust-analyzer.github.io/manual.html#nvim-lsp
local rust_server_setup = function()
  require("lspconfig").rust_analyzer.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  })
end

local M = {}

M.setup = function()
  lsp_client_setup()
  lua_server_setup()
  rust_server_setup()
end

return M
