local hilbish = require "hilbish"

local M = {}

function M.start_tbsm ()
   hilbish.run("tbsm")
end

function M.setup ()
   if hilbish.login then
      M.start_tbsm()
   end
end

return M
