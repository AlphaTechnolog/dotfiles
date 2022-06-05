local M = {}

function M.init ()
  -- write your autocmds here
  vim.cmd [[ autocmd FileType php setlocal tabstop=4 shiftwidth=4 ]]
  vim.cmd [[ autocmd FileType python setlocal tabstop=4 shiftwidth=4 ]]
end

return M
