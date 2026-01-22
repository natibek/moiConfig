#!/usr/bin/env bash

sudo -i

echo "Installing zoxide, curl, vim-gtk3, git, fzf, mplayer, gnome-shell-extension-manager"
sudo apt install \
    zoxide \
    curl \
    vim-gtk3 \
    git \
    fzf \
    mplayer mplayer-gui \
    gnome-shell-extension-manager \
    python3-venv \
    python3-pytest \

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install go, docker
echo "Installing go, docker, snapcraft, astral-uv, pyright, node, rustup"
sudo snap install \
    go \
    docker \
    snapcraft \
    astral-uv \
    pyright \
    node \
    rustup \

# install vs-code
echo "Installing vs-code"
sudo snap install code --classic

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

echo "Installing starship"
curl -sS https://starship.rs/install.sh | sh

(cd ~ && \
    git clone https://github.com/natibek/moiConfig.git &&\
    ln -sf ~/moiConfig/.vimrc .vimrc; \
    ln -sf ~/moiConfig/.bashrc .bashrc; \
    ln -sf ~/moiConfig/.bash_aliases .bash_aliases;
)

# Installing fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
