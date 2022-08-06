local M = {}

local function is_valid_cmd (cmd)
   return hilbish.which(cmd) ~= '' and hilbish.which(cmd) ~= nil
end

function M.get_exec ()
   local choices = {'bat', 'batcat'}
   for _, choice in ipairs(choices) do
      if is_valid_cmd(choice) then
         return choice
      end
   end

   return nil
end

return M
