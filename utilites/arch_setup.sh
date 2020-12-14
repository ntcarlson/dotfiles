#!/usr/bin/env bash

# Misc. utilities
pkgs_util=(xdotool wget unzip zsh cmake openvpn htop feh bc imagemagick fzf)

# Fonts
pkgs_fonts=(otf-fira-sans         # Prinary sans serif font
            ttf-fira-code         # Terminal/editor font with ligatures
            ttf-font-awesome      # Symbolic font for icons
            ttf-font-awesome-4    # Symbolic font for icons
)

# Packages related to the desktop environment
pkgs_de=(i3-gaps-next-git               # Window manager
         i3lock-color-git               # Lock screen
         picom-git                      # Compositor
         polybar-git                    # Status bar
         rofi-git                       # Launcher
         kitty                          # Terminal
         conky-git                      # System monitor
         lightdm-gtk-greeter            # Login screen
         lxappearance                   # Tool to set GTK theme
         numix-circle-icon-theme-git    # Icon set
         nordic-theme-git               # GTK theme
         qt5-styleplugins               # Allows using GTK theme for Qt5
)

# Applications
pkgs_apps=(gvim                    # Text editor
           firefox                 # Web browser
           code                    # IDE
           spotify spicetify-cli   # Music client (with themer)
           transmission-gtk        # Torrent client
           libreoffice-still       # Office suite
           inkscape gimp           # Image editors
           thunar ranger           # File browsers
           evince zathura          # PDF viewers
           steam lutris            # Game launchers
           keepassxc               # Password manager
           texlive-most            # LaTeX distribution
           jellyfin-server-bin     # Media server
           jellyfin-web-bin        # Media player
           openscad prusa-slicer   # CAD and slicer for 3d printing
)

yay -Syu ${pkgs_util[@]} ${pkgs_fonts[@]} ${pkgs_de[@]} ${pkgs_apps[@]}

# Link configuration files to appropriate locations
cd $(dirname $(realpath $0))/../

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm $HOME/.zshrc
ln -s $(realpath zshrc) $HOME/.zshrc
ln -s $(realpath oh-my-zsh/*.theme) $HOME/.oh-my-zsh/themes/

mkdir -p $HOME/.vim/bundle
ln -s $(realpath vimrc) $HOME/.vimrc
ln -s $(realpath gvimrc) $HOME/.gvimrc
ln -s $(realpath vim/UltiSnips) $HOME/.vim/UltiSnips
ln -s $(realpath vim/ftplugin) $HOME/.vim/ftplugin
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qa

ln -s $(realpath texmf) $HOME/texmf

ln -s $(realpath Xresources) $HOME/.Xresources

mkdir -p $HOME/.local/share/applications
ln -s $(realpath applications/curated) $HOME/.local/share/applications

mkdir -p $HOME/.config
ln -s $(realpath i3) $HOME/.config/i3
ln -s $(realpath config/polybar) $HOME/.config/polybar
ln -s $(realpath config/rofi) $HOME/.config/rofi
ln -s $(realpath config/conky) $HOME/.config/conky
ln -s $(realpath config/zathura) $HOME/.config/zathura
ln -s $(realpath config/picom.conf) $HOME/.config/picom.conf
mkdir -p $HOME/.config/kitty
ln -s $(realpath config/kitty/kitty.conf) $HOME/.config/kitty/
