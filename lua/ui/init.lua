dofile(vim.g.base46_cache .. "defaults")
require("base46.terminal").load()

dofile(vim.g.base46_cache .. "statusline")
require("ui.statusline").load()

dofile(vim.g.base46_cache .. "tabline")
require("ui.tabline").load()
