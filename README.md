# Neovim Configuration

My Neovim setup for terminal Neovim and the VSCode Neovim extension. The same
configuration is designed to run on Windows, Linux, macOS, and WSL.

## Requirements

- Neovim 0.11 or newer
- Git and curl
- Node.js and npm (used by several language tools and agent CLIs)
- ripgrep (used by Telescope)
- A Nerd Font for terminal icons
- A platform clipboard provider: native clipboard support on Windows/macOS, or
  `wl-clipboard`/`xclip` on Linux

Language tooling is optional and can be installed per machine through Mason or
the system package manager. The task runner detects `python3`/`python`, common C
and C++ compilers, and Java 11+ without relying on Bash.

## Install

Back up any existing Neovim configuration first, then clone this repository to
Neovim's standard config directory.

### Windows (PowerShell)

```powershell
git clone https://github.com/Creeoer/NeovimConfig.git "$env:LOCALAPPDATA\nvim"
nvim
```

### Linux, macOS, or WSL

```bash
git clone https://github.com/Creeoer/NeovimConfig.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

Lazy.nvim installs plugins on the first launch. Do not copy Neovim's data
directory (`nvim-data` on Windows or `~/.local/share/nvim` on Unix) between
operating systems; let each machine build its own plugin and Mason binaries.

## Agent integration

CodeCompanion provides agent chat, actions, selection context, and CLI sessions.
Install and authenticate the agents you want to use separately on each machine:

- `codex-acp` for the default CodeCompanion chat
- `claude` for Claude Code CLI sessions
- `codex` for Codex CLI sessions

Key mappings:

- `<leader>aa`: actions
- `<leader>ac`: toggle Codex chat
- Visual `<leader>ap`: add the selection to chat
- `<leader>al`: open a Claude CLI session
- `<leader>aL`: open a Codex CLI session

## VSCode Neovim

Install the VSCode Neovim extension and point its platform-specific executable
setting at the machine's `nvim` binary. Enable its WSL option when VSCode should
run Neovim inside WSL. VSCode-specific behavior lives in `vscode-config.lua`;
terminal behavior lives in `regular-config.lua`.

## Health checks

Inside Neovim, run:

```vim
:checkhealth
:Lazy health
:Mason
```

Missing language servers, debuggers, compilers, runtimes, or agent CLIs affect
only their related workflows; the base editor and other plugins still load.
