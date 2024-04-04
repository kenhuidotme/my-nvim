local base16 = require("base46").get_theme_tbl("base_16")
local base30 = require("base46").get_theme_tbl("base_30")

local highlights = {
  CmpBorder = { fg = base30.grey_fg },
  CmpItemAbbr = { fg = base30.white },
  CmpItemAbbrMatch = { fg = base30.blue, bold = true },
  CmpDoc = { bg = base30.darker_black },
  CmpDocBorder = { fg = base30.darker_black, bg = base30.darker_black },
  CmpPmenu = { bg = base30.black },
  CmpSel = { link = "PmenuSel", bold = true },
}

local item_kinds = {
  -- cmp item kinds
  CmpItemKindConstant = { fg = base16.base09 },
  CmpItemKindFunction = { fg = base16.base0D },
  CmpItemKindIdentifier = { fg = base16.base08 },
  CmpItemKindField = { fg = base16.base08 },
  CmpItemKindVariable = { fg = base16.base0E },
  CmpItemKindSnippet = { fg = base30.red },
  CmpItemKindText = { fg = base16.base0B },
  CmpItemKindStructure = { fg = base16.base0E },
  CmpItemKindType = { fg = base16.base0A },
  CmpItemKindKeyword = { fg = base16.base07 },
  CmpItemKindMethod = { fg = base16.base0D },
  CmpItemKindConstructor = { fg = base30.blue },
  CmpItemKindFolder = { fg = base16.base07 },
  CmpItemKindModule = { fg = base16.base0A },
  CmpItemKindProperty = { fg = base16.base08 },
  CmpItemKindEnum = { fg = base30.blue },
  CmpItemKindUnit = { fg = base16.base0E },
  CmpItemKindClass = { fg = base30.teal },
  CmpItemKindFile = { fg = base16.base07 },
  CmpItemKindInterface = { fg = base30.green },
  CmpItemKindColor = { fg = base30.white },
  CmpItemKindReference = { fg = base16.base05 },
  CmpItemKindEnumMember = { fg = base30.purple },
  CmpItemKindStruct = { fg = base16.base0E },
  CmpItemKindValue = { fg = base30.cyan },
  CmpItemKindEvent = { fg = base30.yellow },
  CmpItemKindOperator = { fg = base16.base05 },
  CmpItemKindTypeParameter = { fg = base16.base08 },
  CmpItemKindCopilot = { fg = base30.green },
}

highlights = vim.tbl_deep_extend("force", highlights, item_kinds)

return highlights
