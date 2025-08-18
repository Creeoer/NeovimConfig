# Neovim Configuration for VSCode

My personal Neovim configuration optimized for VSCode integration with WSL.

## Quick Start

1. Install WSL2 & Neovim. Or install Neovim on Windows.
2. Install the Neovim extension for VSCode.
3. If installed on Windows, ensure that the path in settings.json points to the correct Neovim executable.
4. If installed on WSL, make sure Neovim is installed in WSL and the path in settings.json points to the WSL Neovim. Also ensure that the useWSL setting is set to true.
5. Grab the config files and drop them in your `~/.config/nvim` directory (WSL or Windows).
6. Done! You may enable or disable the lazyvim plugins by editing the vscode-lazy.lua file.
7. You can edit the keybindings in the vscode-config.lua file.

Optional: If desired, you may install the VS Project Manager + VS Harpoon to replicate neovim-like functionality. The keybindings are already present
in the vscode-config.lua file

## Features

- VSCode-specific keybindings
- Efficient file navigation
- Vim motions optimized for VSCode

## Installation

### Prerequisites

- WSL2 with Ubuntu if using WSL
- Neovim 0.8+
- VSCode with Neovim extension

### Quick Configuration Install

```bash
# Clone this config
git clone https://github.com/Creeoer/NeovimConfig.git ~/.config/nvim

# Open VSCode and install the Neovim extension
# Set the neovim executable path in VSCode settings:
# "vscode-neovim.neovimExecutablePaths.linux": "/usr/bin/nvim"
