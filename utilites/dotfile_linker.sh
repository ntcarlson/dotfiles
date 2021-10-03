#!/usr/bin/env bash


link() {
    local src=$(realpath $1)
    local dest=($realpath $2)
    if [ ! -e $dest ]; then
        echo "Linking $src to $dest"
        ln -s $src $dest
    else
        echo "$dest already exists. Skipping..."
    fi
}

cd $(dirname $(realpath $0))/../

link zsh/zshrc $HOME/.zshrc

link vim/vimrc $HOME/.vimrc
link vim/gvimrc $HOME/.gvimrc
mkdir -p $HOME/.vim
link vim/UltiSnips $HOME/.vim/UltiSnips
link vim/UltiSnips $HOME/.vim/ftplugin

link Xresources $HOME/.Xresources
xrdb load $HOME/.Xresources

link i3 $HOME/.config/i3

link config/rofi $HOME/.config/rofi
link config/conky $HOME/.config/conky
link config/picom.conf $HOME/.config/picom.conf
link config/polybar $HOME/.config/polybar
