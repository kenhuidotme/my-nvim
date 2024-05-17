require("core")
require("core.utils").load_mappings("common")

local echo = function(str)
  vim.cmd("redraw")
  vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

local bootstrap = function()
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazy_path) then
    echo("  Installing lazy.nvim & plugins ...")
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazy_path })
  end
  vim.opt.rtp:prepend(lazy_path)
  require("plugins")
end

require("base46").compile()
bootstrap()
require("ui")
