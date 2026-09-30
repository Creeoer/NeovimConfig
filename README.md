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

`lazy-lock.json` pins the terminal profile; `lazy-lock-vscode.json` pins the
VSCode profile. The profiles also use separate plugin directories (`lazy` and
`lazy-vscode`), so syncing one does not remove or downgrade the other's plugins.
In VSCode, the config uses LazyVim's VSCode profile
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

Formatting runs on save when a project has a Prettier configuration (including
the `prettier` field in `package.json`). Explicit formatting works even without
a project configuration. Project-local Prettier settings are respected.
ESLint reads the project's flat or legacy config and publishes diagnostics.
Project-local TypeScript, Prettier, ESLint, and framework-specific Prettier
plugins should be installed as development dependencies.

Useful entry points are:

- `Space F`: format the current buffer
- `Space l o`: organize TypeScript imports
- `Space l x`: apply all available ESLint fixes
- `Space c a`: show LSP and ESLint code actions
- `Space o b`: run the current package's build script
- `Space o t`: run the current package's test script
- `Space o d`: run the current package's dev script
- `Space o c`: run the current package's typecheck script
- `Space o B`, `Space o T`, `Space o C`: build, test, or typecheck the entire workspace
- `Space o r`: choose any available Overseer task or package script

## Python development

Pyright supplies type checking, completion, navigation, and hover information.
Ruff supplies lint diagnostics, code actions, import organization (`Space l o`),
and formatting on save (`Space F` also formats explicitly). Ruff reads the
project's `pyproject.toml`, `ruff.toml`, or `.ruff.toml` settings. Formatting
does not automatically apply lint fixes; use `Space c a` to review those.

Analysis, run tasks, and debugger launch configurations prefer an active
`VIRTUAL_ENV` or `CONDA_PREFIX`, then a `.venv` or `venv` in the project or its
parent workspace, then system Python. Virtualenv discovery stops at the Git
root. Create the environment and install project dependencies before editing,
for example `python3 -m venv .venv` on macOS/Linux. On Windows, use
`python -m venv .venv`. Restart Pyright after changing environments; its
`:LspPyrightSetPythonPath` command can also select an interpreter explicitly.

- `Space p r`: run the current Python file from its project root
- `Space p t`: run `python -m pytest` from the project root
- `Space d c`: launch the current file, debug pytest, or attach to local debugpy
- `Space d t` / `Space d T`: debug a test method / class using nvim-dap-python's
  detected test runner (pytest, unittest, or Django)

Install pytest in the project environment to use pytest tasks. Configure it in
`pytest.ini` or `[tool.pytest.ini_options]` for single-test debugger detection.
The debugger adapter runs from Mason's debugpy environment, independently of
the interpreter running the project, so projects do not need debugpy for launch
debugging. Attaching to an existing process requires that process to expose
debugpy on the selected local port (default `5678`).

## React Native and Expo

React Native and Expo use the same `vtsls` completion, navigation, rename, TSX
syntax highlighting, ESLint, and Prettier support as React web projects. Install
the mobile app's dependencies and keep its own TypeScript configuration:
`@react-native/typescript-config` for a React Native CLI app or
`expo/tsconfig.base` for Expo. React Native includes its own types; do not add
the obsolete `@types/react-native` package.

These shortcuts run the existing scripts in the mobile package containing the
current buffer, using its declared package manager, and open their output in a
terminal split:

- `Space m s`: run `start` (Metro / Expo)
- `Space m i`: run `ios`
- `Space m a`: run `android`

The package must depend on `react-native` or `expo` and define the corresponding
script. Use `Space o t` for its test script and `Space o c` for its typecheck
script. In the Metro terminal, enter terminal mode (`i`) to send keys; use
`Ctrl+\ Ctrl+n` to return to normal mode.

For Hermes JavaScript debugging, use [React Native DevTools](https://reactnative.dev/docs/react-native-devtools).
Open it from the app's Dev Menu or press `j` in the React Native CLI terminal.
The Node / Next.js DAP configurations debug Node processes; they do not debug
the mobile Hermes runtime. Native modules use Android Studio or Xcode debugging.
Device builds also require the project's Android SDK/JDK or Xcode/CocoaPods
setup; the Neovim configuration does not provision those platform SDKs.

## Kinetic / pnpm workspaces

Run `pnpm install --frozen-lockfile` from Kinetic's root before editing.
The task runner detects `packageManager` and workspace lockfiles, so Kinetic
uses its pinned pnpm rather than npm. Lowercase task keys target the package
containing the current file; uppercase keys target the workspace root.

`vtsls` starts at each package root and uses its workspace TypeScript SDK.
This supports Kinetic's Next.js apps on TypeScript 5.7 and its voice/shared
packages on TypeScript 5.9, including tsconfig paths and React/TSX completion.
Tailwind v4 discovers each app through its PostCSS config and CSS entry point,
and supports class completion in `cn`, `clsx`, `cva`, and `twMerge`. The CSS
server retains ordinary validation without flagging Tailwind at-rules.
Kinetic currently has no ESLint or Prettier configuration; ESLint attaches
when a config is present, and `Space F` runs Prettier explicitly.

JSON, YAML, Python, Dockerfile, shell, and Lua language servers are installed
through Mason. Tree-sitter covers these languages plus PostgreSQL migration
syntax. SQL highlighting does not require a database connection.

`Space d c` offers Node launch and attach configurations for JS/TS/JSX/TSX.
For a Next.js process, start the app with Node's inspector enabled (for example,
`NODE_OPTIONS='--inspect' pnpm --filter @kinetic/app dev` on macOS/Linux), then
choose **Attach to Node / Next.js (inspect)**. Browser client code requires a
separate browser debug session.

When `vim-herdr-navigation` is installed, `Ctrl+h/j/k/l` moves between Neovim
splits and Herdr panes. The loader follows the installed plugin directory
across Herdr updates and leaves VSCode's editor navigation with the extension.

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

The configuration has been validated on Windows 11 and macOS with Neovim
0.12.5. The macOS Kinetic checks cover LSP attachment in all five packages,
TypeScript error diagnostics, Tailwind v4 class completion, Prettier output,
syntax parsers, pnpm task selection, and a real Node debugger launch stopping
at entry. The VSCode profile passes a headless startup check with the extension
API stubbed; test its UI in VSCode itself. Python checks cover virtualenv-only
imports, Pyright and Ruff diagnostics, Ruff formatting, run and pytest tasks,
and a real debugpy launch using the project interpreter. React Native checks
cover TSX prop completion and diagnostics against React Native 0.87.1, Prettier,
and React Native / Expo script and package-manager selection. Device builds and
emulator debugging have not been tested by these editor checks. Run
`:checkhealth` after installing on each machine to verify its local tools.

Missing language servers, debuggers, compilers, runtimes, or agent CLIs affect
only their related workflows; the base editor and other plugins still load.
