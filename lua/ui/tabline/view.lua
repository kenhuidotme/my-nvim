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

local add_file_style = function(filename, buf)
  local devicons_present, devicons = pcall(require, "nvim-web-devicons")

  if devicons_present then
    local icon, icon_hl =
      devicons.get_icon(filename, string.match(filename, "%a+$"))
    if not icon then
      icon = "󰈚"
      icon_hl = "DevIconDefault"
    end

    local buf_current = vim.api.nvim_get_current_buf()

    icon = buf == buf_current and new_icon_hl(icon_hl, "TlBufOn") .. icon
      or icon

    local name_max = 16
    filename = #filename > name_max and string.sub(filename, 1, 14) .. ".."
      or filename

    -- padding around bufname; 24 = bufname length (icon + filename)
    local padding = (24 - #filename - 6) / 2

    filename = buf == buf_current and "%#TlBufOn#" .. " " .. filename
      or "%#TlBufOff#" .. " " .. filename

    return string.rep(" ", padding)
      .. icon
      .. filename
      .. string.rep(" ", padding)
  end
end

local style_buffer = function(buf)
  local filename = vim.api.nvim_buf_get_name(buf)

  if filename ~= "" then
    filename = vim.fn.fnamemodify(filename, ":t")
  end

  if filename == "" then
    local filetype = vim.bo[buf].filetype
    if filetype ~= "" then
      filename = filetype
    else
      filename = "No Name"
    end
  end

  filename = "%" .. buf .. "@TlGoToBuf@" .. add_file_style(filename, buf)

  local modified = vim.api.nvim_buf_get_option(buf, "modified")

  if buf == vim.api.nvim_get_current_buf() then
    return modified
        and "%#TlBufOn#" .. filename .. "%" .. buf .. "@TlCloseBuf@%#TlBufOnModified# "
      or "%#TlBufOn#"
        .. filename
        .. "%"
        .. buf
        .. "@TlCloseBuf@%#TlBufOnClose# "
  else
    return modified and "%#TlBufOff#" .. filename .. "%#TlBufOffModified# "
      or "%#TlBufOff#" .. filename .. "%#TlBufOffClose#󰅖 "
  end
end

local get_tabs_width = function()
  local tabs = vim.api.nvim_list_tabpages()
  return #tabs > 1 and 3 * #tabs + 3 or 0
end

local list_buffer = function()
  local available_space = vim.o.columns - get_tabs_width() - 6

  local buf_current = vim.api.nvim_get_current_buf()
  local has_current = false

  local buffers = {}
  local bufs = require("ui.tabline").buffer_filter()

  if not vim.tbl_contains(bufs, buf_current) then
    buf_current = vim.t.buf_current
  end

  if buf_current == nil then
    has_current = true
  end

  local has_omit = false
  local last_index = 0

  for i, buf in ipairs(bufs) do
    if (#buffers + 1) * 24 > available_space then
      if has_current then
        break
      end
      table.remove(buffers, 1)
      has_omit = true
    end
    has_current = buf == buf_current and true or has_current
    table.insert(buffers, style_buffer(buf))
    last_index = i
  end

  local prefix = ""
  if has_omit then
    prefix = "%#TlBufMore#<< "
  end

  local suffix = ""
  if last_index < #bufs then
    suffix = "%#TlBufMore# >>"
  end

  return prefix .. table.concat(buffers) .. suffix .. "%#TlFill#" .. "%="
end

local list_tab = function()
  local tab_current = vim.api.nvim_get_current_tabpage()
  local tabs = vim.api.nvim_list_tabpages()
  local result = ""
  if #tabs > 1 then
    for i, tab in ipairs(tabs) do
      local tab_hl = tab == tab_current and "%#TlTabOn#" or "%#TlTabOff#"
      result = result .. "%" .. i .. "@TlGoToTab@" .. tab_hl .. " " .. i .. " "
      if tab == tab_current then
        result = result .. "%#TlTabOnClose#" .. "%@TlCloseTab@󰅙 "
      end
    end
  end
  return result
end

local M = {}

M.build = function()
  return list_buffer() .. list_tab()
end

return M
