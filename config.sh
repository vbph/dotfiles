#!/bin/sh

OS=$(uname -s)
DIR=$(pwd)
CONFIG_HOME=$HOME/.config
MACOS_APP_SUPPORT=$HOME/Library/ApplicationSupport

source $DIR/utils.sh

prettyecho Apply configs

if [ $OS = Linux ]; then

    # Docker
    prettyecho Start Docker with systemd
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    sudo usermod -aG docker $USER

    # Bluetooth
    prettyecho Start Bluetooth with systemd
    sudo systemctl enable bluetooth.service

    # Xfce
    prettyecho Apply Xfce configs
    symlink $DIR/xfce4/fonts.xml $CONFIG_HOME/fontconfig/fonts.conf

    XFCE_CONFIG=$CONFIG_HOME/xfce4/xfconf/xfce-perchannel-xml
    symlink $DIR/xfce4/keyboard_shortcuts.xml $XFCE_CONFIG/xfce4-keyboard-shortcuts.xml
    symlink $DIR/xfce4/xsettings.xml $XFCE_CONFIG/xsettings.xml

    # Nvidia
    prettyecho Apply Nvidia configs
    sudo cp $DIR/nvidia/nvidia.hook /etc/pacman.d/hooks/nvidia.hook
    sudo cp $DIR/nvidia/70-nvidia.rules /etc/udev/rules.d/70-nvidia.rules
    nvidia-settings --load-config-only

elif [ $OS = Darwin ]; then

    # Apple's Application Support is an absolute piece of shit
    prettyecho Symbolic link for Application Support
    rm -rf $MACOS_APP_SUPPORT
    ln -s $HOME/Library/Application\ Support $MACOS_APP_SUPPORT

fi

# Git
prettyecho Apply Git configs
symlink $DIR/.gitconfig $HOME/.gitconfig

# Zsh
prettyecho Apply Zsh configs
symlink $DIR/.zshrc $HOME/.zshrc

# Ghostty
prettyecho Apply Ghostty configs
symlink $DIR/ghostty/config $CONFIG_HOME/ghostty/config

if [ $OS = Darwin ]; then
    symlink $DIR/ghostty/macos_override $CONFIG_HOME/ghostty/macos_override
fi

# Tmux
prettyecho Apply Tmux configs
symlink $DIR/tmux/.tmux.conf $HOME/.tmux.conf
symlink $DIR/tmux/.tmux.sh $HOME/.tmux.sh

# Zellij
prettyecho Apply Zellij configs
symlink $DIR/zellij/config.kdl $CONFIG_HOME/zellij/config.kdl
symlink $DIR/zellij/bygone_days.kdl $CONFIG_HOME/zellij/layouts/bygone_days.kdl

# Neovim
prettyecho Apply Neovim configs
symlink $DIR/neovim $CONFIG_HOME/nvim

# Code
prettyecho Apply Code configs

if [ $OS = Linux ]; then
    CODE_BIN=/opt/vscodium-bin
    CODE_CONFIG=$CONFIG_HOME/VSCodium
elif [ $OS = Darwin ]; then
    CODE_BIN=/Applications/VSCodium.app/Contents/MacOS/VSCodium
    CODE_CONFIG=$MACOS_APP_SUPPORT/VSCodium
fi

sudo chown -R $(whoami) $CODE_BIN

symlink $DIR/vscodium/settings.json $CODE_CONFIG/User/settings.json
symlink $DIR/vscodium/keybindings.json $CODE_CONFIG/User/keybindings.json
symlink $DIR/vscodium/product.json $CODE_CONFIG/product.json
