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

M.lazy_load = function(plugin)
  local group_name = "BeLazyOnFileOpen:" .. plugin
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup(group_name, {}),
    callback = function()
      local file = vim.fn.expand("%")

      local is_valid_plugin = string.sub(file, 1, 8) ~= "NvimTree"
        and file ~= "[lazy]"
        and file ~= ""

      if is_valid_plugin then
        vim.api.nvim_del_augroup_by_name(group_name)
        -- Don't defer for treesitter as it will show slow highlighting
        -- This deferring only happens when we do "nvim filename"
        if plugin == "nvim-treesitter" then
          require("lazy").load({ plugins = plugin })
        else
          vim.schedule(function()
            require("lazy").load({ plugins = plugin })
            if plugin == "nvim-lspconfig" then
              vim.cmd("silent! do FileType")
            end
          end, 0)
        end
      end
    end,
  })
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

M.set_launch_dir = function(dir)
  local vim_enter_group =
    vim.api.nvim_create_augroup("vim_enter_group", { clear = true })
  vim.api.nvim_create_autocmd(
    { "VimEnter" },
    { pattern = "*", command = "cd " .. dir, group = vim_enter_group }
  )
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
  vim.b.diagnostics_disabled = not vim.b.diagnostics_disabled

  local cmd
  if vim.b.diagnostics_disabled then
    cmd = "disable"
    vim.api.nvim_echo({ { "Disabling diagnostics" } }, false, {})
  else
    cmd = "enable"
    vim.api.nvim_echo({ { "Enabling diagnostics" } }, false, {})
  end

  vim.schedule(function()
    vim.diagnostic[cmd](0)
  end)
end

return M
