<!-- inspired by rxyhn's readme -->

<!-- RICE PREVIEW -->
<div align="center">
   <a href="#--------">
      <img src="assets/banner.png" alt="Rice Preview">
   </a>
</div>

<br>

<!-- BADGES -->
<h1>
  <a href="#--------">
    <img alt="" align="left" src="https://img.shields.io/github/stars/AlphaTechnolog/dotfiles-v2?color=f1cf8a&labelColor=f1cf8a&style=for-the-badge"/>
  </a>
  <a href="#--------">
    <img alt="" align="right" src="https://badges.pufler.dev/visits/AlphaTechnolog/dotfiles-v2?style=for-the-badge&color=7ddac5&logoColor=white&labelColor=7ddac5"/>
  </a>
</h1>

<br>

## Hi there! Thanks for dropping by! :blue_heart:
<b>  AlphaTechnolog's bspwm Rice  </b>

Welcome! This is the repository for my bspwm rice using my own theme called decay (darker version)

<!-- INFORMATION -->
## ‎ <samp>Information</samp> 

Here are some details about my setup:

- **OS:** [Void Linux](https://voidlinux.org)
- **WM:** [bspwm](https://github.com/baskerville/bspwm)
- **Terminal:** [st](https://st.suckless.org/)
- **Shell:** bash
- **Editor:** [neovim](https://github.com/neovim/neovim)
- **NeovimConfig**: [nvcodark](https://github.com/AlphaTechnolog/nvcodark) and [nvchad](https://github.com/NvChad/NvChad)
- **Compositor:** [picom](https://github.com/yshui/picom)
- **Application Launcher:** [rofi](https://github.com/davatorium/rofi)

<!-- SETUP -->
## ‎ <samp>Setup</samp>

First clone the repository

```sh
git clone https://github.com/AlphaTechnolog/dotfiles-v2
cd dotfiles-v2
```

Then install the next requirements

- Iosevka Nerd Font
- CaskaydiaCove Nerd Font
- bspwm
- sxhkd
- picom
- fish
- starship
- feh
- bat
- exa
- eww
- dunst
- rofi
- light
- wireless_tools (for iwgetid)
- alsa-tools (for amixer)
- pulseaudio-alsa
- playerctl

Then copy the configs

**WARNING**: Configuration files may be overrided.

```sh
cp -r ./cfg/* ~/.config
cp -r ./bin/* ~/.local/bin
cp -r ./home/bashrc ~/.bashrc
cp -r ./home/Xresources ~/.Xresources
```

Then compile my build of st (this is the default terminal, but you can change it in the sxhkd configuration):

```sh
cd ~/.config/st
rm config.h && sudo make clean install
```

> It could throws some errors, make sure you have the correct dependencies for st like `harfbuzz` and `imlib2` (if not luck, try installing the `-dev` or `-devel` pkgs)

## Tips

If you want to open neovim without padding in st terminal, you can use `nv` instead of `neovim` (because in [bin](./bin) i put the `nv` script)
