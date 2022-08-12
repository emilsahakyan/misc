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

# Temporally disable prompts for updates
sed -i 's/skip_prompts = false/skip_prompts = true/' /home/$USER/.config/nvim/lua/user/updater.lua
# Update the AstroNvim to the version corresponding to what is set via the 'updater.lua' config
nvim --headless -c 'AstroUpdate' -c 'quitall'
# Compile with the user configs
nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Revert the prompt flag change
pushd /home/$USER/.config/nvim/lua/user/
git checkout updater.lua
popd

# For debugging python scripts using DAP plugin
#rm -rf /home/$USER/python/virtualenvs/debugpy
#python3 -m venv /home/$USER/python/virtualenvs/debugpy
#/home/$USER/python/virtualenvs/debugpy/bin/python -m pip install debugpy

echo "Done configuring nvim"
