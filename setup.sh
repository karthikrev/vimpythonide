#!/bin/bash

mkdir -p ~/.vim/bundle

function checkcmd {
    which $1 >/dev/null
    if [ "$?" -ne "0" ]; then
        echo "ERROR: $1 client is not installed please install it"
        exit 1
    fi
}

echo "PLEASE NOTE THIS ONLY RUNS ON LINUX. IF YOU ARE HAVING MAC INSTALL UNSTABLE vim 7.4 "
echo "Want to proceed ?"
read nothing
checkcmd git
cd ~/.vim/bundle

# Installing pathogen
mkdir -p ~/.vim/autoload/
curl -Sso ~/.vim/autoload/pathogen.vim  https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim


# Installing python mode
rm -rf /tmp/python-mode
mkdir -p ~/.vim/bundle/python-mode && cd /tmp
git clone https://github.com/klen/python-mode.git
cp -rf /tmp/python-mode/* ~/.vim/bundle/python-mode

# TODO: check if these lines are already present and then write
cat << EOF >> ~/.vimrc
" Pathogen load
filetype off
call pathogen#infect()
call pathogen.vimogen#helptags()
filetype plugin indent on
syntax on
EOF

#Installing Jedi
python -c "import jedi; print jedi" >/dev/null
if [ "$?" -ne "0" ]; then
    cd /tmp
    git clone https://github.com/davidhalter/jedi.git
    cd jedi
    echo "Please enter sudo password to install Jedi python module: "
    sudo python setup.py install
    if [ "$?" -ne "0" ]; then
        echo "Jedi didn't install properly please fix and try again. Exiting"
        exit 1
    fi
else
    echo "Jedi already installed"
fi

# Installing jedi vim
rm -rf /tmp/jedi-vim
mkdir -p  ~/.vim/bundle/jedi-vim && cd /tmp
git clone https://github.com/davidhalter/jedi-vim.git
cp -rf /tmp/jedi-vim/* ~/.vim/bundle/jedi-vim
