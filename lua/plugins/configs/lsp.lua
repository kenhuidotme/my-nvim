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
      -- severity = { min = vim.diagnostic.severity.ERROR },
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
  if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
    return
  end
end

-- Lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
local lua_ls_setup = function()
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

-- Typescript
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
local tsserver_setup = function()
  require('lspconfig').tsserver.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- clangd
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
local clangd_setup = function()
  require('lspconfig').clangd.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- CMake
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#neocmake
local neocmake_setup = function()
  require('lspconfig').neocmake.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Rust
-- https://rust-analyzer.github.io/manual.html#configuration
local rust_analyzer_setup = function()
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
        procMacro = {
          enable = true,
        },
        check = {
          command = "clippy",
        },
      },
    },
  })
end

-- zls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#zls
local zls_setup = function()
  require('lspconfig').zls.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

local M = {}

M.setup = function()
  lsp_client_setup()
  lua_ls_setup()
  tsserver_setup()
  clangd_setup()
  neocmake_setup()
  rust_analyzer_setup()
  zls_setup()
end

local wgsl_filetype_setup = function ()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.wgsl",
    callback = function()
      vim.bo.filetype = "wgsl"
    end,
  })
end

local gn_filetype_setup = function ()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.gn",
    callback = function()
      vim.bo.filetype = "gn"
    end,
  })
end

local filetype_setup = function ()
  wgsl_filetype_setup()
  gn_filetype_setup()
end

M.init = function()
  filetype_setup()
end

return M
