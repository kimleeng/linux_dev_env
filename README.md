# User-local CLI tools with Ansible

This playbook installs CLI tools into the target user's home directory. It uses Pixi as the installer, then exposes the tools from `~/.local/bin` so they can be used without activating Pixi.

## What it installs

- `pixi`
- `tmux`
- `rg`
- `fd`
- `bat`
- `jq`
- `zoxide`
- `eza`
- `btop`
- `ncdu`
- `tree`
- `rsync`
- `git`

The playbook also adds `~/.local/bin` to `~/.profile` when needed and adds `zoxide` shell initialization for bash and zsh.

## Run on localhost

```sh
ansible-playbook -i localhost, -c local shell.yaml
```

The comma after `localhost` is required. It tells Ansible that `localhost` is an inline inventory entry, not a file path.

## Run on one remote server

Run the playbook as the user who should receive the tools:

```sh
ansible-playbook -i "host.example.com," -u remote_user shell.yaml
```

This installs into `remote_user`'s home directory on `host.example.com`.

## Run with an inventory file

Create an inventory file outside the repo or add one locally if you do not plan to commit it:

```ini
[cli_tool_hosts]
example-host ansible_host=host.example.com ansible_user=remote_user
```

Run:

```sh
ansible-playbook -i inventory.ini shell.yaml
```

## Run on multiple servers

```ini
[cli_tool_hosts]
server_one ansible_host=server-one.example.com ansible_user=remote_user
server_two ansible_host=server-two.example.com ansible_user=remote_user
server_three ansible_host=server-three.example.com ansible_user=another_user
```

Run:

```sh
ansible-playbook -i inventory.ini shell.yaml
```

## Pin the remote Python interpreter

If Ansible warns that it auto-discovered a Python interpreter, you can pin one per host:

```ini
[cli_tool_hosts]
example-host ansible_host=host.example.com ansible_user=remote_user ansible_python_interpreter=/usr/bin/python3
```

This only controls the Python Ansible uses to run modules on the remote host. It does not affect the installed CLI tools.

## Choosing the target user

The playbook installs into the home directory of the SSH user. To install tools for `remote_user`, connect as `remote_user`.

If you connect as an admin account, the tools are installed for that admin account unless the playbook is changed to become another user.

## Syntax check

```sh
ansible-playbook -i localhost, -c local --syntax-check shell.yaml
```

## macOS app installs

`macos.yaml` installs developer tools and desktop apps on a Mac using Homebrew, Homebrew Cask, and the Mac App Store CLI.

Run it locally on macOS:

```sh
ansible-playbook -i localhost, -c local macos.yaml
```

If Amphetamine or another Mac App Store app is missing, use:

```sh
ansible-playbook -i localhost, -c local --ask-become-pass macos.yaml
```

It checks for and installs:

- Visual Studio Code
- 1Password
- Obsidian
- Codex
- ChatGPT
- WhatsApp
- Vivaldi
- Warp
- OrbStack
- Rectangle
- Amphetamine
- GitHub Desktop
- Slack
- Stats
- Ollama
- ComfyUI

Notes:

- Homebrew is installed automatically if it is missing.
- Amphetamine is installed from the Mac App Store with `mas get`, so you need to be signed in to the App Store. `mas` 7 requires sudo for App Store installs, so run with `--ask-become-pass` when Mac App Store apps are missing.
- ChatGPT and ComfyUI are Apple Silicon-only Homebrew casks and are skipped on Intel Macs.
- Homebrew casks are installed with `--appdir=/Applications`; if Homebrew knows about a cask but the app bundle is missing from `/Applications`, the playbook reinstalls that cask there.
- Codex's app cask is `codex-app`; OrbStack's cask is `orbstack`; GitHub Desktop's cask is `github`; Ollama's app cask is `ollama-app`.

Syntax check:

```sh
ansible-playbook -i localhost, -c local --syntax-check macos.yaml
```

## VS Code extensions

`vscode.yaml` installs Visual Studio Code extensions with the `code` CLI. It keeps the configured list focused on top-level extensions and lets VS Code install extension packs and dependencies.

Run it locally:

```sh
ansible-playbook -i localhost, -c local vscode.yaml
```

It installs:

- `charliermarsh.ruff`
- `davidanson.vscode-markdownlint`
- `github.vscode-github-actions`
- `github.vscode-pull-request-github`
- `mechatroner.rainbow-csv`
- `mechatroner.rainbow-json`
- `mhutchie.git-graph`
- `ms-python.python`
- `ms-toolsai.datawrangler`
- `ms-toolsai.jupyter`
- `ms-vscode-remote.remote-containers`
- `ms-vscode.remote-repositories`
- `openai.chatgpt`
- `redhat.ansible`
- `tamasfe.even-better-toml`
- `timonwong.shellcheck`
- `yzhang.markdown-all-in-one`

The following are omitted because they are installed by the extensions above:

- `github.remotehub`
- `ms-python.debugpy`
- `ms-python.vscode-pylance`
- `ms-python.vscode-python-envs`
- `ms-toolsai.jupyter-keymap`
- `ms-toolsai.jupyter-renderers`
- `ms-toolsai.vscode-jupyter-cell-tags`
- `ms-toolsai.vscode-jupyter-slideshow`
- `ms-vscode.azure-repos`
- `redhat.vscode-yaml`

Syntax check:

```sh
ansible-playbook -i localhost, -c local --syntax-check vscode.yaml
```
