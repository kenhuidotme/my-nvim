local M = {}

M.init = function()
  local group_name = "GitSignsLazyLoad"
  -- load gitsigns only when a git file is opened
  vim.api.nvim_create_autocmd({ "BufRead" }, {
    group = vim.api.nvim_create_augroup(group_name, { clear = true }),
    callback = function()
      vim.fn.system(
        "git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse"
      )
      if vim.v.shell_error == 0 then
        vim.api.nvim_del_augroup_by_name(group_name)
        vim.schedule(function()
          require("lazy").load({ plugins = { "gitsigns.nvim" } })
        end)
      end
    end,
  })
end

local opts = {
  on_attach = function(bufnr)
    require("core.utils").load_mappings("gitsigns_nvim", { buffer = bufnr })
  end,
}

M.setup = function()
  require("gitsigns").setup(opts)
end

return M
