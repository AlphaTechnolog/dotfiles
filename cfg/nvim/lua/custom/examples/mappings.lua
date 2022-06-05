local M = {}
local map = require('utils.map')

function M.init ()
  -- write your mappings here, see: lua/utils/map.lua for
  -- more information about it function.
  map.set('n', '<leader>fs', map.cmd('w!'))
end

return M
