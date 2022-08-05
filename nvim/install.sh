#!/bin/bash

function show_help()
{
	echo "./install.sh OPTIONS:"
	echo -e "\t '-p|--prefix' where to install"
	echo -e "\t '-s|--sudoer' set if has sudo privilege"
	echo -e "\t '-h|--help ' this help"
	echo -e "e.g. ./install.sh -p /home/user/neovim -s"

}

SUDOER=0
PREFIX=""
TAG="stable"
CLEAN=0
INSTALL=0

# command line args
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
		-s|sudoer)
			SUDOER=1
			shift
			;;
		-c|clean)
			CLEAN=1
			shift
			;;
		-i|install)
			INSTALL=1
			shift
			;;
		-p|--prefix)
			PREFIX=$2
			shift # past argument
			shift # past value
			;;
		-t|--tag)
			TAG=$2
			shift # past argument
			shift # past value
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

echo -e "SUDOER:     $SUDOER"
echo -e "PREFIX:     $PREFIX"
echo -e "TAG:        $TAG"
echo -e "CLEAN:      $CLEAN"
echo -e "INSTALL:    $INSTALL"

$(sudo --list passwd)>/dev/null
IS_NOT_SUDO=$?

if [[ $SUDOER -eq 1 && $IS_NOT_SUDO -eq 1 ]]; then
    echo "ERROR: The user that is trying to install nvim for the system does not have sudo privilege"
    exit 0;
fi

if [[ $SUDOER -eq 0 && "$PREFIX" == "" ]]; then
    echo "ERROR: Install prefix must be provided if not sudoer"
    exit 0;
fi

if [[ $SUDOER -eq 0 && $INSTALL -eq 1 ]]; then
    echo "ERROR: Can't install packages wihout sudo privilege"
    exit 0;
fi

echo "Remove an old build dir, if exists"
rm -rf /home/$USER/neovim

if [ $SUDOER -eq 1 ] && { [ $CLEAN -eq 1 ] || [ $INSTALL -eq 1 ]; }; then
   	if [[ $CLEAN -eq 1 && "$PREFIX" == "" ]]; then
   	 	echo "Remove existing nvim installation"
   	 	sudo rm /usr/local/bin/nvim
   	 	sudo rm -r /usr/local/share/nvim/
   	fi

   	if [ $INSTALL -eq 1 ]; then
   		echo "Install prerequisites"
       	sudo apt install -y  ninja-build gettext libtool\
       		libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen pip
       	# To install fonts
       	sudo apt install -y font-manager 
       	# For language servers
       	sudo apt install -y  python3-venv
		# sudo apt install -y  npm

		# CentOS
		#sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++\
		#	make pkgconfig unzip patch gettext curl
   	fi
fi

if [[ "$PREFIX" != "" && $CLEAN -eq 1 ]]; then
echo "Remove an old insstall dir, if exists"
	rm -rf $PREFIX
fi

git clone https://github.com/neovim/neovim.git /home/$USER/neovim
pushd /home/$USER/neovim
echo "Checking out to: $TAG version"
git checkout $TAG

if [ "$PREFIX" == "" ]; then
	echo "Make without prefix"
    make -j `nproc` CMAKE_BUILD_TYPE=Release
else
	echo "Make with prefix=$PREFIX"
    make -j `nproc` CMAKE_BUILD_TYPE=Release MAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX"
fi

if [[ $SUDOER -eq 1 && "$PREFIX" == "" ]]; then
	echo "Installing for the system..."
    sudo make install
else 
	echo "Installing into $PREFIX" 
    make CMAKE_EXTRA_FLAGS=-DCMAKE_INSTALL_PREFIX=$PREFIX install
fi

popd
rm -rf /home/$USER/neovim

echo "Done installing neovim"
echo "USE: export PATH="$PREFIX/bin:\$PATH""
