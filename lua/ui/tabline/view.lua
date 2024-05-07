vim.cmd([[
function! TlGoToBuf(buf,b,c,d)
  execute 'b' .. a:buf
endfunction
]])

vim.cmd([[
function! TlCloseBuf(a,b,c,d)
  call luaeval('require("ui.tabline").close_buffer()')
endfunction
]])

vim.cmd([[
function! TlGoToTab(tab,b,c,d)
  execute a:tab .. 'tabnext'
endfunction
]])

vim.cmd([[
function! TlCloseTab(a,b,c,d)
  tabclose
  call luaeval('require("ui.tabline").close_tab()')
endfunction
]])

local new_icon_hl = function(group_fg, group_bg)
  local fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group_fg)), "fg#")
  local bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group_bg)), "bg#")
  vim.api.nvim_set_hl(0, group_fg .. group_bg, { fg = fg, bg = bg })
  return "%#" .. group_fg .. group_bg .. "#"
end

local add_fileInfo = function(name, buf)
  local devicons_present, devicons = pcall(require, "nvim-web-devicons")

  if devicons_present then
    local icon, icon_hl = devicons.get_icon(name, string.match(name, "%a+$"))
    if not icon then
      icon = "󰈚"
      icon_hl = "DevIconDefault"
    end

    local buf_current = vim.api.nvim_get_current_buf()

    icon =
      buf == buf_current
      and new_icon_hl(icon_hl, "TlBufOn") .. icon
      or icon

    local name_max = 16
    name =
      #name > name_max
      and string.sub(name, 1, 14) .. ".."
      or name

    -- padding around bufname; 24 = bufname length (icon + filename)
    local padding = (24 - #name - 6) / 2

    name =
      buf == buf_current
      and "%#TlBufOn#" .. " " .. name
      or "%#TlBufOff#" .. " " .. name

    return
      string.rep(" ", padding)
      .. icon
      .. name
      .. string.rep(" ", padding)
  end
end

local style_buffer = function(buf)
  local name = vim.api.nvim_buf_get_name(buf)

  name =
    #name ~= 0
    and vim.fn.fnamemodify(name, ":t")
    or " No Name "

  name =
    "%" .. buf .. "@TlGoToBuf@"
    .. add_fileInfo(name, buf)

  local modified = vim.api.nvim_buf_get_option(buf, "modified")

  if buf == vim.api.nvim_get_current_buf() then
    return
      modified
      and
        "%#TlBufOn#" .. name
        .. "%" .. buf .. "@TlCloseBuf@%#TlBufOnModified# "
      or
        "%#TlBufOn#" .. name
        .. "%" .. buf .. "@TlCloseBuf@%#TlBufOnClose# "
  else
    return
      modified
      and "%#TlBufOff#" .. name .. "%#TlBufOffModified# "
      or "%#TlBufOff#" .. name .. "%#TlBufOffClose#󰅖 "
  end
end

local get_tabs_width = function()
  local tabs = vim.api.nvim_list_tabpages()
  return
    #tabs > 1
    and 3 * #tabs + 3
    or 0
end

local buffer_list = function()
  local available_space = vim.o.columns - get_tabs_width()

  local buf_current = vim.api.nvim_get_current_buf()
  local has_current = false

  local buffers = {}
  local bufs = require("ui.tabline").buffer_filter()

  for _, buf in ipairs(bufs) do
    if (#buffers + 1) * 24 > available_space then
      if has_current then
        break
      end
      table.remove(buffers, 1)
    end
    has_current =
      buf == buf_current
      and true
      or has_current
    table.insert(buffers, style_buffer(buf))
  end

  return table.concat(buffers) .. "%#TlFill#" .. "%="
end

local tab_list = function()
  local tabs = vim.api.nvim_list_tabpages()
  local tab = vim.api.nvim_get_current_tabpage()

  local result = ""
  if #tabs > 1 then
    for i, t in ipairs(tabs) do
      local tab_hl =
        t == tab
        and "%#TlTabOn#"
        or "%#TlTabOff#"
      result =
        result
        .. "%" .. i .. "@TlGoToTab@"
        .. tab_hl .. " " .. i .. " "
      if t == tab then
        result =
          result
          .. "%#TlTabOnClose#"
          .. "%@TlCloseTab@󰅙 "
      end
    end
  end
  return result
end

local M = {}

M.build = function()
  return buffer_list() .. tab_list()
end

return M
