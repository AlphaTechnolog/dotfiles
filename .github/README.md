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

## ‎ <samp>Notice! ⚠️</samp>

If you like this configuration, please give me a star in this repo, it will make me more happy! 😁
> If you want, you can visit [more of my repos](https://github.com/AlphaTechnolog?tab=repositories) or go to [my profile](https://github.com/AlphaTechnolog)

## ‎ <samp>Information ℹ️</samp>

Here are some details about my setup:

<img src="./assets/neofetch.png" align="right" width="400px"/>

- **OS:** [Void Linux](https://voidlinux.org)
- **WM:** [bspwm](https://github.com/baskerville/bspwm)
- **Terminal:** [st](https://st.suckless.org/)
- **Shell:** bash
- **Editor:** [neovim](https://github.com/neovim/neovim)
- **NeovimConfig**: [nvcodark](https://github.com/AlphaTechnolog/nvcodark) and [nvchad](https://github.com/NvChad/NvChad)
- **Compositor:** [picom](https://github.com/yshui/picom)
- **Application Launcher:** [rofi](https://github.com/davatorium/rofi)

## ‎ <samp>Demonstration 📹</samp>

You can see the workflow video on youtube! [Click Me](https://youtu.be/Qcl_9k_RaS0)

## ‎ <samp>Setup ✏️</samp>

### Clone the repository

First clone the repository

```sh
git clone https://github.com/AlphaTechnolog/dotfiles-v2
cd dotfiles-v2
```

### Requirements ✅

Then make sure you have the next requirements installed

This is in testing phase btw, if you think i miss some pkg, please tell me it using my discord (alphatechnolog#6570) or opening an [issue](https://github.com/AlphaTechnolog/dotfiles-v2/issues/new)

#### Fonts

| **font** | **utility** |
|----------|-------------|
|Iosevka Nerd Font|Bar font|
|CaskaydiaCove Nerd Font|General Font|

> [Download site](https://www.nerdfonts.com/font-downloads)

#### Dependencies

| **dependency** | **utility** |
|----------------|-------------|
|bspwm|The window manager|
|sxhkd|The hotkeys daemon|
|eww|Literally the most of this ui is written using eww (tested with eww 0.2.0)|
|picom|The compositor, i'm using the [Arian8j's picom fork](https://github.com/Arian8j2/picom)|
|bash|The shell|
|starship|With starship you can customize the prompt of any shell|
|feh|Set wallpaper and image viewer|
|bat|Enhanced cat|
|exa|Enhanced ls (using for tree too)|
|dunst|Customizable notifications|
|rofi|Apps launcher|
|playerctl|Remotely music management|
|light|Manage the brightness using the cli|
|brightnessctl|Another way to get/manage the brightness using the cli|
|iwgetid|Get the connected wifi SSID|
|amixer|Manage the audio|
|wmutils/opt|Make borders scripts works|

> You can use the pkg for install the mayority of the pkgs

> for wmutils/opt you can try with the next commands:

```sh
git clone https://github.com/wmutils/opt.git && cd opt
make && sudo make install
```

### Copy the configs

**WARNING**: Configuration files may be overrided.

```sh
cp -r ./cfg/* ~/.config
cp -r ./bin/* ~/.local/bin
cp -r ./home/bashrc ~/.bashrc
cp -r ./home/Xresources ~/.Xresources
```

### Compile st

Compile my build of st (this is the default terminal, but you can change it in the sxhkd configuration):

```sh
cd ~/.config/st
./rebuild.sh
```

> It could throws some errors, make sure you have the correct dependencies for st like `harfbuzz` and `imlib2` (if not luck, try installing the `-dev` or `-devel` pkgs)

### Enjoy ❤️

That's all! Now enjoy with this configuration!

## ‎ <samp>Tips 😎</samp>

### Multi theming support

I'm working in multi theming support for the config using a tool that I'm writing from scratch, [this is](../bin/themer).

The tool reads files from `~/.config/themes/templates` and recreate all the necessary files to apply the changes, in this config
i included two templates: dark-decay and night theme by [rxyhn](https://github.com/rxyhn).

You can change the theme using `themer -s <themename>` or `themer --switch <themename>`, more info could be obtained using:

```sh
themer --help
themer -h
```

so, you can write your own themes too using the templates in `~/.config/themes/templates` and then calling it using `themer`.

#### Demonstration

![themer-demonstration](./assets/themer.png)

### Neovim

If you want to open neovim without padding in st terminal, you can use `nv` instead of `neovim` (because in [bin](../bin) i put the `nv` script)

### Some keyboards shortcuts

| **shortcut** | **meaning** |
|--------------|-------------|
|super + shift + return|Open rofi|
|super + m|Toggle bar state (if show or not)|
|super + b|Spawn firefox|
|super + x|Spawn a screen color picker|
|super + alt + {h,j,k,l}|Resize the window|
|super + ctrl + {h,j,k,l}|Move a floating window|
|super + escape|Restart sxhkd|
|super + shift + q|Quit bspwm|
|super + shift + r|Restart bspwm|
|super + w|Close window|
|super + Tab|Alternate between monocle and tiled layout|
|super + space|Switch to floating layout|
|super + t|Switch to tiled layout|
|super + f|Switch to fullscreen layout|

> In the most of the cases, exists mouse based keybindings (but i really prefer use the shortcuts lol)

## ‎ <samp>Thanks to 😁</samp>

I want to say really thanks to the next people, because they helped me with some things to make this rice possible:

- [leo](https://github.com/justleoo)
- [Bleyom](https://github.com/Bleyom)
- [PanicKk](https://github.com/PanicKk)
- [rxyhn](https://github.com/rxyhn) (night theme)
