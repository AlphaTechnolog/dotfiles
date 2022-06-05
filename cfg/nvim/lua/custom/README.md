# Custom

A custom entry is a file with a package that contains a function
named `init`, it load where you want

## Example: autocmds

In the folder examples you can view a file named `autocmds.lua`, copy
it to `lua/custom`:

```sh
cp -r ./lua/custom/examples/autocmds.lua ./lua/custom/autocmds.lua
```

And then edit it:

```lua
local M = {}

M.autocmds = function ()
  -- write your autocmds here
  vim.cmd [[ autocmd FileType php setlocal tabstop=4 shiftwidth=4 ]]
  vim.cmd [[ autocmd FileType python setlocal tabstop=4 shiftwidth=4 ]]
end

return M
```

Edit it as you want

## Activating in config

Edit `lua/rc.lua` and write a code like this:

```lua
config.custom = {
  load = {
    autocmds = true,
  },
}
```

It enable the autocmds custom file

## Explaining

In your private config you may specify a load dict that contains
as a key the name of the file to load into `lua/custom` and as
value, if you want to enable it or not.
