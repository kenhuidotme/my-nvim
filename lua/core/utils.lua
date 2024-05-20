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

M.set_launch_dir = function(dir)
  local vim_enter_group = vim.api.nvim_create_augroup("vim_enter_group", { clear = true })
  vim.api.nvim_create_autocmd(
    { "VimEnter" },
    { pattern = "*", command = "cd " .. dir, group = vim_enter_group }
  )
end

local term_count = 0
local term_num = 0
local float_term_num = 0

M.toggle_term = function()
  if term_num == 0 then
    term_count = term_count + 1
    term_num = term_count
  end
  vim.cmd(term_num .. "ToggleTerm direction=" .. vim.g.terminal_direction)
end

M.toggle_float_term = function()
  if float_term_num == 0 then
    term_count = term_count + 1
    float_term_num = term_count
  end
  vim.cmd(float_term_num .. "ToggleTerm direction=float")
end

return M
