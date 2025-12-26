local g = vim.g
local o = vim.o
local fn = vim.fn
local opt = vim.opt
local api = vim.api

local utils = require("core.utils")

-- globals
g.theme = utils.get_theme("onedark")
g.transparency = false
g.colorcolumn = "80"
g.base46_cache = fn.stdpath("data") .. "/MyNvim/base46/"

-- gui
o.termguicolors = true

o.laststatus = 3
o.showcmd = false
o.showmode = false
o.cursorline = true
o.clipboard = ""
-- o.clipboard = "unnamedplus"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

opt.fillchars = { eob = " " }
o.mouse = "a"

-- o.number = false
-- o.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

g.mapleader = " "

-- disable some default providers
g["loaded_node_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_ruby_provider"] = 0

-- powershell on Windows
local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
if is_windows then
  local powershell_options = {
    shell = fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    o[option] = value
  end
end

-- disable some default mappings
api.nvim_set_keymap("n", "<C-i>", "", { noremap = true, silent = true })
