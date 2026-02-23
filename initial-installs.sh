#!/usr/bin/env bash
install_apt () {
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
    )

    apt_packages_str="${apt_packages[*]}"
    echo "Installing with apt: ""$apt_packages_str"
    sudo apt install "$apt_packages_str"
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
    echo -e "\n\nInstalling with snap: ""${snap_packages[*]}"
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
    echo -e "\n\nInstalling with snap --classic: ""${snap_classic_packages[*]}"
    for app in "${snap_classic_packages[@]}"; do
        sudo snap install "$app" --classic
    done

    rustup default stable
}

# install starship
# get nerd font https://dev.to/pulkitsingh/install-nerd-fonts-or-any-fonts-easily-in-linux-2e3l
download_font () {
    echo -e "\n\nDownloading nerd font: Noto"
    TEMP_DIR=$(mktemp -d)
    wget -O "$TEMP_DIR/font.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Noto.zip
    unzip "$TEMP_DIR/font.zip" -d $TEMP_DIR
    sudo mv "$TEMP_DIR"/*.ttf /usr/local/share/fonts/
    fc-cache -f -v
    rm -rf "$TEMP_DIR"
}

config_other () {
    # install vim-plug
    echo -e "\n\nInstalling vim plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Installing fzf
    echo -e "\n\nInstalling fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

    echo -e "\n\nInstalling starship"
    curl -sS https://starship.rs/install.sh | sh

    echo -e "\n\nCopying config files"
    ln -sf ~/moiConfig/.vimrc ~/.vimrc
    ln -sf ~/moiConfig/.bashrc ~/.bashrc
    ln -sf ~/moiConfig/.bash_aliases ~/.bash_aliases
    ln -sf ~/moiConfig/starship.toml ~/.config/starship.toml
}


case $- in
    *i*) ;;
    *) return ;;
esac

if [[ "$*" =~ ^--personal$ ]]; then
fi
