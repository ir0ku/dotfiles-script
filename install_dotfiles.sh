#!/bin/bash

# Preinstall
mkdir -p ~/Downloads
cd ~/Downloads || exit
git clone https://github.com/HynDuf7/dotfiles

# Set up scripts
mkdir -p ~/bin
cp -r ~/Downloads/dotfiles/bin ~/bin
chmod +x ~/bin/*

# Update PATH
if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc && ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.zshrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    echo "Added ~/bin to PATH in .bashrc and .zshrc. Remember to source your shell configuration."
fi

# Install dependencies
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm
cd .. || exit
yay -S --needed bspwm brightnessctl dunst eww-git feh i3lock-color nerd-fonts-jetbrains-mono polybar pomo papirus-icon-theme ranger rofi rofi-calc rofi-emoji sxhkd ttf-fira-code ttf-iosevka-nerd ueberzug xdotool

# Background wallpaper
mkdir -p ~/Pictures
cp -r ~/Downloads/dotfiles/wallpapers ~/Pictures

# Polybar setup
mkdir -p ~/.fonts
git clone https://github.com/Murzchnvok/polybar-collection ~/Downloads/polybar-collection
cp -r ~/Downloads/polybar-collection/fonts/* ~/.fonts/
fc-cache -fv
cp -r ~/Downloads/dotfiles/.config/polybar ~/.config/polybar
chmod +x ~/.config/polybar/launch.sh

# Dunst configuration
cp -r ~/Downloads/dotfiles/.config/dunst ~/.config/dunst

# Rofi and Eww configuration
cp -r ~/Downloads/dotfiles/.config/rofi ~/.config/rofi
cp -r ~/Downloads/dotfiles/.config/eww ~/.config/eww

# Picom installation
yay -S --needed libconfig libev libxdg-basedir pcre pixman xcb-util-image xcb-util-renderutil hicolor-icon-theme libglvnd libx11 libxcb libxext libdbus asciidoc uthash
git clone https://github.com/pijulius/picom.git ~/Downloads/picom
cd ~/Downloads/picom || exit
meson --buildtype=release . build --prefix=/usr -Dwith_docs=true
sudo ninja -C build install
cp -r ~/Downloads/dotfiles/.config/picom ~/.config/picom

# Add startup commands to bspwmrc
{
    echo 'feh --bg-fill ~/Pictures/hollow-knight.png &'
    echo '$HOME/.config/polybar/launch.sh &'
    echo 'dunst -conf $HOME/.config/dunst/dunstrc &'
    echo 'picom &'
} >> ~/.config/bspwm/bspwmrc

echo "Installation complete! Please source your .bashrc or .zshrc and restart bspwm."

