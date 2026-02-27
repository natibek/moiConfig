#!/usr/bin/env bash

RED='\033[0;31m'
IRED='\033[0;91m'
GREEN='\033[0;32m'
NC='\033[0m'

apt_installs () {
    apt_packages=(
        "zoxide"
        "curl"
        "vim-gtk3"
        "git"
        "mplayer"
        "mplayer-gui"
        "gnome-shell-extension-manager"
        "python3-venv"
        "python3-pytest"
        "pulseaudio"
        "pavucontrol"
        "solaar"
        "exuberant-ctags"
        "bat"
        "ripgrep"
        "terminator"
        "ipython3"
    )

    echo -e "\n\n${GREEN}Installing with apt: ${apt_packages_str[*]}${NC}"
    sudo apt install ${apt_packages[@]}
}

snap_installs () {
    snap_packages=(
        "docker"
        "snapcraft"
        "pyright"
        "lxd"
        "firefox"
        "htop"
    )

    if [[ "$*" =~ ^--personal$ ]]; then
        snap_packages+=(
            "whatsie"
            "steam"
            "obs-studio"
        )
    fi

    # install go, docker
    echo -e "\n\n${GREEN}Installing with snap: ${snap_packages[*]}${NC}"
    sudo snap install "${snap_packages[@]}"

    # install vs-code
    snap_classic_packages=(
        "code"
        "astral-uv"
        "go"
        "pyright"
        "rustup"
        "node"
    )
    echo -e "\n\n${GREEN}Installing with snap --classic: ${snap_classic_packages[*]}${NC}"
    for app in "${snap_classic_packages[@]}"; do
        sudo snap install "$app" --classic
    done

    rustup default stable
}

# install starship
# get nerd font https://dev.to/pulkitsingh/install-nerd-fonts-or-any-fonts-easily-in-linux-2e3l
download_font () {
    echo -e "\n\n${GREEN}Downloading nerd font: Noto${NC}"
    TEMP_DIR=$(mktemp -d)
    wget -O "$TEMP_DIR/font.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Noto.zip
    unzip "$TEMP_DIR/font.zip" -d $TEMP_DIR
    sudo mv "$TEMP_DIR"/*.ttf /usr/local/share/fonts/
    fc-cache -f -v
    rm -rf "$TEMP_DIR"
}

configs () {
    # install vim-plug
    echo -e "\n\n${GREEN}Installing vim plug${NC}"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Installing fzf
    echo -e "\n\n${GREEN}Installing fzf${NC}"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

    echo -e "\n\n${GREEN}Installing starship${NC}"
    curl -sS https://starship.rs/install.sh | sh

    echo -e "\n\n${GREEN}Copying config files${NC}"
    ln -sf ~/moiConfig/.vimrc ~/.vimrc
    ln -sf ~/moiConfig/.bashrc ~/.bashrc
    ln -sf ~/moiConfig/.bash_aliases ~/.bash_aliases
    ln -sf ~/moiConfig/starship.toml ~/.config/starship.toml
}


if [ -z "$*" ]; then
    echo "Install all"
else
    for arg in "$@"; do
        case "$arg" in
            -snap)   snap_installs ;;&
            -apt)    apt_installs  ;;&
            -font)   download_font ;;&
            -config) configs       ;;&
            *) echo -e "${RED}Unknown argument:${NC} $arg";;&
        esac
    done

fi

