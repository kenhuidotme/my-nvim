local M = {}

local base46_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")

M.get_theme_tbl = function(type)
  local theme_path = "base46.themes." .. vim.g.theme
  local present, theme = pcall(require, theme_path)
  if present then
    return theme[type]
  else
    error("No such theme!")
  end
end

local extend_highlight = function(tbl)
  local polish_hl = M.get_theme_tbl("polish_hl")

  -- polish themes
  if polish_hl then
    for key, value in pairs(polish_hl) do
      if tbl[key] then
        tbl[key] = vim.tbl_deep_extend("force", tbl[key], value)
      end
    end
  end

  -- transparency
  if vim.g.transparency then
    for key, value in pairs(require("base46.glassy")) do
      if tbl[key] then
        tbl[key] = vim.tbl_deep_extend("force", tbl[key], value)
      end
    end
  end
end

M.load_highlight = function(filename)
  local tbl = require("base46.integrations." .. filename)
  extend_highlight(tbl)
  return tbl
end

local tbl_to_str = function(tbl)
  local result = ""

  for group_name, group_vals in pairs(tbl) do
    local name = "'" .. group_name .. "',"
    local opts = ""

    for opt_name, opt_val in pairs(group_vals) do
      opt_val =
        ((type(opt_val)) == "boolean" or type(opt_val) == "number")
        and tostring(opt_val)
        or '"' .. opt_val .. '"'
      opts = opts .. opt_name .. "=" .. opt_val .. ","
    end

    result = result .. "vim.api.nvim_set_hl(0," .. name .. "{" .. opts .. "})"
  end

  return result
end

local save_cache = function(filename, tbl)
  local bg_opt = "vim.opt.bg='" .. M.get_theme_tbl "type" .. "'"

  local lines =
    "return string.dump(function()"
    .. (filename == "defaults" and bg_opt or "")
    .. tbl_to_str(tbl)
    .. "end, true)"

  local file = io.open(vim.g.base46_cache .. filename, "wb")

  if file then
    file:write(load(lines)())
    file:close()
  end
end

M.compile = function()
  if not vim.loop.fs_stat(vim.g.base46_cache) then
    vim.fn.mkdir(vim.g.base46_cache, "p")
  end

  for _, file in ipairs(vim.fn.readdir(base46_path .. "/integrations")) do
    local filename = vim.fn.fnamemodify(file, ":r")
    save_cache(filename, M.load_highlight(filename))
  end
end

M.reload_all_highlights = function()
  require("plenary.reload").reload_module("base46")
  M.compile()

  for _, file in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
    dofile(vim.g.base46_cache .. file)
  end

  require("base46.terminal").load()
end

return M
