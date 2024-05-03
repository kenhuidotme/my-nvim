local config = require("core.config")

-- globals
vim.g.theme = config.ui.theme
vim.g.transparency = config.ui.transparency
vim.g.base46_cache = vim.fn.stdpath("data") .. "/MyNvim/base46/"

-- global statusline
vim.opt.laststatus = 3

vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.clipboard = ""
vim.opt.cursorline = true

-- Indenting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.fillchars = { eob = " " }
-- vim.opt.mouse = "a"
vim.opt.mouse = ""

-- Numbers
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.ruler = false

-- disable nvim intro
vim.opt.shortmess:append "sI"

vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 400
vim.opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
vim.opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append "<>[]hl"

vim.g.mapleader = " "

-- disable some default mappings
vim.api.nvim_set_keymap("n", "<C-i>", "", { noremap = true, silent = true })

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH =
  vim.env.PATH
  .. (is_windows and ";" or ":")
  .. vim.fn.stdpath("data")
  .. "/mason/bin"

-- dont list quickfix buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})
