# exit if not in interactive mode
status -i || exit

set fish_greeting ""

# aliases
alias ls='exa --icons'
alias la='exa --icons -la'
alias tree='exa --icons --tree'
alias cat='bat --theme base16 --paging=never --style=plain'
alias g='copier -c github_token 2>&1 > /dev/null && git' # @requires: [copier](https://github.com/AlphaTechnolog/copier)

# color
set fish_color_normal brwhite
set fish_color_command brgreen
set fish_color_param brwhite
set fish_color_error brred
set fish_color_quote bryellow

# vi-mode
set fish_cursor_default block
set fish_cursor_insert block
set fish_cursor_replace_one underscore
set fish_cursor_visual block

# env
export PATH="$PATH:$HOME/.spicetify:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.cargo/bin"

# comment to disable vi mode
fish_vi_key_bindings

# starship
starship init fish | source
