local hilbish = require "hilbish"
local M = {}

M.paths = {
  "~/.local/bin"
}

function M.load_table(table)
  for _, path in ipairs(table) do
    hilbish.appendPath(path)
  end
end

function M.setup ()
  M.load_table(M.paths)
end

return M
