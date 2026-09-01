# Keybindings

This is the reference for mappings defined by this repository and the active
plugin-specific mappings you need to operate its plugin buffers. Ordinary Vim
motions and editing commands are intentionally omitted.

`<leader>` is `Space`. Key notation uses `<C-x>` for Ctrl, `<M-x>` for Alt or
Option, and `<S-x>` for Shift. Modes are `N` (normal), `I` (insert), `V`
(visual), `S` (select), and `O` (operator-pending).

Which-key shows available leader mappings after pressing `Space`. Inside
NvimTree or MiniFiles, press `g?` to see the live mappings for the installed
plugin version.

## Terminal Neovim profile

### Files, windows, and buffers

| Mode | Keys                               | Action                                        |
| ---- | ---------------------------------- | --------------------------------------------- |
| N    | `<leader>e`                        | Toggle NvimTree project explorer              |
| N    | `<leader>fe`                       | Open MiniFiles at the working directory       |
| N    | `<leader>fE`                       | Open MiniFiles at the current file            |
| N    | `<leader>fn`                       | Prompt for a path, then create/open the file  |
| N    | `<leader>w`                        | Save the current file                         |
| N    | `<leader>q`                        | Close the current window                      |
| N    | `<leader>/`                        | Clear search highlighting                     |
| N    | `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` | Focus the left, lower, upper, or right window |
| N    | `<leader>v`                        | Create a vertical split                       |
| N    | `<leader>h`                        | Create a horizontal split                     |
| N    | `<S-l>`, `<S-h>`                   | Move to the next or previous buffer           |
| N    | `<leader>1` ... `<leader>9`        | Go to buffer 1 through 9                      |
| N    | `<leader>bd`                       | Delete the current buffer                     |
| V    | `<`, `>`                           | Reindent and keep the selection active        |

### Search and project navigation

| Mode  | Keys                       | Action                          |
| ----- | -------------------------- | ------------------------------- |
| N     | `<leader>ff`               | Telescope: find files           |
| N     | `<leader>fg`               | Telescope: live grep            |
| N     | `<leader>fb`               | Telescope: open buffers         |
| N     | `<leader>fh`               | Telescope: help tags            |
| N     | `<leader>fr`               | Telescope: recent files         |
| N     | `<leader>fp`               | Telescope: projects             |
| N/V/O | `s`                        | Flash jump                      |
| N     | `<leader>ha`               | Add the current file to Harpoon |
| N     | `<leader>hh`               | Open the Harpoon menu           |
| N     | `<leader>h1`, `<leader>h2` | Open Harpoon item 1 or 2        |

### Git and diagnostics

| Mode | Keys         | Action                              |
| ---- | ------------ | ----------------------------------- |
| N    | `<leader>gc` | Telescope: Git commits              |
| N    | `<leader>gs` | Telescope: Git status               |
| N    | `<leader>gd` | Diffview: review the working tree   |
| N    | `<leader>gD` | Diffview: file history              |
| N    | `<leader>xx` | Trouble: workspace diagnostics      |
| N    | `<leader>xX` | Trouble: current-buffer diagnostics |
| N    | `<leader>cs` | Trouble: document symbols           |
| N    | `<leader>xL` | Trouble: location list              |
| N    | `<leader>xQ` | Trouble: quickfix list              |

### LSP, formatting, and completion

These LSP mappings become active only in a buffer with an attached language
server.

| Mode | Keys         | Action                                                           |
| ---- | ------------ | ---------------------------------------------------------------- |
| N    | `gd`         | Go to definition                                                 |
| N    | `K`          | Show hover information                                           |
| N    | `gr`         | Find references                                                  |
| N    | `<leader>ca` | Code actions                                                     |
| N    | `<leader>rn` | Rename symbol                                                    |
| N    | `[d`, `]d`   | Previous or next diagnostic                                      |
| N    | `<leader>F`  | Format the buffer with Conform, falling back to LSP              |
| N    | `<leader>lo` | Organize TypeScript imports                                      |
| N    | `<leader>lx` | Apply all ESLint fixes                                           |
| I/S  | `<Tab>`      | Next completion item, expand snippet, or jump forward in snippet |
| I/S  | `<S-Tab>`    | Previous completion item or jump backward in snippet             |
| I    | `<CR>`       | Confirm the explicitly selected completion item                  |

### Tasks and terminal

| Mode  | Keys         | Action                                   |
| ----- | ------------ | ---------------------------------------- |
| N     | `<leader>or` | Select and run an Overseer task          |
| N     | `<leader>ol` | Toggle the Overseer task list            |
| N     | `<leader>oq` | Open Overseer quick actions              |
| N     | `<leader>ob` | Run the project's `npm run build` script |
| N     | `<leader>ot` | Run the project's `npm run test` script  |
| N     | `<leader>od` | Run the project's `npm run dev` script   |
| N/I/T | `<C-\>`      | Toggle the horizontal terminal           |

### AI

#### CodeCompanion and CopilotChat entry points

| Mode | Keys         | Action                                   |
| ---- | ------------ | ---------------------------------------- |
| N/V  | `<leader>aa` | Open CodeCompanion actions               |
| N    | `<leader>ac` | Toggle the CodeCompanion Codex chat      |
| V    | `<leader>ap` | Add the selection to CodeCompanion chat  |
| N    | `<leader>al` | Open a Claude Code CLI session           |
| N    | `<leader>aL` | Open a Codex CLI session                 |
| N    | `<leader>cc` | Toggle CopilotChat                       |
| V    | `<leader>ce` | Ask CopilotChat to explain the selection |
| V    | `<leader>cd` | Ask CopilotChat for a docstring          |
| V    | `<leader>ct` | Ask CopilotChat for unit tests           |

#### Copilot ghost text and panel

| Context       | Keys             | Action                                    |
| ------------- | ---------------- | ----------------------------------------- |
| Insert        | `<C-l>`          | Accept the complete ghost-text suggestion |
| Insert        | `<M-w>`          | Accept one word                           |
| Insert        | `<M-l>`          | Accept one line                           |
| Insert        | `<M-]>`, `<M-[>` | Next or previous suggestion               |
| Insert        | `<C-e>`          | Dismiss the suggestion                    |
| Normal/Insert | `<M-CR>`         | Open the Copilot suggestion panel         |
| Copilot panel | `[[`, `]]`       | Previous or next suggestion               |
| Copilot panel | `<CR>`           | Accept the selected suggestion            |
| Copilot panel | `gr`             | Refresh suggestions                       |

The commands `:Copilot disable` and `:Copilot enable` disable or enable ghost
text for the current session.

#### CodeCompanion chat and edit preview

| Context         | Keys         | Action                                   |
| --------------- | ------------ | ---------------------------------------- |
| Chat, N         | `?`          | Show CodeCompanion options/keymaps       |
| Chat, N/I       | `<C-s>`      | Send the message                         |
| Chat, N         | `<CR>`       | Send the message                         |
| Chat, I         | `<C-_>`      | Open chat completion                     |
| Chat, N         | `gr`         | Regenerate the last response             |
| Chat, N/I       | `<C-c>`      | Close the chat                           |
| Chat, N         | `q`          | Stop the current request                 |
| Chat, N         | `gx`         | Clear the chat                           |
| Chat, N         | `gc`         | Insert an empty code block               |
| Chat, N         | `gy`         | Yank the last code block                 |
| Chat, N         | `gba`, `gbd` | Toggle all-buffer or diff-only live sync |
| Chat, N         | `}`, `{`     | Next or previous chat                    |
| Edit preview, N | `gv`         | View the proposed diff                   |
| Edit preview, N | `g1`         | Always accept changes in this buffer     |
| Edit preview, N | `g2`         | Accept the current change                |
| Edit preview, N | `g3`         | Reject the current change                |
| Edit preview, N | `g4`         | Cancel pending tool calls                |
| Edit preview, N | `}`, `{`     | Next or previous diff hunk               |

#### CopilotChat buffer

| Context   | Keys             | Action                           |
| --------- | ---------------- | -------------------------------- |
| Chat, I   | `<Tab>`          | Complete a chat token            |
| Chat, N/I | `<CR>` / `<C-s>` | Submit the prompt                |
| Chat, N/I | `q` / `<C-c>`    | Close the chat                   |
| Chat, N/I | `<C-l>`          | Reset the chat                   |
| Chat, N   | `grr`            | Toggle sticky context            |
| Chat, N   | `grx`            | Clear sticky context             |
| Chat, N/I | `<C-y>`          | Accept a proposed diff           |
| Chat, N   | `gj`             | Jump to the diff                 |
| Chat, N   | `gqa`            | Put answers in the quickfix list |
| Chat, N   | `gqd`            | Put diffs in the quickfix list   |
| Chat, N   | `gy`             | Yank the diff                    |
| Chat, N   | `gd`             | Show the diff                    |
| Chat, N   | `gc`             | Show chat information            |
| Chat, N   | `gh`             | Show CopilotChat help            |

### Debugging

| Mode | Keys         | Action                             |
| ---- | ------------ | ---------------------------------- |
| N    | `<leader>db` | Toggle breakpoint                  |
| N    | `<leader>dB` | Set conditional breakpoint         |
| N    | `<leader>dm` | Set log point                      |
| N    | `<leader>dc` | Start or continue                  |
| N    | `<leader>dn` | Step over                          |
| N    | `<leader>di` | Step into                          |
| N    | `<leader>do` | Step out                           |
| N    | `<leader>dC` | Run to cursor                      |
| N    | `<leader>dr` | Restart                            |
| N    | `<leader>dx` | Stop/terminate                     |
| N    | `<leader>dR` | Toggle the debug REPL              |
| N    | `<leader>dU` | Toggle the debug UI                |
| N/V  | `<leader>de` | Evaluate under cursor or selection |

## Plugin editing defaults

These are plugin mappings enabled by the config without custom remapping.

### Comments and surrounds

| Mode | Keys                       | Action                                                    |
| ---- | -------------------------- | --------------------------------------------------------- |
| N    | `gcc`, `gbc`               | Toggle a linewise or blockwise comment                    |
| N    | `gc{motion}`, `gb{motion}` | Toggle a linewise or blockwise comment over a motion      |
| V    | `gc`, `gb`                 | Toggle a linewise or blockwise comment over the selection |
| N    | `gco`, `gcO`, `gcA`        | Add a comment below, above, or at end of line             |
| N    | `ys{motion}{char}`         | Add a surrounding pair around a motion                    |
| N    | `yss{char}`                | Surround the current line                                 |
| N    | `ds{char}`                 | Delete a surrounding pair                                 |
| N    | `cs{old}{new}`             | Change a surrounding pair                                 |
| V    | `S{char}`                  | Surround the selection                                    |
| I    | `<C-g>s`, `<C-g>S`         | Add an inline or linewise surround while inserting        |

### NvimTree buffer

| Keys                      | Action                                                            |
| ------------------------- | ----------------------------------------------------------------- |
| `<CR>` or `o`             | Open file/directory                                               |
| `<Tab>`                   | Preview                                                           |
| `<C-v>`, `<C-x>`, `<C-t>` | Open in vertical split, horizontal split, or new tab              |
| `a`                       | Create a file or directory; end the name with `/` for a directory |
| `r`, `e`, `u`             | Rename normally, basename only, or full path                      |
| `d`, `D`                  | Delete or move to trash                                           |
| `c`, `x`, `p`             | Copy, cut, or paste                                               |
| `gy`, `ge`                | Copy absolute path or basename                                    |
| `H`, `I`, `U`             | Toggle dotfiles, Git-ignored files, or custom-hidden files        |
| `f`, `F`                  | Start or clear live filtering                                     |
| `E`, `W`                  | Expand or collapse all directories                                |
| `-`, `<C-]>`              | Move root up or change root to selected directory                 |
| `[c`, `]c`                | Previous or next Git change                                       |
| `[e`, `]e`                | Previous or next diagnostic                                       |
| `R`                       | Refresh the tree                                                  |
| `q`                       | Close the tree                                                    |
| `g?`                      | Show every NvimTree mapping                                       |

### MiniFiles buffer

MiniFiles is editable: rename, move, create, or delete entries by editing the
directory text, then synchronize to apply the proposed filesystem operations.

| Keys     | Action                                      |
| -------- | ------------------------------------------- |
| `l`, `L` | Go in/open, or go in and close MiniFiles    |
| `h`, `H` | Go out, or go out and trim the right branch |
| `<`, `>` | Trim the left or right branch               |
| `m`, `'` | Set or jump to a bookmark                   |
| `@`      | Reveal the working directory                |
| `<BS>`   | Reset the explorer state                    |
| `g.`     | Toggle dotfiles                             |
| `=`      | Review and synchronize filesystem edits     |
| `q`      | Close MiniFiles                             |
| `g?`     | Show MiniFiles help and mappings            |

## VSCode Neovim profile

These mappings call VSCode actions and are active only inside the VSCode
Neovim extension.

### Files, editors, and search

| Mode | Keys                      | Action                              |
| ---- | ------------------------- | ----------------------------------- |
| N    | `<leader>ff`              | Quick Open                          |
| N    | `<leader>fg`, `<leader>/` | Find in files                       |
| N    | `<leader>fb`              | Show all editors                    |
| N    | `<leader>fr`              | Open recent                         |
| N    | `<leader>e`               | Focus the Explorer                  |
| N    | `<leader>w`, `<leader>W`  | Save current file or save all       |
| N    | `<leader>q`, `<leader>Q`  | Close current editor or all editors |
| N    | `<leader>R`               | Find and replace                    |
| N    | `<leader>l`, `<leader>h`  | Next or previous editor             |

### Editor groups

| Mode | Keys                                                   | Action                                                |
| ---- | ------------------------------------------------------ | ----------------------------------------------------- |
| N    | `<leader>v`, `<leader>s`                               | Split right or down                                   |
| N    | `<leader>sc`                                           | Close editors in the current group                    |
| N    | `<leader>so`                                           | Close other editors                                   |
| N    | `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`                     | Focus left, lower, upper, or right group              |
| N    | `<leader>mh`, `<leader>mj`, `<leader>mk`, `<leader>ml` | Move editor to the left, lower, upper, or right group |

### Code, diagnostics, and terminal

| Mode | Keys         | Action                       |
| ---- | ------------ | ---------------------------- |
| N    | `[d`, `]d`   | Previous or next problem     |
| N    | `<leader>d`  | Open Problems                |
| N    | `<leader>ca` | Quick fix/code action        |
| N    | `<leader>rn` | Rename symbol                |
| N    | `<leader>rf` | Refactor                     |
| N/V  | `<leader>fm` | Format document or selection |
| N    | `<leader>oi` | Organize imports             |
| N    | `<leader>t`  | Toggle terminal              |
| N    | `<leader>T`  | Create terminal              |
| N    | `<leader>ts` | Split terminal               |

### VSCode AI, Harpoon, and projects

| Mode | Keys                                                                                                                         | Action                               |
| ---- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| N/V  | `<leader>ci`                                                                                                                 | Start inline chat                    |
| N/V  | `<leader>cc`                                                                                                                 | Toggle quick chat                    |
| N    | `<leader>cp`                                                                                                                 | Open the Chat view                   |
| N    | `<leader>ct`                                                                                                                 | Toggle GitHub Copilot completions    |
| N    | `<leader>Ha`                                                                                                                 | Add editor to VSCode Harpoon         |
| N    | `<leader>Ho`                                                                                                                 | Open VSCode Harpoon quick pick       |
| N    | `<leader>He`                                                                                                                 | Edit VSCode Harpoon entries          |
| N    | `<leader>H1`, `<leader>H2`, `<leader>H3`, `<leader>H4`, `<leader>H5`, `<leader>H6`, `<leader>H7`, `<leader>H8`, `<leader>H9` | Open VSCode Harpoon item 1 through 9 |
| N    | `<leader>pa`                                                                                                                 | Save a Project Manager project       |
| N    | `<leader>pe`                                                                                                                 | Edit Project Manager projects        |
| N    | `<leader>po`                                                                                                                 | List projects                        |
| N    | `<leader>pO`                                                                                                                 | List projects in a new window        |
