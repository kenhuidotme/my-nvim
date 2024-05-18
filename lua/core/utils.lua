local mappings = require("core.mappings")

local M = {}

M.load_mappings = function(section, mapping_options)
  vim.schedule(function()
    local section_values = mappings[section]
    if not section_values then
      return
    end

    for mode, mode_values in pairs(section_values) do
      for key_bind, mapping_info in pairs(mode_values) do
        local options =
          vim.tbl_deep_extend(
            "force",
            mapping_options or {},
            mapping_info.options or {})
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

      local is_valid_plugin =
        string.sub(file, 1, 8) ~= "NvimTree"
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
  local themes = vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/base46/themes")
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

-- M.config_replace = function(old, new)
--   local file = io.open(config_file, "r")
--   if file ~= nil then
--     local added_pattern = string.gsub(old, "-", "%%-") -- add % before - if exists
--     local new_content = file:read("*all"):gsub(added_pattern, new)
--     file = io.open(config_file, "w")
--     if file ~= nil then
--       file:write(new_content)
--       file:close()
--     end
--   end
-- end

return M
