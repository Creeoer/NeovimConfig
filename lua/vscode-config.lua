-- VSCode Neovim Configuration
local keymap = vim.keymap.set

-- Set options
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

-- ========================================
-- FILE NAVIGATION
-- ========================================
keymap('n', '<leader>p', "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")
keymap('n', '<leader>f', "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
keymap('n', '<leader>e', "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
keymap('n', '<leader>b', "<Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>")
keymap('n', '<leader>r', "<Cmd>call VSCodeNotify('workbench.action.openRecent')<CR>")

-- Tab navigation
keymap('n', '<leader>h', "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
keymap('n', '<leader>l', "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
keymap('n', 'H', "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
keymap('n', 'L', "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")

-- File operations
keymap('n', '<leader>w', "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>")
keymap('n', '<leader>W', "<Cmd>call VSCodeNotify('workbench.action.files.saveAll')<CR>")
keymap('n', '<leader>q', "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>")
keymap('n', '<leader>Q', "<Cmd>call VSCodeNotify('workbench.action.closeAllEditors')<CR>")

-- ========================================
-- WINDOW/SPLIT MANAGEMENT
-- ========================================
keymap('n', '<leader>sv', "<Cmd>call VSCodeNotify('workbench.action.splitEditor')<CR>")
keymap('n', '<leader>sh', "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
keymap('n', '<leader>sc', "<Cmd>call VSCodeNotify('workbench.action.closeEditorsInGroup')<CR>")
keymap('n', '<leader>so', "<Cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<CR>")

-- Navigate between splits
keymap('n', '<C-h>', "<Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>")
keymap('n', '<C-j>', "<Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>")
keymap('n', '<C-k>', "<Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>")
keymap('n', '<C-l>', "<Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>")

-- Move editors between groups
keymap('n', '<leader>mh', "<Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>")
keymap('n', '<leader>ml', "<Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>")

-- ========================================
-- CODE NAVIGATION
-- ========================================
keymap('n', 'gd', "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>")
keymap('n', 'gD', "<Cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>")
keymap('n', 'gi', "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>")
keymap('n', 'gr', "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>")
keymap('n', 'gt', "<Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>")
keymap('n', 'gp', "<Cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>")

-- Navigate history
keymap('n', '<C-o>', "<Cmd>call VSCodeNotify('workbench.action.navigateBack')<CR>")
keymap('n', '<C-i>', "<Cmd>call VSCodeNotify('workbench.action.navigateForward')<CR>")

-- Symbol navigation
keymap('n', '<leader>s', "<Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>")
keymap('n', '<leader>S', "<Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>")

-- ========================================
-- CODE ACTIONS & REFACTORING
-- ========================================
keymap('n', '<leader>ca', "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>")
keymap('n', '<leader>rn', "<Cmd>call VSCodeNotify('editor.action.rename')<CR>")
keymap('n', '<leader>fm', "<Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>")
keymap('v', '<leader>fm', "<Cmd>call VSCodeNotify('editor.action.formatSelection')<CR>")
keymap('n', '<leader>rf', "<Cmd>call VSCodeNotify('editor.action.refactor')<CR>")
keymap('n', '<leader>oi', "<Cmd>call VSCodeNotify('editor.action.organizeImports')<CR>")

-- Show hover/documentation
keymap('n', 'K', "<Cmd>call VSCodeNotify('editor.action.showHover')<CR>")

-- Diagnostics
keymap('n', '[d', "<Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>")
keymap('n', ']d', "<Cmd>call VSCodeNotify('editor.action.marker.next')<CR>")
keymap('n', '<leader>d', "<Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>")

-- ========================================
-- SEARCH & REPLACE
-- ========================================
keymap('n', '<leader>/', "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
keymap('n', '<leader>R', "<Cmd>call VSCodeNotify('editor.action.startFindReplaceAction')<CR>")
keymap('n', '*', "<Cmd>call VSCodeNotify('editor.action.wordHighlight.next')<CR>")
keymap('n', '#', "<Cmd>call VSCodeNotify('editor.action.wordHighlight.prev')<CR>")

-- ========================================
-- TERMINAL
-- ========================================
keymap('n', '<leader>t', "<Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>")
keymap('n', '<leader>T', "<Cmd>call VSCodeNotify('workbench.action.terminal.new')<CR>")
keymap('n', '<leader>ts', "<Cmd>call VSCodeNotify('workbench.action.terminal.split')<CR>")

-- ========================================
-- GIT INTEGRATION
-- ========================================
keymap('n', '<leader>gg', "<Cmd>call VSCodeNotify('workbench.view.scm')<CR>")
keymap('n', '<leader>gd', "<Cmd>call VSCodeNotify('git.openChange')<CR>")
keymap('n', '<leader>gs', "<Cmd>call VSCodeNotify('git.stage')<CR>")
keymap('n', '<leader>gu', "<Cmd>call VSCodeNotify('git.unstage')<CR>")
keymap('n', '<leader>gc', "<Cmd>call VSCodeNotify('git.commit')<CR>")
keymap('n', '[c', "<Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>")
keymap('n', ']c', "<Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>")

-- ========================================
-- FOLDING
-- ========================================
keymap('n', 'za', "<Cmd>call VSCodeNotify('editor.toggleFold')<CR>")
keymap('n', 'zR', "<Cmd>call VSCodeNotify('editor.unfoldAll')<CR>")
keymap('n', 'zM', "<Cmd>call VSCodeNotify('editor.foldAll')<CR>")
keymap('n', 'zo', "<Cmd>call VSCodeNotify('editor.unfold')<CR>")
keymap('n', 'zc', "<Cmd>call VSCodeNotify('editor.fold')<CR>")
keymap('n', 'zO', "<Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>")
keymap('n', 'zC', "<Cmd>call VSCodeNotify('editor.foldRecursively')<CR>")

-- ========================================
-- COPILOT INTEGRATION
-- ========================================
-- Inline chat in editor (for /fix, /explain, /tests, /docs)
keymap('n', '<leader>ci', "<Cmd>call VSCodeNotify('inlineChat.start')<CR>")
keymap('v', '<leader>ci', "<Cmd>call VSCodeNotify('inlineChat.start')<CR>")

-- Quick chat popup (floating window)
keymap('n', '<leader>cc', "<Cmd>call VSCodeNotify('workbench.action.quickchat.toggle')<CR>")
keymap('v', '<leader>cc', "<Cmd>call VSCodeNotify('workbench.action.quickchat.toggle')<CR>")

-- Full chat panel (sidebar)
keymap('n', '<leader>cp', "<Cmd>call VSCodeNotify('workbench.panel.chat.view.copilot.focus')<CR>")

-- Toggle Copilot on/off
keymap('n', '<leader>ct', "<Cmd>call VSCodeNotify('github.copilot.toggleCopilot')<CR>")

-- ========================================
-- COMFORT MAPPINGS
-- ========================================
-- Center cursor after jumping
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')

-- Better line joins
keymap('n', 'J', 'mzJ`z')

-- Keep visual mode after indent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Move lines in visual mode
keymap('v', 'J', ":m '>+1<CR>gv=gv")
keymap('v', 'K', ":m '<-2<CR>gv=gv")

-- Quick escape
keymap('i', 'jj', '<Esc>')
keymap('i', 'jk', '<Esc>')

-- Yank to end of line (like D and C)
keymap('n', 'Y', 'y$')

-- Quick save
keymap('n', '<leader><leader>', "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>")

-- Select all
keymap('n', '<leader>a', 'ggVG')

-- Clear search highlight
keymap('n', '<leader>n', ':nohl<CR>')
