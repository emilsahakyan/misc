#!/bin/bash

function show_help()
{
	echo "./config.sh OPTIONS:"
	echo -e "\t '-f|--fonts' to install Nerd fonts"
	echo -e "\t '-c|--custom' to apply custom configs"
	echo -e "\t '-u|--update' to only update configs"
	echo -e "\t '-n|--nightly' use nightly branch, default=stable"
	echo -e "\t '-l|--latest' latest plugins, default pinned to stable"
	echo -e "\t '-r|--revert' revert to default updater settings"
	echo -e "\t '-h|--help ' this help"
	echo -e "e.g. ./config.sh -f -c"
}

FONTS=0
CUSTOM=0
LATEST=0
NIGHTLY=0
UPDATE=0
REVERT=0

# command line args
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
		-f|--fonts)
			FONTS=1
			shift
			;;
		-c|--custom)
			CUSTOM=1
			shift
			;;
		-u|--update)
			UPDATE=1
			shift
			;;
		-n|--nightly)
			NIGHTLY=1
			shift
			;;
		-l|--latest)
			LATEST=1
			shift
			;;
		-r|--revert)
			REVERT=1
			shift
			;;
		-h|--help)
			show_help
			exit 0
			;;
		*)    # unknown option
			echo "ERROR: UNKNOW OPTION."
			show_help
			exit 0
			;;
	esac
done

# Update only
if [ $UPDATE -eq 1 ]; then
	pushd  $HOME/.config/nvim/lua/user
	git pull
	echo "Done configuration update"
	exit
fi

# Remove any old config files
rm -rf $HOME/.config/nvim 
rm -rf $HOME/.local/share/nvim/
rm -rf $HOME/.local/state/nvim/

# Install Nerd fonts
if [ $FONTS -eq 1 ]; then
	FDIR="$HOME/.local/share/fonts"
	pushd $HOME/.config/nvim/
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip .
	unzip Hack.zip
	mkdir -p $FDIR
	rm *Windows*.ttf
	mv Hack*.ttf $FDIR
	rm -r Hack.zip
	fc-cache -f -v
fi

# AstroNvim installation
git clone https://github.com/AstroNvim/AstroNvim $HOME/.config/nvim
if [ $CUSTOM -eq 1 ]; then
	# My Nvim configuration
	git clone git@github.com:emilsahakyan/astroNvimConfig.git $HOME/.config/nvim/lua/user

	# Temporally disable prompts for updates
	sed -i 's/skip_prompts = false/skip_prompts = true/' $HOME/.config/nvim/lua/user/init.lua
	
	# Switch to nightly
	if [ $NIGHTLY -eq 1 ]; then
		sed -i 's/channel = "stable"/channel = "nightly"/' $HOME/.config/nvim/lua/user/init.lua
		sed -i 's/branch = "main"/branch= "nightly"/' $HOME/.config/nvim/lua/user/init.lua
	fi

	# Disable plugin pinning
	if [ $LATEST -eq 1 ]; then
		sed -i 's/pin_plugins = nil/pin_plugins= false/' $HOME/.config/nvim/lua/user/init.lua
	fi

	# Auto reload by default
	sed -i 's/auto_reload = false/auto_reload = true/' $HOME/.config/nvim/lua/user/init.lua
fi

# Revert the updater options to original
if [[ $REVERT -eq 1 && $CUSTOM -eq 1 ]]; then
	pushd $HOME/.config/nvim/lua/user/
	git checkout init.lua
	popd
fi

echo "Done configuring nvim"
