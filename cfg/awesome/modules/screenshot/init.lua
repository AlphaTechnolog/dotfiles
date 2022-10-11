-- Author: @AlphaTechnolog (https://github.com/AlphaTechnolog)
-- screenshot.lua: provides a simple AwesomeWM api to take screenshots using maim
-- @requires: maim, xclip

-- AwesomeWM Library
local gears = require 'gears'
local awful = require 'awful'
local naughty = require 'naughty'

-- Module
local M = {}

-- just uses the tmp name of the os module and remove the tmp section
-- to get an unique id lol
local function random_id ()
    return os.tmpname():gsub('/tmp/lua_', '')
end

-- returns an unique path for the screenshot inside the 'Pictures' folder.
local function get_path()
    return os.getenv('HOME') .. '/Pictures/screenshot-' .. random_id() .. '.png'
end

-- creates a dynamic/useful notification that should be showed after the
-- screenshot taking process.
function M.do_notify (tmp_path)
    local copy = naughty.action { name = 'Copy' }
    local delete = naughty.action { name = 'Delete' }

    -- implement the copy screenshot button, uses xclip to take the screenshot in the clipboard
    copy:connect_signal('invoked', function ()
        awful.spawn.with_shell('xclip -sel clip -target image/png "' .. tmp_path .. '"')

        -- don't wait for xclip :/
        naughty.notify {
            app_name = 'Screenshot',
            title = 'Screenshot',
            text = 'Screenshot copied successfully.',
        }
    end)

    -- implement the delete button, just execute rm in the `tmp_path`.
    -- TODO: Use native lua functions to remove the file.
    delete:connect_signal('invoked', function ()
        awful.spawn.easy_async_with_shell('rm ' .. tmp_path, function ()
            naughty.notify {
                app_name = 'Screenshot',
                title = 'Screenshot',
                text = 'Screenshot removed successfully.',
            }
        end)
    end)

    -- Show the notification.
    naughty.notify {
        app_name = 'Screenshot',
        app_icon = tmp_path,
        icon = tmp_path,
        title = 'Screenshot is ready!',
        text = 'Screenshot saved successfully',
        actions = {
            copy,
            delete
        }
    }
end

-- returns defaults properties for the `given_opts`.
local function with_defaults(given_opts)
    return {
        notify = given_opts == nil and false or given_opts.notify,
    }
end

-- takes a full-screen screenshot, receives `opts` which has a sub-property called
-- `notify`, `notify` defines if `do_notify` should be called automatically after maim
-- calling.
function M.full(opts)
    -- screenshot path.
    local tmp_path = get_path()

    -- waiting a bit of time to wait the hidding of some visual elements
    -- that could be already rendered.
    gears.timer {
        timeout = 0.25,
        call_now = false,
        autostart = true,
        single_shot = true,
        callback = function ()
            -- calls maim and then check if `do_notify` should be called using `opts.notify`.
            awful.spawn.easy_async_with_shell('maim "' .. tmp_path .. '"', function ()
                ---@diagnostic disable-next-line: undefined-global
                awesome.emit_signal('screenshot::done')

                if with_defaults(opts).notify then
                    M.do_notify(tmp_path)
                end
            end)
        end
    }
end

-- takes an area-screenshot, receives `opts` which has a sub-property called `notify`,
-- `notify` defines if `do_notify` should be called after the maim calling.
function M.area(opts)
    -- screenshot path.
    local tmp_path = get_path()

    -- calls maim, also checks if `do_notify` should be called using `opts.notify`.
    awful.spawn.easy_async_with_shell('maim --select "' .. tmp_path .. '"', function ()
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal('screenshot::done')

        if with_defaults(opts).notify then
            M.do_notify(tmp_path)
        end
    end)
end

-- take a screenshot using the options-api, the options-api is just a function that gives
-- an object that contains the next properties:
-- -> type, possible values: full, area (string)
-- -> timeout (int, default: 0)
-- -> notify (boolean)
-- it automatically calls the necessary functions and wait the time provided by `timeout`
function M.with_options(opts)
    opts = {
        type = opts.type ~= nil and opts.type or 'full',
        timeout = opts.timeout ~= nil and opts.timeout or 0,
        notify = opts.notify ~= nil and opts.notify or false,
    }

    local function core()
        if opts.type == 'full' then
            M.full({ notify = opts.notify })
        elseif opts.type == 'area' then
            M.area({ notify = opts.notify })
        else
            error('Invalid `opts.type` in `screenshot.with_options` (' .. opts.type .. '), valid ones are: full and area')
        end
    end

    if opts.timeout <= 0 then
        return core()
    end

    gears.timer {
        timeout = opts.timeout,
        call_now = false,
        autostart = true,
        single_shot = true,
        callback = core
    }
end

-- done
return M
