local M = {}
local map = require('utils.map')

function M.init ()
  -- write your mappings here, see: lua/utils/map.lua for
  -- more information about it function.
  map.set('n', '<leader>fs', map.cmd('w!'))
  map.set('n', '<leader>ff', map.cmd('Telescope find_files'))
  map.set('n', '<leader>fg', map.cmd('Telescope live_grep'))
  map.set('n', '<leader>fq', map.cmd('wq!'))
  map.set('n', '<leader>x', map.cmd('BufferDelete'))
end

return M
