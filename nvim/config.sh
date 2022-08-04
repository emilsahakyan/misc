#!/bin/bash

# Remove any old config files
rm -rf /home/$USER/.config/nvim 
rm -rf /home/$USER/.local/share/nvim/

# AstroNvim installation
git clone https://github.com/AstroNvim/AstroNvim /home/$USER/.config/nvim
# My Nvim configuration
git clone git@github.com:emilsahakyan/nvim.git /home/$USER/.config/nvim/lua/user

# Install Nord fonts
FDIR="/home/$USER/.local/share/fonts"
pushd /home/$USER/.config/nvim/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Ubuntu.zip .
unzip Ubuntu.zip
mkdir -p $FDIR
mv Ubuntu*.ttf $FDIR
rm -r Ubuntu.zip
fc-cache -f -v

nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Install Lsp servers (manual)
#   :LspInstall pyright
#   :LspInstall clangd
#   :LspInstall cmake
#   :LspInstall jsonls
#   :LspInstall sumneko_lua
#   :LspInstall verible
#? nvim  --headless -c 'LspInstall pyright'

# Install Treesitter (manual)
# :TSInstall python
# :TSInstall bash
# :TSInstall c
# :TSInstall cmake
# :TSInstall cpp
# :TSInstall help
# :TSInstall make
# :TSInstall python
# :TSInstall regex
# :TSInstall verilog
# :TSInstall vim
#? nvim  --headless -c 'TSInstall python'

# For debugging python scripts using DAP plugin
rm -rf /home/$USER/python/virtualenvs/debugpy
python3 -m venv /home/$USER/python/virtualenvs/debugpy
/home/$USER/python/virtualenvs/debugpy/bin/python -m pip install debugpy
