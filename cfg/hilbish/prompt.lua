local hilbish = require("hilbish")
local bait = require("bait")
local lunacolors = require("lunacolors")
local ansikit = require("ansikit")

local M = {}

-- configuration
M.do_conf = function ()
   hilbish.inputMode('vim')
end

-- events
M.do_end_line = function (cmd_str)
   if cmd_str ~= 'clear' then
      print()
   end
end

M.do_vim_mode_setup = function (mode)
   if mode ~= 'insert' then
      ansikit.cursorStyle(ansikit.blockCursor)
   else
      ansikit.cursorStyle(ansikit.lineCursor)
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

M.ghost_prompt = function (fail, is_root)
   return '{black}{blackBg}' .. M.get_icon_by_failure(fail, {
      success = '{green}',
      failure = '{red}'
   }) .. ' {cyan}%d{reset}{black}{reset} ' .. (is_root and '{red}' or '{yellow}') .. ' {reset}'
end

M.simple_cold_ghost_prompt = function (fail, is_root)
    return '{blue} {cyan}%d ' .. M.get_icon_by_failure(fail, {
        success = '{blue}',
        failure = '{red}',
    }, {
        success = '❯{cyan}❯',
        failure = '❯{yellow}❯'
    }) .. ' {reset}'
end

M.arrows_prompt = function (fail, is_root)
   -- a bit hacky
   return M.get_icon_by_failure(fail, {
      success = '{blue}',
      failure = '{red}',
   }, {
      success = '❯{cyan}❯',
      failure = '❯{magenta}❯'
   }) .. ' {reset}'
end

M.indicators_prompt = function (fail, is_root)
   return (fail and '{red}' or '{green}') .. '' .. M.get_icon_by_failure(fail, {
      success = '{black}{greenBg}',
      failure = '{black}{redBg}'
   }) .. " {reset}" .. (fail and '{red}' or '{green}') .. "{blackBg} {blue}%d {reset}{black} "
end

-- change the style changing the name of the functin that `hilbish.prompt` calls
M.do_prompt = function (code)
   hilbish.prompt(lunacolors.format(M.simple_cold_ghost_prompt(
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
