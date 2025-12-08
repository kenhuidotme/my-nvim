-- thx to https://gitlab.com/ranjithshegde/dotbare/-/blob/master/.config/nvim/lua/lsp/init.lua
local M = {}

local check_trigger_char = function(line_to_cursor, triggers)
  for _, trigger_char in ipairs(triggers) do
    local current_char = line_to_cursor:sub(#line_to_cursor, #line_to_cursor)
    local prev_char =
      line_to_cursor:sub(#line_to_cursor - 1, #line_to_cursor - 1)
    if current_char == trigger_char then
      return true
    end
    if current_char == " " and prev_char == trigger_char then
      return true
    end
  end
  return false
end

-- thx to https://github.com/seblj/dotfiles/blob/0542cae6cd9a2a8cbddbb733f4f65155e6d20edf/nvim/lua/config/lspconfig/init.lua
local clients = {}

local open_signature = function()
  local triggered = false

  for _, client in pairs(clients) do
    if triggered then
      break
    end

    local triggers =
      client.server_capabilities.signatureHelpProvider.triggerCharacters

    if triggers then
      -- csharp has wrong trigger chars for some odd reason
      if client.name == "csharp" then
        triggers = { "(", "," }
      end

      local pos = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local line_to_cursor = line:sub(1, pos[2])

      triggered = check_trigger_char(line_to_cursor, triggers)
    end
  end

  if triggered then
    local params = require("vim.lsp.util").make_position_params()
    vim.lsp.buf_request(
      0,
      "textDocument/signatureHelp",
      params,
      vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
      })
    )
  end
end

M.setup = function(client)
  if not vim.tbl_contains(vim.tbl_keys(clients), client.id) then
    clients[client.id] = client
  end

  local group = vim.api.nvim_create_augroup("LspSignature", { clear = false })

  vim.api.nvim_clear_autocmds({ group = group, pattern = "<buffer>" })

  vim.api.nvim_create_autocmd("TextChangedI", {
    group = group,
    pattern = "<buffer>",
    callback = function()
      local active_clients = vim.lsp.get_clients()
      if #active_clients < 1 then
        return
      end
      open_signature()
    end,
  })
end

return M
