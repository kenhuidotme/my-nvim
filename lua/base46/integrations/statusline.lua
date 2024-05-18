local base30 = require("base46").get_theme_tbl("base_30")

local lsp_highlights = {
  StLspError = {
    fg = base30.red,
    bg = base30.statusline_bg,
  },

  StLspWarning = {
    fg = base30.yellow,
    bg = base30.statusline_bg,
  },

  StLspHints = {
    fg = base30.purple,
    bg = base30.statusline_bg,
  },

  StLspInfo = {
    fg = base30.green,
    bg = base30.statusline_bg,
  },
}

local highlights = {
  StGitIcons = {
    fg = base30.light_grey,
    bg = base30.statusline_bg,
    bold = true,
  },

  StLspStatus = {
    fg = base30.nord_blue,
    bg = base30.statusline_bg,
  },

  StFileInfo = {
    fg = base30.white,
    bg = base30.lightbg,
  },

  StCwdIcon = {
    fg = base30.one_bg,
    bg = base30.red,
  },

  StCwdText = {
    fg = base30.white,
    bg = base30.lightbg,
  },

  StPosIcon = {
    fg = base30.black,
    bg = base30.green,
  },

  StPosText = {
    fg = base30.green,
    bg = base30.lightbg,
  },
}

highlights = vim.tbl_deep_extend("force", highlights, lsp_highlights)

local add_mode_highlights = function(mode, col)
  highlights["St" .. mode .. "Mode"] = { fg = base30.black, bg = base30[col], bold = true }
end

-- add mode highlights
add_mode_highlights("Normal", "nord_blue")
add_mode_highlights("Visual", "cyan")
add_mode_highlights("Insert", "dark_purple")
add_mode_highlights("Terminal", "green")
add_mode_highlights("NTerminal", "yellow")
add_mode_highlights("Replace", "orange")
add_mode_highlights("Confirm", "teal")
add_mode_highlights("Command", "green")
add_mode_highlights("Select", "blue")

return highlights
