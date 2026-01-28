#!/usr/bin/env bash
sudo -i

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
)

apt_packages_str="${apt_packages[*]}"
echo "Installing with apt: ""$apt_packages_str"
sudo apt install "$apt_packages_str"

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

snap_packages=(
    "docker"
    "snapcraft"
    "pyright"
    "node"
    "rustup"
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

snap_packages_str="${snap_packages[*]}"
# install go, docker
echo "Installing with snap: ""$snap_packages_str"
sudo snap install "$snap_packages_str"

# install vs-code
snap_classic_packages=(
    "code"
    "astral-uv"
    "go"
    "pyright"
)
echo "Installing with snap --classic: ""${snap_classic_packages[*]}"
for app in "${snap_classic_packages[@]}"; do
    sudo snap install "$app" --classic
done

# install starship
# get nerd font https://dev.to/pulkitsingh/install-nerd-fonts-or-any-fonts-easily-in-linux-2e3l
download_font() {
    echo "Downloading nerd font: Noto"
    TEMP_DIR=$(mktemp -d)
    wget -O "$TEMP_DIR/font.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.4.0/Noto.zip
    unzip "$TEMP_DIR/font.zip" -d $TEMP_DIR
    sudo mv "$TEMP_DIR"/*.{ttf} /usr/local/share/fonts/
    fc-cache -f -v
    rm -rf "$TEMP_DIR"
}
download_font
#
# Installing fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

echo "Installing starship"
curl -sS https://starship.rs/install.sh | sh

(cd ~ && \
    git clone https://github.com/natibek/moiConfig.git &&\
    ln -sf ~/moiConfig/.vimrc .vimrc; \
    ln -sf ~/moiConfig/.bashrc .bashrc; \
    ln -sf ~/moiConfig/.bash_aliases .bash_aliases;
)

