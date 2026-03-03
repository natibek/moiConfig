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

    echo -e "\n\n${GREEN}Installing with apt: ${apt_packages[*]}${NC}"
    sudo apt install ${apt_packages[@]}
}

personal_installs () {
    snap_packages=(
        "whatsie"
        "steam"
        "obs-studio"
    )
    # sudo snap install "${snap_packages[@]}"
    for app in "${snap_packages[@]}"; do
        sudo snap install "$app"
    done
}

snap_installs () {
    snap_packages=(
        "docker"
        "lxd"
        "firefox"
        "htop"
    )

    echo -e "\n\n${GREEN}Installing with snap: ${snap_packages[*]}${NC}"
    # sudo snap install "${snap_packages[@]}"
    for app in "${snap_packages[@]}"; do
        sudo snap install "$app"
    done

    snap_classic_packages=(
        "snapcraft"
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
}

# get nerd font https://dev.to/pulkitsingh/install-nerd-fonts-or-any-fonts-easily-in-linux-2e3l
download_font () {
    if fc-list -q "NotoMonoNerdFont"; then
        echo -e "\n\n${GREEN}NotoMonoNerdFont found${NC}"
    else
        echo -e "\n\n${GREEN}Downloading NotoMonoNerdFont${NC}"
        TEMP_DIR=$(mktemp -d)
        wget -O "$TEMP_DIR/font.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Noto.zip
        unzip "$TEMP_DIR/font.zip" -d $TEMP_DIR
        sudo mv "$TEMP_DIR"/*.ttf /usr/local/share/fonts/
        fc-cache -f -v
        rm -rf "$TEMP_DIR"
    fi
}

config_desktop () {
    echo -e "\n\n${GREEN}Config terminal${NC}"
    TMP_FILE=$(mktemp)
    curl -o "$TMP_FILE" https://raw.githubusercontent.com/natibek/moiConfig/main/gnome-temrinal-config
    dconf load /org/gnome/terminal/ < "$TMP_FILE"
    rm "$TMP_FILE"

    TMP_FILE=$(mktemp)
    curl -o "$TMP_FILE" https://raw.githubusercontent.com/natibek/moiConfig/main/desktop-config
    dconf load / < "$TMP_FILE"
    rm "$TMP_FILE"
}

configs () {
    echo -e "\n\n${GREEN}Installing vim plug${NC}"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo -e "\n\n${GREEN}Installing fzf${NC}"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

    echo -e "\n\n${GREEN}Installing starship${NC}"
    curl -sS https://starship.rs/install.sh | sh

    if ! git clone git@github.com:natibek/moiConfig.git ~/moiConfig; then
        git clone https://github.com/natibek/moiConfig.git ~/moiConfig
    fi

    if [ -d ~/moiConfig ]; then
        echo -e "\n\n${GREEN}Linking config files${NC}"
        ln -sf ~/moiConfig/.vimrc ~/.vimrc
        ln -sf ~/moiConfig/.bashrc ~/.bashrc
        ln -sf ~/moiConfig/.bash_aliases ~/.bash_aliases
        ln -sf ~/moiConfig/starship.toml ~/.config/starship.toml
    else
        echo -e "\n\n${GREEN}Downloading config files${NC}"
        curl -osS ~/.vimrc https://raw.githubusercontent.com/natibek/moiConfig/main/.vimrc
        curl -osS ~/.bashrc https://raw.githubusercontent.com/natibek/moiConfig/main/.bashrc
        curl -osS ~/.bash_aliases https://raw.githubusercontent.com/natibek/moiConfig/main/.bash_aliases
        curl -osS ~/.config/starship.toml https://raw.githubusercontent.com/natibek/moiConfig/main/starship.toml
    fi

}


if [ -z "$*" ]; then
    echo -e "${IRED}No Arguments Found${NC}"
    exit 1
fi

case "$1" in
    "-help") echo -e "\ninitial-installs.sh [-help][-all][-apt][-snap][-personal][-font][-configs][-config-desktop]

    -help:           Get help
    -all:            Run all config commands
    -apt:            Install required apt packages
    -snap:           Install required snap packages
    -personal:       Install personal packages
    -font:           Download NotoMonoNerdFont
    -configs:        Miscellaneous dependencies
    -config-desktop: Config gnome terminal and desktop
"
    exit 0
    ;;
    "-all") args=("-apt" "-snap" "-font" "-configs" "-config-desktop");;
    *) args="$@";;
esac

for arg in "${args[@]}"; do
    case "$arg" in
        -snap)             snap_installs     ;;
        -personal)         personal_installs ;;
        -apt)              apt_installs      ;;
        -font)             download_font     ;;
        -configs)          configs           ;;
        -config-desktop)   config_desktop    ;;
        *) echo -e "${IRED}Unknown argument:${NC} $arg";;
    esac
done
