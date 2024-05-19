local options = {
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 0.20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.35
    end
  end,
  on_open = function(_)
    vim.cmd("startinsert!")
  end,
}

return options
