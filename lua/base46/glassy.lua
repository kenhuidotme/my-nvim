local colors = require("base46").get_theme_tb("base_30")

local M = {
  NvimTreeWinSeparator = {
    fg = colors.one_bg2,
    bg = "none",
  },

  TelescopeResultsTitle = {
    fg = colors.black,
    bg = colors.blue,
  },
}

-- for hl groups which need bg = "none" only!
local hl_groups = {
  "NormalFloat",
  "Normal",
  "Folded",
  "NvimTreeNormal",
  "NvimTreeNormalNC",
  "NvimTreeCursorLine",
  "TelescopeNormal",
  "TelescopePrompt",
  "TelescopeResults",
  "TelescopePromptNormal",
  "TelescopePromptPrefix",
  "CursorLine",
  "Pmenu",
  "CmpPmenu",
}

for _, groups in ipairs(hl_groups) do
  M[groups] = {
    bg = "none",
  }
end

M.TelescopeBorder = {
  fg = colors.grey,
  bg = "none",
}

M.TelescopePromptBorder = {
  fg = colors.grey,
  bg = "none",
}

M.CmpDocBorder = {
  fg = colors.grey,
  bg = "none",
}

return M
