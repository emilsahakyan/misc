#!/bin/bash

# Remove existing nvim installation and configs
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
rm -r ~/.config/nvim 
rm -rf ~/.local/share/nvim/

# install neovim from source
# Prerequsites: https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
git clone https://github.com/neovim/neovim.git ~/.config/nvim/neovim
cd ~/.config/nvim/neovim
git checkout stable
make -j `nproc` CMAKE_BUILD_TYPE=Release
sudo make install

# Cleanup
rm -rf ~/.config/nvim/neovim
git clone https://github.com/emilsahakyan/nvim.git ~/.config/nvim/
nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim +LspInstall pyright
nvim +LspInstall clangd
nvim +LspInstall cmake
nvim +LspInstall jsonls
nvim +LspInstall pyright
nvim +LspInstall sumneko_lua
nvim +LspInstall verible

nvim :TSInstall python
nvim :TSInstall bash
nvim :TSInstall c
nvim :TSInstall cmake
nvim :TSInstall cpp
nvim :TSInstall help
nvim :TSInstall make
nvim :TSInstall python
nvim :TSInstall regex
nvim :TSInstall verilog
nvim :TSInstall vim


# For debugging python scrips using DAP
python -m venv /home/$USER/python/virtualenvs/debugpy
/home/$USER/python/virtualenvs/debugpy/bin/python -m pip install debugpy
