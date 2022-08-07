local hilbish = require "hilbish"
local bat = require "bat"

local M = {}

M.aliases = {
   ls = "exa --icons",
   la = "ls -la",
   tree = "ls --tree",
   grep = 'grep --color=always',
}

function M.setup_bat ()
   local bat_flags = ' --paging=never --style=plain --theme=base16'
   local bat_exec = bat.get_exec()
   if bat_exec ~= nil then
      M.aliases.cat = bat_exec .. bat_flags
   end
end

function M.load_table (table)
   for cmd, new_cmd in pairs(table) do
      hilbish.alias(cmd, new_cmd)
   end
end

function M.load_aliases ()
   M.setup_bat()
   M.load_table(M.aliases)
end

return M
