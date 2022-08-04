#!/bin/bash

# Remove existing nvim installation and configs
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
sudo rm -rf ~/.config/nvim 
sudo rm -rf ~/.local/share/nvim/

# install neovim from source
# Prerequsites: https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
# Ubuntu / Debian
sudo apt install -y  ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen pip
# To install fonts
sudo apt install -y font-manager 
# For language servers
 sudo apt install -y  python3-venv
# sudo apt install -y  npm
git clone https://github.com/neovim/neovim.git ~/.config/nvim/neovim
pushd ~/.config/nvim/neovim
git checkout stable
make -j `nproc` CMAKE_BUILD_TYPE=Release
sudo make install
popd

# Cleanup
sudo rm -rf ~/.config/nvim

# AstroNvim installation
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
# My Nvim configuration
git clone https://github.com/emilsahakyan/nvim.git ~/.config/nvim/lua/user

# Install Nord fonts
FDIR="/home/$USER/.local/share/fonts"
pushd ~/.config/nvim/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Ubuntu.zip .
unzip Ubuntu.zip
mkdir -p $FDIR 
mv Ubuntu*.ttf $FDIR 
rm -r Ubuntu.zip 
fc-cache -f -v

nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Lsp servers
#nvim  --headless -c 'LspInstall pyright'
#nvim  --headless -c 'LspInstall clangd'
#nvim  --headless -c 'LspInstall cmake'
#nvim  --headless -c 'LspInstall jsonls'
#nvim  --headless -c 'LspInstall sumneko_lua'
#nvim  --headless -c 'LspInstall verible'

# Treesitter
#nvim  --headless -c 'TSInstall python'
#nvim  --headless -c 'TSInstall bash'
#nvim  --headless -c 'TSInstall c'
#nvim  --headless -c 'TSInstall cmake'
#nvim  --headless -c 'TSInstall cpp'
#nvim  --headless -c 'TSInstall help'
#nvim  --headless -c 'TSInstall make'
#nvim  --headless -c 'TSInstall python'
#nvim  --headless -c 'TSInstall regex'
#nvim  --headless -c 'TSInstall verilog'
#nvim  --headless -c 'TSInstall vim'

# For debugging python scripts using DAP plugin
rm -rf /home/$USER/python/virtualenvs/debugpy
python3 -m venv /home/$USER/python/virtualenvs/debugpy
/home/$USER/python/virtualenvs/debugpy/bin/python -m pip install debugpy
