#!/bin/bash

# Remove existing nvim installation and configs
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/

# install neovim from source
# Prerequsites: https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
# Ubuntu / Debian
sudo apt install -y  ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen pip
# To install fonts
sudo apt install -y font-manager 
# For language servers
sudo apt install -y  python3-venv
# sudo apt install -y  npm
git clone https://github.com/neovim/neovim.git /home/$USER/neovim
pushd /home/$USER/neovim
git checkout nightly
make -j `nproc` CMAKE_BUILD_TYPE=Release
sudo make install
popd
sudo rm -rf /home/$USER/neovim
