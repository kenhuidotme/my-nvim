local M = {}

M.is_valid_buffer = function(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.api.nvim_buf_get_option(buf, "buflisted")
end

M.buffer_filter = function()
  local bufs = vim.t.bufs or {}
  for i = #bufs, 1, -1 do
    if not M.is_valid_buffer(bufs[i]) then
      table.remove(bufs, i)
    end
  end
  if
    vim.t.buf_current ~= nil
    and not vim.tbl_contains(bufs, vim.t.buf_current)
  then
    vim.t.buf_current = nil
  end
  return bufs
end

M.next_buffer = function()
  local buf_current = vim.api.nvim_get_current_buf()
  local bufs = M.buffer_filter()
  for i, buf in ipairs(bufs) do
    if buf == buf_current then
      vim.cmd(i == #bufs and "b" .. bufs[1] or "b" .. bufs[i + 1])
      break
    end
  end
end

M.prev_buffer = function()
  local buf_current = vim.api.nvim_get_current_buf()
  local bufs = M.buffer_filter()
  for i, buf in ipairs(bufs) do
    if buf == buf_current then
      vim.cmd(i == 1 and "b" .. bufs[#bufs] or "b" .. bufs[i - 1])
      break
    end
  end
end

M.move_buffer = function(n)
  if n ~= 1 and n ~= -1 then
    return
  end
  local bufs = M.buffer_filter()
  if #bufs <= 1 then
    return
  end
  local buf_current = vim.api.nvim_get_current_buf()
  for i, buf in ipairs(bufs) do
    if buf == buf_current then
      if (n == -1 and i == 1) or (n == 1 and i == #bufs) then
        return
      end
      bufs[i], bufs[i + n] = bufs[i + n], bufs[i]
      break
    end
  end
  vim.t.bufs = bufs

  vim.cmd("redrawtabline")
end

local opened_in_other_tab = function(buf)
  local tab_current = vim.api.nvim_get_current_tabpage()
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if tab ~= tab_current then
      for _, b in ipairs(vim.t[tab].bufs) do
        if b == buf then
          return true
        end
      end
    end
  end
  return false
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

local switch_buffer = function(wins, buf, buf_switch)
  local win_current = vim.api.nvim_get_current_win()
  local wins_switched = {}
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_buf(win) == buf then
      vim.cmd(vim.api.nvim_win_get_number(win) .. " wincmd w")
      vim.cmd("b" .. buf_switch)
      table.insert(wins_switched, win)
    end
  end
  vim.cmd(vim.api.nvim_win_get_number(win_current) .. " wincmd w")
  return wins_switched
end

M.close_buffer = function()
  local buf_current = vim.api.nvim_get_current_buf()
  local bufs = M.buffer_filter()
  if #bufs <= 1 then
    return
  end

  local index = 0
  for i, buf in ipairs(bufs) do
    if buf == buf_current then
      index = i
      break
    end
  end
  if index == 0 then
    return
  end

  local buf_switch = index == #bufs and bufs[index - 1] or bufs[index + 1]
  local wins_switched =
    switch_buffer(vim.api.nvim_tabpage_list_wins(0), buf_current, buf_switch)

  remove_buffer(buf_current)

  if vim.tbl_contains(M.buffer_filter(), buf_current) then
    -- remove buffer failed, switch back
    switch_buffer(wins_switched, buf_switch, buf_current)
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

  local win_count = 0
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    buf = vim.api.nvim_win_get_buf(w)
    if vim.tbl_contains(bufs, buf) then
      win_count = win_count + 1
    end
  end

  if win_count > 1 then
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

  for _, b in ipairs(vim.t.bufs) do
    if not vim.tbl_contains(tab_switch_bufs, b) then
      table.insert(tab_switch_bufs, b)
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
      local key =
        vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true)
      vim.api.nvim_feedkeys(key, "n", false)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function(args)
      if M.is_valid_buffer(args.buf) then
        local bufs = M.buffer_filter()
        if not vim.tbl_contains(bufs, args.buf) then
          table.insert(bufs, args.buf)
          vim.t.bufs = bufs
        end
        vim.t.buf_current = args.buf
      end
      --
      if vim.api.nvim_buf_get_option(args.buf, "buftype") == "terminal" then
        vim.cmd("startinsert!")
      end
    end,
  })

  require("core.utils").load_mappings("tabline")

  vim.opt.showtabline = 2
  vim.opt.tabline = "%!v:lua.require('ui.tabline.view').build()"
end

return M
