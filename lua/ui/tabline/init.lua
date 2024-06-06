local M = {}

M.is_valid_buffer = function(buf)
  return
      vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_buf_get_option(buf, "buflisted")
end

M.buffer_filter = function()
  local bufs = vim.t.bufs or {}
  for i = #bufs, 1, -1 do
    if not M.is_valid_buffer(bufs[i]) then
      table.remove(bufs, i)
    end
  end
  return bufs
end

M.next_buffer = function()
  local bufs = M.buffer_filter()
  for i, buf in ipairs(bufs) do
    if vim.api.nvim_get_current_buf() == buf then
      vim.cmd(i == #bufs and "b" .. bufs[1] or "b" .. bufs[i + 1])
      break
    end
  end
end

M.prev_buffer = function()
  local bufs = M.buffer_filter()
  for i, buf in ipairs(bufs) do
    if vim.api.nvim_get_current_buf() == buf then
      vim.cmd(i == 1 and "b" .. bufs[#bufs] or "b" .. bufs[i - 1])
      break
    end
  end
end

M.move_buffer = function(n)
  local bufs = M.buffer_filter()
  for i, buf in ipairs(bufs) do
    if buf == vim.api.nvim_get_current_buf() then
      if (n < 0 and i == 1) or (n > 0 and i == #bufs) then
        bufs[1], bufs[#bufs] = bufs[#bufs], bufs[1]
      else
        bufs[i], bufs[i + n] = bufs[i + n], bufs[i]
      end
      break
    end
  end
  vim.t.bufs = bufs

  vim.cmd("redrawtabline")
end

local switch_buffer = function(wins, buf, buf_switch)
  local win_current = vim.api.nvim_get_current_win()
  local wins_switch = {}
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_buf(win) == buf then
      vim.cmd(vim.api.nvim_win_get_number(win) .. " wincmd w")
      vim.cmd("b" .. buf_switch)
      table.insert(wins_switch, win)
    end
  end
  vim.cmd(vim.api.nvim_win_get_number(win_current) .. " wincmd w")
  return wins_switch
end

local opened_in_other_tab = function(buf)
  local tab = vim.api.nvim_get_current_tabpage()
  for _, t in ipairs(vim.api.nvim_list_tabpages()) do
    if t ~= tab then
      for _, b in ipairs(vim.t[t].bufs) do
        if b == buf then
          return true
        end
      end
    end
  end
  return false
end

local is_new_empty_buffer = function(buf)
  return vim.api.nvim_buf_get_name(buf) == ""
      and vim.api.nvim_buf_get_option(buf, "filetype") == ""
      and not vim.api.nvim_buf_get_option(buf, "modified")
end

local remove_buffer = function(buf)
  if opened_in_other_tab(buf) then
    local bufs = M.buffer_filter()
    for i, b in ipairs(bufs) do
      if b == buf then
        table.remove(bufs, i)
        break
      end
    end
    vim.t.bufs = bufs
  else
    vim.cmd("silent! confirm bd" .. buf)
    vim.t.bufs = M.buffer_filter()
  end
end

M.close_buffer = function()
  local buf = vim.api.nvim_get_current_buf()
  local bufs = M.buffer_filter()

  if #bufs <= 1 and is_new_empty_buffer(buf) then
    return
  end

  local index = 0

  for i, b in ipairs(bufs) do
    if b == buf then
      index = i
      break
    end
  end

  if index == 0 then
    return
  end

  local buf_enew = 0

  if #bufs <= 1 then
    vim.cmd("enew")
    buf_enew = vim.api.nvim_get_current_buf()
    -- go back to current buffer
    vim.cmd("b" .. buf)
    bufs = M.buffer_filter()
  end

  local buf_switch = 0
  local wins_switch = nil

  if #bufs > 1 then
    buf_switch =
        index == #bufs
        and bufs[index - 1]
        or bufs[index + 1]
    wins_switch = switch_buffer(vim.api.nvim_tabpage_list_wins(0), buf, buf_switch)
  end

  remove_buffer(buf)

  if vim.tbl_contains(M.buffer_filter(), buf) then
    -- delete failed, restore buffers
    if buf_switch > 0 then
      switch_buffer(wins_switch, buf_switch, buf)
    end
    if buf_enew > 0 then
      vim.cmd("bd" .. buf_enew)
      vim.t.bufs = M.buffer_filter()
    end
  end

  vim.cmd("redrawtabline")
end

M.close_win = function()
  local bufs = M.buffer_filter()

  local buf = vim.api.nvim_win_get_buf(0)
  if not vim.tbl_contains(bufs, buf) then
    vim.cmd(vim.fn.winnr() .. " wincmd c")
    return
  end

  local count = 0

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    buf = vim.api.nvim_win_get_buf(win)
    if vim.tbl_contains(bufs, buf) then
      count = count + 1
    end
  end

  if count > 1 then
    vim.cmd(vim.fn.winnr() .. " wincmd c")
  end
end

M.close_tab = function()
  if #vim.api.nvim_list_tabpages() <= 1 then
    return
  end

  local tab_current = vim.api.nvim_get_current_tabpage()
  local tabs = vim.api.nvim_list_tabpages()

  local index = 0
  for i, tab in ipairs(tabs) do
    if tab == tab_current then
      index = i
      break
    end
  end

  local tab_switch = index == #tabs and tabs[index - 1] or tabs[index + 1]

  local tab_switch_bufs = vim.t[tab_switch].bufs
  for _, buf in ipairs(vim.t.bufs) do
    if not vim.tbl_contains(tab_switch_bufs, buf) then
      table.insert(tab_switch_bufs, buf)
    end
  end
  vim.t[tab_switch].bufs = tab_switch_bufs

  vim.cmd("tabclose")

  vim.cmd("redrawtabline")
end

M.load = function()
  vim.api.nvim_create_autocmd({ "TermClose" }, {
    callback = function()
      -- https://github.com/neovim/neovim/issues/7144
      -- Keep the terminal buffer open after the shell closes
      local key = vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true)
      vim.api.nvim_feedkeys(key, 'n', false)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function(args)
      local bufs = M.buffer_filter()
      if not vim.tbl_contains(bufs, args.buf) and M.is_valid_buffer(args.buf)
      then
        table.insert(bufs, args.buf)
      end
      vim.t.bufs = bufs
      --
      if vim.api.nvim_buf_get_option(args.buf, "buftype") == "terminal" then
        print("here")
        vim.cmd("startinsert!")
      end
    end,
  })

  require("core.utils").load_mappings("tabline")

  vim.opt.showtabline = 2
  vim.opt.tabline = "%!v:lua.require('ui.tabline.view').build()"
end

return M
