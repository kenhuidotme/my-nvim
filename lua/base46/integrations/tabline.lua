local base30 = require("base46").get_theme_tbl("base_30")

return {
  TlFill = {
    bg = base30.black2,
  },

  TlBufOn = {
    fg = base30.white,
    bg = base30.black,
  },

  TlBufOff = {
    fg = base30.light_grey,
    bg = base30.black2,
  },

  TlBufOnModified = {
    fg = base30.green,
    bg = base30.black,
  },

  TlBufOffModified = {
    fg = base30.light_grey,
    bg = base30.black2,
  },

  TlBufOnClose = {
    fg = base30.red,
    bg = base30.black,
  },

  TlBufOffClose = {
    fg = base30.light_grey,
    bg = base30.black2,
  },

  TlTabOn = {
    fg = base30.black,
    bg = base30.nord_blue,
    bold = true,
  },

  TlTabOff = {
    fg = base30.white,
    bg = base30.one_bg2,
  },

  TlTabOnClose = {
    fg = base30.black,
    bg = base30.nord_blue,
  },
}
