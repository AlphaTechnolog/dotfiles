local rc = {}
local ansikit = require 'ansikit'

-- in construction rc
rc.default_conf = {
    prompt = {
        do_end_line = true, -- append an enter after command execution
        style = 'blocks', -- blocks or ghost
        vim_mode = {
            cursors_case = {
                insert = ansikit.lineCursor,
                others = ansikit.blockCursor,
            },
        }
    }
}

rc.get_rc = function ()
    local ok, mod = pcall(require, 'rc')
    if not ok then
        return rc.default_conf
    else
        return mod
    end
end

return rc
