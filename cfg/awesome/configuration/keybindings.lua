---@diagnostic disable: undefined-global
local awful = require "awful"

local function set_keybindings ()
    awful.keyboard.append_global_keybindings({
        awful.key({ modkey, "Control" }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),
        awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
                  {description = "open a terminal", group = "launcher"}),
        awful.key(
            { modkey }, 'd',
            function ()
                awesome.emit_signal('dashboard::toggle')
            end,
            { description = 'toggle the dashboard', group = 'launcher '}
        ),
        awful.key(
            { modkey }, 'c',
            function ()
                awesome.emit_signal('screenshot-center::toggle')
            end,
            { description = 'toggle the screenshots center', group = 'launcher' }
        ),
        awful.key(
            { modkey }, 'n',
            function ()
                awesome.emit_signal('notifcenter::toggle')
            end,
            { description = 'toggle the notifcenter', group = 'launcher'}
        ),
        awful.key({ modkey, "Shift" }, "Return", function () awful.spawn("rofi -show drun") end,
                  {description = "Open rofi", group = "launcher"}),
    })

    -- Tags related keybindings
    awful.keyboard.append_global_keybindings({
        awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
                  {description = "view previous", group = "tag"}),
        awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
                  {description = "view next", group = "tag"}),
        awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
                  {description = "go back", group = "tag"}),
    })

    -- center a floating window
    awful.keyboard.append_global_keybindings({
        awful.key({modkey}, "Down", function ()
            awful.placement.centered(client.focus, {
                honor_workarea = true
            })
        end, { description = 'Center a floating window', group = 'client' })
    })

    -- Focus related keybindings
    awful.keyboard.append_global_keybindings({
        awful.key({ modkey,           }, "j",
            function ()
                awful.client.focus.byidx( 1)
            end,
            {description = "focus next by index", group = "client"}
        ),
        awful.key({ modkey,           }, "k",
            function ()
                awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
        ),
        awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "go back", group = "client"}),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
                  {description = "focus the next screen", group = "screen"}),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
                  {description = "focus the previous screen", group = "screen"}),
    })

    -- Layout related keybindings
    awful.keyboard.append_global_keybindings({
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
                  {description = "swap with next client by index", group = "client"}),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
                  {description = "swap with previous client by index", group = "client"}),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
                  {description = "jump to urgent client", group = "client"}),
        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
                  {description = "increase master width factor", group = "layout"}),
        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
                  {description = "decrease master width factor", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
                  {description = "increase the number of master clients", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
                  {description = "decrease the number of master clients", group = "layout"}),
        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
                  {description = "increase the number of columns", group = "layout"}),
        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
                  {description = "decrease the number of columns", group = "layout"}),
        awful.key({ modkey,           }, "Tab", function () awful.layout.inc( 1)                end,
                  {description = "select next", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(-1)                end,
                  {description = "select previous", group = "layout"}),
    })

    -- @DOC_NUMBER_KEYBINDINGS@

    awful.keyboard.append_global_keybindings({
        awful.key {
            modifiers   = { modkey },
            keygroup    = "numrow",
            description = "only view tag",
            group       = "tag",
            on_press    = function (index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then
                    tag:view_only()
                end
            end,
        },
        awful.key {
            modifiers   = { modkey, "Control" },
            keygroup    = "numrow",
            description = "toggle tag",
            group       = "tag",
            on_press    = function (index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
        },
        awful.key {
            modifiers = { modkey, "Shift" },
            keygroup    = "numrow",
            description = "move focused client to tag",
            group       = "tag",
            on_press    = function (index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
        },
        awful.key {
            modifiers   = { modkey, "Control", "Shift" },
            keygroup    = "numrow",
            description = "toggle focused client on tag",
            group       = "tag",
            on_press    = function (index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
        },
        awful.key {
            modifiers   = { modkey },
            keygroup    = "numpad",
            description = "select layout directly",
            group       = "layout",
            on_press    = function (index)
                local t = awful.screen.focused().selected_tag
                if t then
                    t.layout = t.layouts[index] or t.layout
                end
            end,
        }
    })

    -- @DOC_CLIENT_KEYBINDINGS@
    client.connect_signal("request::default_keybindings", function()
        awful.keyboard.append_client_keybindings({
            awful.key({ modkey,           }, "f",
                function (c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
                {description = "toggle fullscreen", group = "client"}),
            awful.key({ modkey   }, "w",      function (c) c:kill()                         end,
                    {description = "close", group = "client"}),
            awful.key({ modkey }, "space",  awful.client.floating.toggle                     ,
                    {description = "toggle floating", group = "client"}),
            awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                    {description = "move to master", group = "client"}),
            awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                    {description = "move to screen", group = "client"}),
            awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                    {description = "toggle keep on top", group = "client"}),
            awful.key({ modkey,           }, "m",
                function (c)
                    c.maximized = not c.maximized
                    c:raise()
                end ,
                {description = "(un)maximize", group = "client"}),
            awful.key({ modkey, "Control" }, "m",
                function (c)
                    c.maximized_vertical = not c.maximized_vertical
                    c:raise()
                end ,
                {description = "(un)maximize vertically", group = "client"}),
            awful.key({ modkey, "Shift"   }, "m",
                function (c)
                    c.maximized_horizontal = not c.maximized_horizontal
                    c:raise()
                end ,
                {description = "(un)maximize horizontally", group = "client"}),
        })
    end)
end

set_keybindings()
