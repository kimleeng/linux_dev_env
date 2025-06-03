#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Credit to: https://jdhao.github.io/2018/10/13/centos_zsh_install_use/

# --- Environment Setup ---
# Create a directory for local installations if it doesn't exist.
mkdir -p ~/development_env/
cd ~/development_env/

# --- Install ncurses 6.1 (Required by Zsh) ---
# ncurses provides libraries for terminal-independent handling of character screens.
echo "Installing ncurses 6.1..."
# Download ncurses source
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz
# Extract the archive
tar xf ncurses-6.1.tar.gz
cd ncurses-6.1
# Configure the build:
# --prefix=$HOME/local: Install ncurses in ~/local
# CXXFLAGS="-fPIC" CFLAGS="-fPIC": Build position-independent code (necessary for shared libraries)
# --with-shared: Build shared libraries
./configure --prefix=$HOME/local CXXFLAGS="-fPIC" CFLAGS="-fPIC" --with-shared
make -j && make install
cd .. # Return to ~/development_env/

# Create symbolic links for libtinfo, which zsh will look for.
# These links point to the newly installed ncurses shared libraries.
ln -sf $HOME/local/lib/libncurses.so.6 $HOME/local/lib/libtinfo.so.6
ln -sf $HOME/local/lib/libncurses.so.6 $HOME/local/lib/libtinfo.so

# --- Install Zsh (Z Shell) ---
echo "Installing Zsh..."
# Download the latest Zsh source code. The -O option saves it as zsh.tar.xz.
wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download
# Extract the Zsh archive
tar xf zsh.tar.xz
# IMPORTANT: The extracted directory name might vary (e.g., zsh-5.7.1, zsh-5.8).
# You may need to adjust the 'cd zsh-*' line below to match the actual directory name.
# Find the zsh source directory (e.g. zsh-5.8)
ZSH_SRC_DIR=$(find . -maxdepth 1 -type d -name "zsh-*" -print -quit)
if [ -z "$ZSH_SRC_DIR" ]; then
    echo "Error: Could not find Zsh source directory after extraction."
    exit 1
fi
cd "$ZSH_SRC_DIR"
# Configure Zsh build:
# --prefix="$HOME/local": Install Zsh in ~/local
# CPPFLAGS="-I$HOME/local/include": Tell the C preprocessor where to find ncurses headers
# LDFLAGS="-L$HOME/local/lib": Tell the linker where to find ncurses libraries
./configure --prefix="$HOME/local" \
    CPPFLAGS="-I$HOME/local/include" \
    LDFLAGS="-L$HOME/local/lib"
make -j && make install
cd .. # Return to ~/development_env/

# --- Configure .bashrc for Zsh ---
echo "Configuring ~/.bashrc for Zsh..."
# Add ~/local/bin to PATH if not already present, so the system can find the new zsh.
grep -qF 'export PATH=$HOME/local/bin:$PATH' ~/.bashrc || echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
# Add ~/local/lib to LD_LIBRARY_PATH if not already present, so zsh can find its shared libraries.
grep -qF 'export LD_LIBRARY_PATH=${HOME}/local/lib/:${LD_LIBRARY_PATH}' ~/.bashrc || echo 'export LD_LIBRARY_PATH=${HOME}/local/lib/:${LD_LIBRARY_PATH}' >> ~/.bashrc
# Add zsh to ~/.bashrc to automatically start zsh when bash is launched, if not already present.
# This is a workaround for systems where changing the default shell isn't straightforward.
grep -qF 'exec zsh' ~/.bashrc || echo 'exec zsh' >> ~/.bashrc


# --- Install Oh My Zsh (Zsh configuration framework) ---
echo "Installing Oh My Zsh..."
# The following command downloads and runs the Oh My Zsh installer script.
# Oh My Zsh will be installed in ~/.oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is already installed."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Install Zsh Plugins and Themes ---
echo "Installing Zsh plugins and themes..."
# zsh-autosuggestions: Suggests commands as you type based on history and completions.
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions is already installed."
else
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

# powerlevel10k: A fast and flexible Zsh theme.
if [ -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
    echo "powerlevel10k theme is already installed."
else
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
fi

# zsh-syntax-highlighting: Provides syntax highlighting for the command line.
if [ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting is already installed."
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

echo "Script finished."
echo "Please update your ~/.zshrc file to set your desired theme and plugins."
echo "For example:"
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"'
echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting pip)'
echo "You may need to run 'p10k configure' if using Powerlevel10k for the first time."
echo "Source your ~/.bashrc or open a new terminal to start using Zsh."

#In ~/.zshrc edit with emacs or editor of choice
#ZSH_THEME=powerlevel10k/powerlevel10k
#plugins=(git zsh-autosuggestions zsh-syntax-highlighting pip)
