-- credits to original theme for existing https://github.com/nealmckee/penumbra
-- this is a modified version of it

local M = {}

M.base_30 = {
  white = "#3E4044",
  darker_black = "#f5ede3",
  black = "#FFF7ED",
  black2 = "#f0e8de",
  one_bg = "#F2E6D4",
  one_bg2 = "#e6ded4",
  one_bg3 = "#dad2c8",
  grey = "#cec6bc",
  grey_fg = "#c4bcb2",
  grey_fg2 = "#bab2a8",
  light_grey = "#b0a89e",
  red = "#ca7081",
  baby_pink = "#CA736C",
  pink = "#CA7081",
  line = "#ebe3d9",
  green = "#3ea57b",
  vibrant_green = "#46A473",
  blue = "#6E8DD5",
  nord_blue = "#5794D0",
  yellow = "#92963a",
  sun = "#A38F2D",
  purple = "#ac78bd",
  dark_purple = "#806db8",
  teal = "#22839b",
  orange = "#BA823A",
  cyan = "#00A0BA",
  statusline_bg = "#f5ede3",
  lightbg = "#e6ded4",
  pmenu_bg = "#ac78bd",
  folder_bg = "#717171",
  coal = "#8a8a8a",
}

M.base_16 = {
  base00 = "#FFF7ED",
  base01 = "#FFF7ED",
  base02 = "#F2E6D4",
  base03 = "#CECECE",
  base04 = "#9E9E9E",
  base05 = "#636363",
  base06 = "#3E4044",
  base07 = "#24272B",
  base08 = "#ca7081",
  base09 = "#5a79c1",
  base0A = "#BA823A",
  base0B = "#3ea57b",
  base0C = "#22839b",
  base0D = "#4380bc",
  base0E = "#ac78bd",
  base0F = "#A1A641",
}

M.polish_hl = {
  Constant = { fg = M.base_30.red },
  Include = { fg = M.base_30.dark_purple },
  ["@function.builtin"] = { fg = M.base_30.teal },
  ["@field.key"] = { fg = M.base_30.red },
  ["@punctuation.bracket"] = { fg = M.base_30.coal },
  ["@field"] = { fg = M.base_30.coal },
}

M.type = "light"

return M
