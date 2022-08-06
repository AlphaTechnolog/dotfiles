if not hilbish.interactive then
   return
end

local prompt = require("prompt")
local path = require "path"
local aliases = require("aliases")
local commands = require('commands')
local present, custom = pcall(require, 'custom')

aliases.load_aliases()
path.setup()
prompt.setup()
commands.setup()

if present then
  custom.setup()
end
