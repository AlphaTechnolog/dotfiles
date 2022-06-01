function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold magenta
      echo "󰊠 "
    case insert
      set_color --bold green
      echo "󰊠 "
    case replace_one
      set_color --bold red
      echo "󰊠 "
    case visual
      set_color --bold cyan
      echo "󰊠 "
    case '*'
      set_color --bold magenta
      echo "󰊠 "
  end
  set_color green
end
