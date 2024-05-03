require("core")
require("core.utils").load_mappings("common")

local echo = function(str)
  vim.cmd("redraw")
  vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

local post_bootstrap = function()
  -- close previously opened lazy window
  vim.api.nvim_buf_delete(0, { force = true })

  vim.schedule(function()
    vim.cmd("MasonInstallAll")

    -- Keep track of which mason pkgs get installed
    local packages = table.concat(vim.g.mason_binaries_list, " ")

    require("mason-registry"):on("package:install:success", function(pkg)
      packages = string.gsub(packages, pkg.name:gsub("%-", "%%-"), "") -- rm package name

      -- Prompt to quik nvim after all pkgs are installed.
      if packages:match("%S") == nil then
        vim.schedule(function()
          vim.api.nvim_buf_delete(0, { force = true })
          echo("Bootstrap completed. Press ENTER to quick!")
          while vim.fn.getchar() ~= 13 do end
          vim.cmd("qa!")
        end)
      end
    end)
  end)
end

local bootstrap = function()
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazy_path) then
    -- clone lazy.nvim
    echo("  Installing lazy.nvim & plugins ...")
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazy_path })

    vim.opt.rtp:prepend(lazy_path)
    require("plugins")
    post_bootstrap()
  else
    vim.opt.rtp:prepend(lazy_path)
    require("plugins")
  end
end

-- local open_nvim_tree = function(data)
--   local winid = vim.fn.bufwinid(data.buf)
--
--   -- buffer is a directory
--   local directory = vim.fn.isdirectory(data.file) == 1
--
--   -- change to the directory
--   if directory then
--     vim.cmd.cd(data.file)
--   end
--
--   -- open the tree
--   require("nvim-tree.api").tree.open()
--
--   -- restore focus
--   if winid >= 0 then
--     vim.api.nvim_set_current_win(winid)
--   end
-- end
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

require("base46").compile()
bootstrap()
require("ui")
