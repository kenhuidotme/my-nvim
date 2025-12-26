local M = {}

M.load_mappings = function(section, mapping_options)
  vim.schedule(function()
    local mappings = require("core.mappings")
    local section_values = mappings[section]
    if not section_values then
      return
    end

    for mode, mode_values in pairs(section_values) do
      for key_bind, mapping_info in pairs(mode_values) do
        local options = vim.tbl_deep_extend(
          "force",
          mapping_options or {},
          mapping_info.options or {}
        )
        options.desc = mapping_info[2]
        vim.keymap.set(mode, key_bind, mapping_info[1], options)
      end
    end
  end)
end

M.list_themes = function()
  local themes =
    vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/base46/themes")
  for index, theme in ipairs(themes) do
    themes[index] = theme:match("(.+)%..+")
  end
  return themes
end

M.get_theme = function(default)
  local theme_file = vim.fn.stdpath("state") .. "/mynvim_theme"
  local file = io.open(theme_file, "r")
  local name = default
  if file ~= nil then
    name = file:read()
    file:close()
  end
  return name
end

M.save_theme = function(name)
  local theme_file = vim.fn.stdpath("state") .. "/mynvim_theme"
  local file = io.open(theme_file, "w")
  if file ~= nil then
    file:write(name)
    file:close()
  end
end

M.toggle_tree = function(all)
  -- nvim-tree help
  if vim.bo.buftype == "nofile" and vim.bo.filetype ~= "NvimTree" then
    return
  end

  if all then
    require("nvim-tree.api").tree.find_file({
      update_root = true,
      open = true,
      focus = true,
    })
  else
    require("nvim-tree.api").tree.toggle()
  end
end

local colorcolumn = ""
M.toggle_colorcolumn = function()
  if colorcolumn == "" then
    colorcolumn = vim.g.colorcolumn
  else
    colorcolumn = ""
  end
  vim.opt.colorcolumn = colorcolumn
  local base30 = require("base46").get_theme_tbl("base_30")
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = base30.black2 })
end

M.toggle_diagnostics = function()
  local is_enabled = vim.diagnostic.is_enabled({ bufnr = 0 })

  if is_enabled then
    vim.api.nvim_echo({ { "Disabling diagnostics" } }, false, {})
  else
    vim.api.nvim_echo({ { "Enabling diagnostics" } }, false, {})
  end

  vim.schedule(function()
    vim.diagnostic.enable(not is_enabled, { bufnr = 0 })
  end)
end

return M
