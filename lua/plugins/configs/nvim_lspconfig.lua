local lsp_client_setup = function()
  vim.diagnostic.config({
    float = {
      border = "single",
    },
    virtual_text = {
      spacing = 2,
      prefix = "",
      -- severity = { min = vim.diagnostic.severity.ERROR },
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅙",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "󰋼",
        [vim.diagnostic.severity.HINT] = "󰌵",
      },
      linehl = {
        [vim.diagnostic.severity.ERROR] = "Error",
        [vim.diagnostic.severity.WARN] = "Warn",
        [vim.diagnostic.severity.INFO] = "Info",
        [vim.diagnostic.severity.HINT] = "Hint",
      },
    },
    underline = true,
    update_in_insert = false,
  })
end

local on_attach_common = function(_, bufnr)
  require("core.utils").load_mappings("nvim_lspconfig", { buffer = bufnr })
end

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_completion
local capabilities_common = vim.lsp.protocol.make_client_capabilities()
capabilities_common.textDocument.completion.completionItem = {
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
  if client.workspace_folders then
    local path = client.workspace_folders[1].name
    if
      vim.uv.fs_stat(path .. "/.luarc.json")
      or vim.uv.fs_stat(path .. "/.luarc.jsonc")
    then
      return
    end
  end
end

-- Lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
local lua_ls_setup = function()
  vim.lsp.config("lua_ls", {
    on_init = lua_server_on_init,
    on_attach = on_attach_common,
    capabilities = capabilities_common,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
            ["${3rd}/luv/library"] = true,
          },
        },
      },
    },
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      ".emmyrc.json",
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
  })
  vim.lsp.enable("lua_ls")
end

-- pyright
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pyright
local pyright_setup = function()
  require("lspconfig").pyright.setup({
    on_attach = on_attach_common,
    capabilities = capabilities_common,
  })
end

-- Typescript
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
local ts_ls_setup = function()
  require("lspconfig").ts_ls.setup({
    on_attach = on_attach_common,
    capabilities = capabilities_common,
  })
end

-- tailwindcss
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tailwindcss
local tailwindcss_setup = function()
  require("lspconfig").tailwindcss.setup({
    on_attach = on_attach_common,
    capabilities = capabilities_common,
  })
end

-- clangd
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#clangd
local clangd_setup = function()
  require("lspconfig").clangd.setup({
    on_attach = on_attach_common,
    capabilities = capabilities_common,
  })
end

-- CMake
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#neocmake
local neocmake_setup = function()
  require("lspconfig").neocmake.setup({
    on_attach = on_attach_common,
    capabilities = capabilities_common,
  })
end

-- Rust
-- https://rust-analyzer.github.io/manual.html#configuration
local rust_analyzer_setup = function()
  require("lspconfig").rust_analyzer.setup({
    on_attach = on_attach_common,
    capabilities = capabilities_common,
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

-- taplo
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#taplo
local taplo_setup = function()
  require("lspconfig").taplo.setup({
    on_attach = on_attach_common,
    capabilities = capabilities_common,
  })
end

local lsp_server_setup = function()
  -- lua_ls_setup()
  -- pyright_setup()
  -- ts_ls_setup()
  -- tailwindcss_setup()
  -- clangd_setup()
  -- neocmake_setup()
  -- rust_analyzer_setup()
  -- taplo_setup()
end

local wgsl_filetype_setup = function()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.wgsl",
    callback = function()
      vim.bo.filetype = "wgsl"
    end,
  })
end

local gn_filetype_setup = function()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.gn", "*.gni" },
    callback = function()
      vim.bo.filetype = "gn"
    end,
  })
end

local ninja_filetype_setup = function()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.ninja",
    callback = function()
      vim.bo.filetype = "ninja"
    end,
  })
end

local filetype_setup = function()
  wgsl_filetype_setup()
  gn_filetype_setup()
  ninja_filetype_setup()
end

local M = {}

M.setup = function()
  lsp_client_setup()
  lsp_server_setup()
end

M.init = function()
  filetype_setup()
end

return M
