# Linux Environment Setup Script

This repository contains a shell script (`commands.sh`) designed to automate the setup of a personalized Linux development environment. It focuses on installing and configuring Zsh, Oh My Zsh, and several useful plugins and themes.

## What the script does:

*   Creates a development environment directory (`~/development_env/`).
*   Downloads and installs ncurses 6.1 locally (`~/local`), ensuring shared libraries are built as required by Zsh.
*   Creates symbolic links for `libtinfo.so.6` and `libtinfo.so` pointing to the local ncurses installation.
*   Downloads and installs the latest Zsh locally, configured to use the local ncurses libraries.
*   Updates `~/.bashrc` to:
    *   Add the local Zsh binary path (`~/local/bin`) to the `PATH` environment variable.
    *   Add the local library path (`~/local/lib`) to the `LD_LIBRARY_PATH` environment variable.
    *   Automatically start `zsh` when a new bash session is initiated.
*   Installs Oh My Zsh, a framework for managing Zsh configuration.
*   Clones the following Zsh plugins and themes:
    *   `zsh-autosuggestions`
    *   `powerlevel10k` theme
    *   `zsh-syntax-highlighting`
*   Provides commented-out examples for setting the Zsh theme and enabling plugins in `~/.zshrc`.

## Prerequisites

*   A Linux environment.
*   Standard build tools (`make`, a C/C++ compiler like GCC).
*   `wget` for downloading files.
*   `tar` for extracting archives.
*   `git` for cloning plugins.
*   `curl` for installing Oh My Zsh.

## How to use

1.  **Clone the repository (or download the `commands.sh` script).**
    ```bash
    # If you have git installed
    git clone <repository-url>
    cd <repository-directory>
    ```
2.  **Make the script executable:**
    ```bash
    chmod +x commands.sh
    ```
3.  **Run the script:**
    ```bash
    ./commands.sh
    ```
4.  **Manual Configuration:**
    After the script completes, you will need to manually edit your `~/.zshrc` file to set your desired theme and plugins. For example:
    ```zsh
    ZSH_THEME="powerlevel10k/powerlevel10k"
    plugins=(git zsh-autosuggestions zsh-syntax-highlighting pip)
    ```
    You may also need to run `p10k configure` if you are using Powerlevel10k for the first time to configure its look and feel.

## Disclaimer

This script is provided as-is. It modifies system configuration files (`~/.bashrc`, `~/.zshrc`) and installs software. Understand what the script does before running it. While it aims to install software locally, always review scripts from the internet before execution on your system.
