local M = {}

M.load = function()
  vim.opt.statusline = "%!v:lua.require('ui.statusline.view').build()"
end

return M
