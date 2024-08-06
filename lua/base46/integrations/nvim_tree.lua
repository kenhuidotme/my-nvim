local base30 = require("base46").get_theme_tbl("base_30")

return {
  NvimTreeEmptyFolderName = { fg = base30.folder_bg },
  NvimTreeEndOfBuffer = { fg = base30.darker_black },
  NvimTreeFolderIcon = { fg = base30.folder_bg },
  NvimTreeFolderName = { fg = base30.folder_bg },
  NvimTreeGitDirty = { fg = base30.red },
  NvimTreeIndentMarker = { fg = base30.grey_fg },
  NvimTreeNormal = { bg = base30.darker_black },
  NvimTreeNormalNC = { bg = base30.darker_black },
  NvimTreeOpenedFolderName = { fg = base30.folder_bg },
  NvimTreeGitIgnored = { fg = base30.light_grey },

  NvimTreeWinSeparator = {
    fg = base30.darker_black,
    bg = base30.darker_black,
  },

  NvimTreeWindowPicker = {
    fg = base30.red,
    bg = base30.black2,
  },

  NvimTreeCursorLine = {
    bg = base30.black2,
  },

  NvimTreeGitNew = {
    fg = base30.yellow,
  },

  NvimTreeGitDeleted = {
    fg = base30.red,
  },

  NvimTreeSpecialFile = {
    fg = base30.yellow,
    bold = true,
  },

  NvimTreeExecFile = {
    fg = base30.green,
  },

  NvimTreeRootFolder = {
    fg = base30.light_grey,
  },
}
