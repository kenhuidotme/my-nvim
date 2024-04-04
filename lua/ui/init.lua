dofile(vim.g.base46_cache .. "defaults")

require("base46.terminal").load()

local config = require("core.config").ui

if not config.statusline.disabled then
  dofile(vim.g.base46_cache .. "statusline")
  require("ui.statusline").load()
end

if not config.tabline.disabled then
  dofile(vim.g.base46_cache .. "tabline")
  require("ui.tabline").load()
end
