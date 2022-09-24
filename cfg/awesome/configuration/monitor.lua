local awful = require 'awful'

awful.screen.connect_for_each_screen(function (s)
    s:connect_signal('property::geometry', function ()
        awesome.restart()
    end)
end)
