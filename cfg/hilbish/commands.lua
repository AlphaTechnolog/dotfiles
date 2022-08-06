local commander = require "commander"

local M = {}

function M.which (input)
   print(hilbish.which(input[1]))
end

function M.alias (argv)
   local name = argv[1]
   local cmd = argv[2]

   hilbish.alias(name, cmd)
end

function M.setup ()
   if hilbish.which("which") == nil then
      commander.register('which', M.which)
   end
   commander.register('alias', M.alias)
end

return M
