# St (Suckless Terminal)

## Xresources live-reload demo

<img src="https://github.com/siduck/dotfiles/blob/all/rice%20flex/live-reloadXresources.gif"> <br><br>

## Dependencies

```
# Void 
xbps-install libXft-devel libX11-devel harfbuzz-devel libXext-devel libXrender-devel libXinerama-devel
 
# Debian (and ubuntu probably)
apt install build-essential libxft-dev libharfbuzz-dev 

(most of these are already installed on Arch based distros)

# Install font-symbola and libXft-bgra
```

## Install

```
git clone https://github.com/siduck/st.git
cd st
sudo make install 
xrdb merge pathToXresourcesFile
```

(note : put the xrdb merge command in your wm's autostart or similar) 

## Fonts 

- Install JetbrainsMono Mono Nerd Font or any nerd font from [here](https://www.nerdfonts.com/font-downloads)

## Patches:

- Ligatures
- sixel (check sixel branch)
- scrollback
- Clipboard
- Alpha(Transparency)
- Boxdraw
- patch_column ( doesnt cut text while resizing)
- font2
- right click paste
- st desktop entry
- newterm
- anygeometry
- xresources
- sync patch ( Better draw timing to reduce flicker/tearing and improve animation smoothness )
- live reload ( change colors/fonts on the fly )
  and more...
  <br>

## Xresources live-reload

```
# make an alias for this command

alias rel="xrdb merge pathToXresourcesFile && kill -USR1 $(pidof st)"
```

## Ram usage comparison with other terminals and speed test
<img src="https://raw.githubusercontent.com/siduck/dotfiles/all/rice%20flex/terminal_ramUsage.jpg"> <br><br>
<img src="https://raw.githubusercontent.com/siduck/dotfiles/all/rice%20flex/speedTest.png"> <br><br>
<img src="https://raw.githubusercontent.com/siduck/dotfiles/all/rice%20flex/speedTest1.png"> <br><br>

( note : This benchmark was done on my low end machine which has a pentium cpu so the speed results might vary )

## Default Keybindings<br>

<pre>
ctrl + shift + c        Copy  <br>
ctrl + shift + v        Paste <br>
right click on the terminal ( will paste the copied thing ) 

(Zoom)
alt  + comma            Zoom in <br>
alt  + .                Zoom out <br>
alt  + g                Reset Zoom<br>

(Transparency)
alt  + s                Increase Transparency<br>
alt  + a                Decrease Transparency<br>
alt  + m                Reset Transparency<br>

alt + k                 scroll down 
alt + j                 scroll up

mod + shift + enter    open a new terminal with same cwd ( current working directory )
</pre>

you can change all of these in config.h
<br>

## Themes/Fonts used

- ls-icons: https://github.com/Yash-Handa/logo-ls <br>
- Xresources: onedark ( just xrdb merge xresourcesfile , do this everytime you make any change to xresources file ) from this repo itself.<br>
- Font: JetbrainsMono Nerd Font + material design icon fonts

## Screenshots:

<img src="https://raw.githubusercontent.com/siduck/dotfiles/all/misc/delete_this/bruh.png"> <br><br>
<img src="https://raw.githubusercontent.com/siduck/dotfiles/all/misc/delete_this/ithree0-36-43.png"> <br><br>
<img src="https://raw.githubusercontent.com/siduck/dotfiles/all/misc/delete_this/two7-00.png"> <br><br>
<img src="https://raw.githubusercontent.com/siduck/dotfiles/all/misc/delete_this/u.png"> <br><hr>

# Credits

- [live-reload](https://github.com/nimaipatel/st) 
- [patch_column](https://github.com/nimaipatel/st/blob/all/patches/7672445bab01cb4e861651dc540566ac22e25812.diff)

## Other St builds <br>

1. Sixel St (sixel branch , with sixel graphics support)
2. St with vim-browse (vim-browse branch , navigate within like vim)
3. Awesomewm users might face a weird gaps issue (#23) so they need to use the anysize branch.

- Use a different st build ( clone its branch)

`example: git clone https://github.com/siduck/st --branch sixel`
