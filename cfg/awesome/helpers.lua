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

return helpers
