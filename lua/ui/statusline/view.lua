local M = {}

local modes = {
  ["n"] = { "NORMAL", "StNormalMode" },
  ["no"] = { "NORMAL (no)", "StNormalMode" },
  ["nov"] = { "NORMAL (nov)", "StNormalMode" },
  ["noV"] = { "NORMAL (noV)", "StNormalMode" },
  ["noCTRL-V"] = { "NORMAL", "StNormalMode" },
  ["niI"] = { "NORMAL i", "StNormalMode" },
  ["niR"] = { "NORMAL r", "StNormalMode" },
  ["niV"] = { "NORMAL v", "StNormalMode" },
  ["nt"] = { "NTERMINAL", "StNTerminalMode" },
  ["ntT"] = { "NTERMINAL (ntT)", "StNTerminalMode" },

  ["v"] = { "VISUAL", "StVisualMode" },
  ["vs"] = { "V-CHAR (Ctrl O)", "StVisualMode" },
  ["V"] = { "V-LINE", "StVisualMode" },
  ["Vs"] = { "V-LINE", "StVisualMode" },
  [""] = { "V-BLOCK", "StVisualMode" },

  ["i"] = { "INSERT", "StInsertMode" },
  ["ic"] = { "INSERT (completion)", "StInsertMode" },
  ["ix"] = { "INSERT completion", "StInsertMode" },

  ["t"] = { "TERMINAL", "StTerminalMode" },

  ["R"] = { "REPLACE", "StReplaceMode" },
  ["Rc"] = { "REPLACE (Rc)", "StReplaceMode" },
  ["Rx"] = { "REPLACEa (Rx)", "StReplaceMode" },
  ["Rv"] = { "V-REPLACE", "StReplaceMode" },
  ["Rvc"] = { "V-REPLACE (Rvc)", "StReplaceMode" },
  ["Rvx"] = { "V-REPLACE (Rvx)", "StReplaceMode" },

  ["s"] = { "SELECT", "StSelectMode" },
  ["S"] = { "S-LINE", "StSelectMode" },
  [""] = { "S-BLOCK", "StSelectMode" },
  ["c"] = { "COMMAND", "StCommandMode" },
  ["cv"] = { "COMMAND", "StCommandMode" },
  ["ce"] = { "COMMAND", "StCommandMode" },
  ["r"] = { "PROMPT", "StConfirmMode" },
  ["rm"] = { "MORE", "StConfirmMode" },
  ["r?"] = { "CONFIRM", "StConfirmMode" },
  ["x"] = { "CONFIRM", "StConfirmMode" },
  ["!"] = { "SHELL", "StTerminalMode" },
}

local mode = function()
  local m = vim.api.nvim_get_mode().mode
  return "%#" .. modes[m][2] .. "#" .. "  " .. modes[m][1] .. " "
end

local git = function()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return "%#StGitIcons#" .. " "
  end

  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0)
      and "  " .. git_status.added
    or ""

  local changed = (git_status.changed and git_status.changed ~= 0)
      and "  " .. git_status.changed
    or ""

  local removed = (git_status.removed and git_status.removed ~= 0)
      and "  " .. git_status.removed
    or ""

  local branch_name = "  " .. git_status.head

  return "%#StGitIcons#" .. branch_name .. added .. changed .. removed
end

local lsp_diagnostics = function()
  if not rawget(vim, "lsp") then
    return ""
  end

  local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local h = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local i = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  local errors = (e and e > 0) and ("%#StLspError#" .. " " .. e .. " ") or ""

  local warnings = (w and w > 0) and ("%#StLspWarning#" .. " " .. w .. " ")
    or ""

  local hints = (h and h > 0) and ("%#StLspHints#" .. "󰛩 " .. h .. " ") or ""

  local info = (i and i > 0) and ("%#StLspInfo#" .. "󰋼 " .. i .. " ") or ""

  return errors .. warnings .. hints .. info
end

local lsp_status = function()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_clients()) do
      if
        client.attached_buffers[vim.api.nvim_get_current_buf()]
        and client.name ~= "null-ls"
      then
        return vim.o.columns > 100
            and "%#StLspStatus#" .. "  " .. client.name .. " "
          or "  LSP "
      end
    end
  end
  return ""
end

local cwd = function()
  local dir_name = "%#StCwdText#"
    .. " "
    .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    .. " "

  return vim.o.columns > 85 and "%#StCwdIcon#" .. " 󰉋 " .. dir_name or ""
end

local cursor_position = function()
  local current_line = vim.fn.line(".")
  local total_line = vim.fn.line("$")

  local text = math.modf((current_line / total_line) * 100) .. tostring("%%")
  text = string.format("%4s", text)

  text = current_line == 1 and "Top" or text
  text = current_line == total_line and "Bot" or text

  return "%#StPosIcon#" .. "  " .. "%#StPosText#" .. " " .. text .. " "
end

M.build = function()
  return table.concat({
    mode(),
    git(),
    "%=",
    lsp_diagnostics(),
    lsp_status(),
    cwd(),
    cursor_position(),
  })
end

return M
