# Neovim Configuration

A portable Neovim setup for terminal Neovim and the VSCode Neovim extension.
It supports Windows, macOS, Linux, and WSL without requiring a Unix shell on
Windows.

The leader key is `Space`. See [KEYBINDINGS.md](KEYBINDINGS.md) for the full
custom and plugin-specific keymap reference.

## Requirements

- Neovim 0.12 or newer
- Git
- Node.js and npm
- ripgrep (Telescope text search)
- Tree-sitter CLI 0.26.1 or newer and a C compiler (syntax parsers)
- A Nerd Font (terminal icons)
- A clipboard provider: native support on Windows/macOS, or `wl-clipboard` or
  `xclip` on Linux

Language servers, formatters, and debuggers are installed per machine through
Mason. The task runner detects `python3`/`python`, common C and C++ compilers,
and Java 11+ without relying on Bash.

## Install on Windows

The recommended route is PowerShell plus [Scoop](https://scoop.sh/). Install
Scoop first if it is not already available, then install the prerequisites:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git neovim nodejs ripgrep tree-sitter gcc pwsh unzip gzip
```

Back up an existing config, if present, and clone this repository into the
actual Windows Neovim config directory:

```powershell
if (Test-Path -LiteralPath "$env:LOCALAPPDATA\nvim") {
  Move-Item -LiteralPath "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim.backup"
}
git clone https://github.com/Creeoer/NeovimConfig.git "$env:LOCALAPPDATA\nvim"
nvim
```

If `nvim.backup` already exists, choose another backup name before running the
`Move-Item` command.

## Install on macOS

Install Apple's command-line tools and the Homebrew packages used by the
configuration:

```bash
xcode-select --install
brew install neovim git node ripgrep tree-sitter-cli
```

Then back up any existing config and clone this repository into Neovim's
standard config directory:

```bash
config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_root"
if [ -e "$config_root/nvim" ]; then
  mv "$config_root/nvim" "$config_root/nvim.backup"
fi
git clone https://github.com/Creeoer/NeovimConfig.git "$config_root/nvim"
nvim
```

If `nvim.backup` already exists, choose another backup name before running the
`mv` command.

## First launch

Lazy.nvim installs plugins and Mason starts installing language tooling on the
first launch. Let both finish, quit Neovim, and open it once more. Useful setup
commands are:

```vim
:Lazy sync
:Mason
:checkhealth
```

Open a project from its root with `nvim .`. Press `Space e` for the persistent
project tree, or `Space f e` for the editable MiniFiles view.

Do not copy Neovim's data directory (`nvim-data` on Windows or
`~/.local/share/nvim` on Unix) between operating systems. Each machine should
build its own plugin, parser, Mason, and debugger binaries.

## Current plugins

The terminal profile currently uses these plugins:

| Area                       | Plugins                                                                                                                                                                   |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Themes and UI              | `onedark.nvim`, `tokyonight.nvim`, `rose-pine`, `lualine.nvim`, `bufferline.nvim`, `noice.nvim`, `nvim-notify`, `indent-blankline.nvim`, `which-key.nvim`                 |
| Files and navigation       | `telescope.nvim`, `telescope-project.nvim`, `nvim-tree.lua`, `mini.files`, `harpoon` (Harpoon 2), `flash.nvim`                                                            |
| Editing and completion     | `nvim-treesitter`, `nvim-autopairs`, `Comment.nvim`, `nvim-surround`, `nvim-cmp`, `LuaSnip`, `friendly-snippets`, `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp_luasnip` |
| Git and diagnostics        | `gitsigns.nvim`, `diffview.nvim`, `trouble.nvim`                                                                                                                          |
| LSP, formatting, and tasks | `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim`, `conform.nvim`, `overseer.nvim`, `toggleterm.nvim`, `nvim-java`                      |
| Debugging                  | `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `mason-nvim-dap.nvim`, `nvim-dap-python`, `nvim-dap-go`                                                               |
| AI                         | `copilot.lua`, `CopilotChat.nvim`, `codecompanion.nvim`                                                                                                                   |
| Shared support             | `plenary.nvim`, `nui.nvim`, `nvim-nio`, `nvim-web-devicons`                                                                                                               |

`lazy-lock.json` is the source of truth for the exact installed revisions and
transitive dependencies. In VSCode, the config uses LazyVim's VSCode profile
and Flash while disabling terminal-only UI, completion, and LSP plugins so
VSCode can provide those features.

## Agent integration

CodeCompanion provides agent chat, actions, selection context, edit previews,
and terminal CLI sessions. Install and authenticate the agents you want to use
separately on each machine:

- `codex-acp` powers the default CodeCompanion chat.
- `claude` powers Claude Code CLI sessions.
- `codex` powers Codex CLI sessions.

The main entry points are `Space a a` for actions, `Space a c` for chat,
`Space a l` for Claude CLI, and `Space a L` for Codex CLI. See
[KEYBINDINGS.md](KEYBINDINGS.md#ai) for every AI mapping.

GitHub Copilot suggestions are enabled automatically in insert mode after
authentication:

```vim
:Copilot auth
:Copilot status
```

Use `:Copilot disable` and `:Copilot enable` to turn ghost text off or on for
the current Neovim session.

## TypeScript development

TypeScript and isolated `.ts` files use `vtsls`. The setup also installs ESLint,
Prettier, JavaScript debugging, and language support for React/Next.js, Vue,
Svelte, Astro, Tailwind CSS, and Emmet. Vue uses the official TypeScript plugin.

Formatting runs on save with project-local Prettier settings when available.
ESLint reads the project's flat or legacy config and publishes diagnostics.
Project-local TypeScript, Prettier, ESLint, and framework-specific Prettier
plugins should be installed as development dependencies.

Useful entry points are:

- `Space F`: format the current buffer
- `Space l o`: organize TypeScript imports
- `Space l x`: apply all available ESLint fixes
- `Space c a`: show LSP and ESLint code actions
- `Space o b`: run `npm run build`
- `Space o t`: run `npm run test`
- `Space o d`: run `npm run dev`
- `Space o r`: choose any available Overseer task or package script

## VSCode Neovim

Install the VSCode Neovim extension and point its platform-specific executable
setting at the machine's `nvim` binary. Enable its WSL option when VSCode should
run Neovim inside WSL. VSCode-specific behavior lives in `vscode-config.lua`;
terminal behavior lives in `regular-config.lua`.

The VSCode-specific Harpoon, Project Manager, and Copilot mappings require the
matching VSCode extensions. Their mappings are listed separately in
[KEYBINDINGS.md](KEYBINDINGS.md#vscode-neovim-profile).

## Portability and health

The same tracked config is used on all supported operating systems. Platform
differences such as executable names, path separators, clipboard behavior, and
task commands are handled in `lua/platform.lua`.

The current configuration and full health report have been validated on
Windows 11 with Neovim 0.12.5. The macOS and Linux paths have been statically
audited for portability; run `:checkhealth` after installing on each actual
machine to verify its local compilers, runtimes, clipboard provider, and agent
CLIs.

Missing language servers, debuggers, compilers, runtimes, or agent CLIs affect
only their related workflows; the base editor and other plugins still load.
