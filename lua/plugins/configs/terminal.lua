local opts = {
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 0.25
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.35
    end
  end,
}

local M = {}

M.setup = function()
  require("toggleterm").setup(opts)

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function(args)
      local bt = vim.api.nvim_buf_get_option(args.buf, "buftype")
      if bt == "terminal" then
        vim.cmd("startinsert!")
      end
    end,
  })
end

return M
