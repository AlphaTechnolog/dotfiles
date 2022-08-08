local hilbish = require("hilbish")
local bait = require("bait")
local lunacolors = require("lunacolors")
local ansikit = require("ansikit")

local rc = require 'utils.rc'.get_rc()

local M = {}

-- configuration
M.do_conf = function ()
   hilbish.inputMode('vim')
end

-- events
M.do_end_line = function (cmd_str)
    if cmd_str ~= 'clear' and rc.prompt.do_end_line then
        print()
    end
end

M.do_vim_mode_setup = function (mode)
    if mode == 'insert' then
        ansikit.cursorStyle(rc.prompt.vim_mode.cursors_case.insert)
    else
        ansikit.cursorStyle(rc.prompt.vim_mode.cursors_case.others)
    end
end

M.do_events = function ()
   bait.catch('command.exit', function (code, cmd_str)
      M.do_end_line(cmd_str)
      M.do_prompt(code)
   end)

   bait.catch('hilbish.vimMode', function (mode)
      M.do_vim_mode_setup(mode)
   end)
end

-- prompt styling
M.get_icon_by_failure = function (fail, colors, icons)
   if not icons then
      icons = {
         failure = '',
         success = ''
      }
   end
   return fail and colors.failure .. icons.failure or colors.success .. icons.success
end

-- return the prompt format
M.ghost_prompt = function (fail, _)
    return M.get_icon_by_failure(fail, {
        success = '{blue}',
        failure = '{red}',
    }, {
        success = ' {blue}❯{cyan}❯',
        failure = ' {red}❯{magenta}❯'
    }) .. ' '
end

-- change the style changing the name of the functin that `hilbish.prompt` calls
M.do_prompt = function (code)
   hilbish.prompt(lunacolors.format(M[rc.prompt.style .. '_prompt'](
      code ~= 0 and code ~= nil, -- checks if the command was executed successfully
      hilbish.user == 'root' -- checks if the user is root
   )))
end

-- main function
M.setup = function ()
   M.do_conf()
   M.do_prompt()
   M.do_events()
end

return M
