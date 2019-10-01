#!/bin/bash
# Credit to: https://jdhao.github.io/2018/10/13/centos_zsh_install_use/
# Install ncurses 6.1
mkdir /development_env/

# Gets ncurses, unzips, and sets it up for install, important to use shared libraries as that's what zsh will be looking for
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz
tar xf ncurses-6.1.tar.gz
cd ncurses-6.1
./configure --prefix=$HOME/local CXXFLAGS="-fPIC" CFLAGS="-fPIC" --with-shared
make -j && make install

#so zsh is looking for links to libtinfo.so.6 
ln -s $HOME/local/lib/libncurses.so.6 libtinfo.so.6
ln -s $HOME/local/lib/libncurses.so.6 libtinfo.so

#install zsh using the libraries installed from ncurses
wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download
tar xf zsh.tar.xz
# in my current case it was cd zsh-5.7.1
cd zsh
./configure --prefix="$HOME/local" \
    CPPFLAGS="-I$HOME/local/include" \
    LDFLAGS="-L$HOME/local/lib"
make -j && make install

#Have bash profile look as bashrc
echo "export PATH=$HOME/local/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=${HOME}/local/lib/:${LD_LIBRARY_PATH}" >> ~/.bashrc
#This is less ideal as typing bash will put you back in zsh but I can't change my default shell as it's not on approved list
echo "zsh" >> ~/.bashrc
# echo "export SHELL=`which zsh`" >> ~/.bash_profile
# echo "[ -f \"$SHELL\" ] && exec \"$SHELL\" -l" >> ~/.bash_profile

/home/ssi.ad/kimn/.oh-my-zsh

# Install oh-my-zsh plugin manager
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# get plug ins and themes
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

#In ~/.zshrc edit with emacs or editor of choice
#ZSH_THEME=powerlevel10k/powerlevel10k
#plugins=(git zsh-autosuggestions pip)
