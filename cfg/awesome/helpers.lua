local awful = require 'awful'

local helpers = {}

-- function that adds feedback to a `wibox.container.background` changing its
-- background color to the supplied ones
function helpers.add_feedback(w, bg, hbg)
   w:connect_signal("mouse::enter", function (self)
      self.bg = hbg
   end)
   w:connect_signal("mouse::leave", function (self)
      self.bg = bg
   end)
end


-- Given a `match` condition, returns an array with clients that match it, or
-- just the first found client if `first_only` is true.
-- @credits: elenapan
function helpers.find_clients(match, first_only)
   local matcher = function (c)
       return awful.rules.match(c, match)
   end

   if first_only then
       for c in awful.client.iterate(matcher) do
           return c
       end
   else
       local clients = {}
       for c in awful.client.iterate(matcher) do
           table.insert(clients, c)
       end
       return clients
   end
   return nil
end

return helpers
