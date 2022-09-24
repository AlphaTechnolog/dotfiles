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

-- trim strings
local function trim(s)
    local function sgsub(s, ...)
        return s:gsub(...)
    end

    local result = pcall(sgsub, s, "%s+", "")

    if result then
        return string.gsub(s, "%s+", "")
    end
end

-- git integration
local function dirty(char) -- thanks to TorchedSammy
    local _, dirt = hilbish.run('git status --porcelain | wc -l', false)
    local ret = trim(dirt)

    local modifiedchar = char or ''

    if ret == '' then
        return ''
    end

    return tonumber(ret) > 0 and (' ' .. modifiedchar) or ''
end

local function get_branch_name() -- thanks to TorchedSammy
    local _, branch = hilbish.run('git rev-parse --abbrev-ref HEAD', false)
    local ret = trim(branch)

    if ret == '' then
        return nil
    end

    return ret
end

local function git_branch()
    return get_branch_name(), get_branch_name() ~= nil
end

-- return the prompt format
M.blocks_prompt = function (fail, _)
    local branch, show_branch = git_branch()

    return M.get_icon_by_failure(fail, {
        success = "{blue}{blueBg}",
        failure = '{red}{redBg}',
    }, {
        success = '{black} {reset}{blue}' .. (show_branch and '{cyanBg}' or '{blackBg}') .. '',
        failure = '{black} {reset}{red}' .. (show_branch and '{cyanBg}' or '{blackBg}') .. '',
    }) .. '{reset}' .. (show_branch and '{cyanBg}{black}  ' .. branch .. dirty() .. ' {reset}{cyan}{blackBg}' or '') .. '{blackBg}{cyan}  %d {reset}{black} {yellow}{reset}{yellow} {reset}'
end

M.ghost_prompt = function (fail, _)
    local branch, show_branch = git_branch()

    return M.get_icon_by_failure(fail, {
        success = '{green}',
        failure = '{red}'
    }) .. '{reset} ' .. (show_branch and ' {cyan}' .. branch .. '{blue}' .. dirty() .. ' ' or '') .. '{reset}{black}| {reset}'
end

M.power_ghost_prompt = function (fail, _)
    local branch, show_branch = git_branch()

    return M.get_icon_by_failure(fail, {
        success = '{blue}',
        failure = '{red}',
    }) .. '  {cyan}%d ' .. (show_branch and '{magenta} ' .. branch .. '{green}' .. dirty('') .. ' ' or '') .. '{blue}❯{cyan}❯ {reset}'
end

function M.indicator_prompt (fail, _)
    local branch, show_branch = git_branch()

    return (fail and '{redBg}' or '{greenBg}')
        .. ' {reset} {blue}%d{reset}'
        .. (show_branch and ' {magenta}' .. branch .. '{blue}' .. dirty() .. ' ' or ' ')
end

function M.void_prompt (fail, _)
    local branch, show_branch = git_branch()

    return M.get_icon_by_failure(fail, {
        success = '{greenBg}',
        failure = '{redBg}',
    }, {
        success = '{black}  ',
        failure = '{black}  ',
    }) .. '{reset}{blackBg}{blue} %d {reset} ' .. (show_branch and '{magenta} ' .. branch .. '{reset}' .. dirty() .. ' ' or '')
end

-- change the style changing the name of the function that `hilbish.prompt` calls
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
