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
    <img alt="" align="left" src="https://img.shields.io/github/stars/AlphaTechnolog/dotfiles?color=f1cf8a&labelColor=f1cf8a&style=for-the-badge"/>
  </a>
  <a href="#--------">
    <img alt="" align="right" src="https://api.visitorbadge.io/api/visitors?path=AlphaTechnolog%2Fdotfiles&label=Views&labelColor=%2386aaec&countColor=%2386aaec" />
  </a>
</h1>

<br>

## Hi there! Thanks for dropping by! :blue_heart:
<b>  AlphaTechnolog's WIP AwesomeWM Rice  </b>

Welcome! This is the repository for my awesomewm rice using [decay](https://github.com/decaycs) (decayce variant)

> WIP cuz notifications aren't configured yet (btw WIP = Work In Progress)

## ‎ <samp>Notice! ⚠️</samp>

If you like this configuration, please give me a star in this repo, it will make me more happy! 😁
> If you want, you can visit [more of my repos](https://github.com/AlphaTechnolog?tab=repositories) or go to [my profile](https://github.com/AlphaTechnolog)
> Ah, and gimme credits if you will use my config for showcase :3
> If you're looking for the old bspwm rice, go to the [bspwm](https://github.com/AlphaTechnolog/dotfiles/tree/bspwm) branch

## ‎ <samp>Information ℹ️</samp>

Here are some details about my setup:

<img src="./assets/neofetch.png" align="right" width="400px"/>

- **OS:** [Void Linux](https://voidlinux.org)
- **WM:** [AwesomeWM](https://github.com/awesomeWM/awesome)
- **Terminal:** [kitty](https://github.com/kovidgoyal/kitty)
- **Shell:** [hilbish](https://github.com/Rosettea/Hilbish)
- **Editor:** [neovim](https://github.com/neovim/neovim)
- **NeovimConfig**: [nvcodark](https://github.com/AlphaTechnolog/nvcodark) (I'm using the remake that is present in the dev branch, instructions aren't ready yet, main branch is broken)
- **Compositor:** [picom](https://github.com/yshui/picom)
- **Application Launcher:** [rofi](https://github.com/davatorium/rofi)

## ‎ <samp>Setup ✏️</samp>

### Clone the repository

First clone the repository

```sh
git clone https://github.com/AlphaTechnolog/dotfiles
cd dotfiles
```

### Requirements ✅

Then make sure you have the next requirements installed

This is in testing phase btw, if you think i miss some pkg, please tell me it opening an [issue](https://github.com/AlphaTechnolog/dotfiles/issues/new)

#### Fonts

| **font** | **utility** |
|----------|-------------|
|[Product Sans (Google Sans)](https://www.cufonfonts.com/font/google-sans)|Main UI Font|
|[Iosevka Nerd Font](https://nerdfonts.com/font-downloads)|Some icons, others are rendered using svg|
|[CaskaydiaCove Nerd Font](https://nerdfonts.com/font-downloads)|Terminal font|

#### Dependencies

| **dependency** | **utility** |
|----------------|-------------|
|awesomeWM|The window manager (Use the GIT version)|
|picom|The compositor, i'm using the [Arian8j's picom fork](https://github.com/Arian8j2/picom)|
|hilbish|The shell|
|bat|Enhanced cat|
|exa|Enhanced ls (using for tree too)|
|rofi|Apps launcher|
|playerctl|Remotely music management (needs to use dbus, use dbus-run-session if your session isn't started with dbus)|
|light|Manage the brightness using the cli|
|pulseaudio|Well, just the audio manager|
|pactl|Manage pulseaudio using the cli|

### Copy the configs

**WARNING**: Configuration files may be overrided.

```sh
cp -r ./cfg/* ~/.config
cp -r ./bin/* ~/.local/bin
```

### Galery

#### The Desktop

![desktop](./assets/galery/desktop.png)

#### Actions Sidebar

![sidebar](./assets/galery/sidebar.png)

#### Task preview (using bling)

![task-preview](./assets/galery/task-preview.png)

#### Tags Preview (using bling)

![tags-preview](./assets/galery/tags-preview.png)

### Enjoy ❤️

That's all! Now enjoy with this configuration!

## ‎ <samp>Tips 😎</samp>

### Some keyboards shortcuts

| **shortcut** | **meaning** |
|--------------|-------------|
|super + shift + return|Open rofi|
|super + m|Maximize window|
|super + {j,k}|Move Window Focus|
|super + {h,l}|Resize the window|
|super + shift + q|Quit AwesomeWM|
|super + ctrl + r|Restart AwesomeWM|
|super + w|Close window|
|super + Tab|Switch layouts|

> In the most of the cases, exists mouse based keybindings (but i really prefer the shortcuts lol)

### Bling

You can use the official bling module, but I made some modifications in the source code
of bling to add multimonitor support in some parts, it's recommended to use my own version (for this dotfiles at least),
but anyway you can use another version or modification of the bling module if you want
