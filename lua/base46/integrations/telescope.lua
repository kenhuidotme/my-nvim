local base30 = require("base46").get_theme_tbl("base_30")

local highlights = {
  TelescopeNormal = { bg = base30.darker_black },
  TelescopePromptTitle = { fg = base30.black, bg = base30.red },
  TelescopePromptPrefix = { fg = base30.red, bg = base30.black2 },
  TelescopePreviewTitle = { fg = base30.black, bg = base30.green },

  TelescopeSelection = { bg = base30.grey, fg = base30.white },
  TelescopeResultsDiffAdd = { fg = base30.green },
  TelescopeResultsDiffChange = { fg = base30.yellow },
  TelescopeResultsDiffDelete = { fg = base30.red },

  -- borderless
  -- TelescopeBorder = { fg = base30.darker_black, bg = base30.darker_black },
  -- TelescopePromptBorder = { fg = base30.black2, bg = base30.black2 },

  -- bordered
  TelescopeBorder = { fg = base30.one_bg3 },
  TelescopePromptBorder = { fg = base30.one_bg3 },

  TelescopePromptNormal = { fg = base30.white, bg = base30.black2 },
  TelescopeResultsTitle = { fg = base30.darker_black, bg = base30.darker_black },
}

return highlights
