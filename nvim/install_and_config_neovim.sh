#!/bin/bash

# Remove existing nvim installation and configs
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
rm -rf ~/.config/nvim 
rm -rf ~/.local/share/nvim/

# install neovim from source
# Prerequsites: https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
    # Ubuntu / Debian
    # sudo apt install -y  install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
    # sudo apt install -y font-manager 
git clone https://github.com/neovim/neovim.git ~/.config/nvim/neovim
pushd ~/.config/nvim/neovim
git checkout stable
make -j `nproc` CMAKE_BUILD_TYPE=Release
sudo make install
echo "DONE installing nvim"

popd
# Cleanup
rm -rf ~/.config/nvim
echo "DONE clean up"

# AstroNvim installation
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
echo "CLONED AstroNvim"
# My Nvim configuration
git clone https://github.com/emilsahakyan/nvim.git ~/.config/nvim/lua/user
echo "CLONED config"

# Install Nord fonts
FDIR="/home/$USER/.local/share/fonts"
pushd ~/.config/nvim/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Ubuntu.zip .
unzip Ubuntu.zip
mkdir -p $FDIR 
mv Ubuntu/* $FDIR 
rm -r Ubuntu Ubuntu.zip 

# For language servers

sudo apt install -y  python3-venv npm
# Lsp servers
nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim  --headless -c 'LspInstall pyright'
nvim  --headless -c 'LspInstall clangd'
nvim  --headless -c 'LspInstall cmake'
nvim  --headless -c 'LspInstall jsonls'
nvim  --headless -c 'LspInstall sumneko_lua'
nvim  --headless -c 'LspInstall verible'

# Treesitter
nvim  --headless -c 'TSInstall python'
nvim  --headless -c 'TSInstall bash'
nvim  --headless -c 'TSInstall c'
nvim  --headless -c 'TSInstall cmake'
nvim  --headless -c 'TSInstall cpp'
nvim  --headless -c 'TSInstall help'
nvim  --headless -c 'TSInstall make'
nvim  --headless -c 'TSInstall python'
nvim  --headless -c 'TSInstall regex'
nvim  --headless -c 'TSInstall verilog'
nvim  --headless -c 'TSInstall vim'

# Uncomment for debugging python scrips using DAP
python -m venv /home/$USER/python/virtualenvs/debugpy
/home/$USER/python/virtualenvs/debugpy/bin/python -m pip install debugpy
