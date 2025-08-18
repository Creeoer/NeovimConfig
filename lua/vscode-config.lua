-- ~/.config/nvim/lua/vscode-config.lua
if not vim.g.vscode then return end

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

local vs = require("vscode")
local map = vim.keymap.set
local opts = { silent = true }

-- ========================================
-- FILE NAVIGATION
-- ========================================
map("n", "<leader>ff", function() vs.action("workbench.action.quickOpen") end, opts)
map("n", "<leader>fg", function() vs.action("workbench.action.findInFiles") end, opts)
map("n", "<leader>fb", function() vs.action("workbench.action.showAllEditors") end, opts)
map("n", "<leader>fr", function() vs.action("workbench.action.openRecent") end, opts)
map("n", "<leader>e", function() vs.action("workbench.files.action.focusFilesExplorer") end, opts)


-- ========================================
-- WINDOW / SPLIT MANAGEMENT
-- ========================================
map("n", "<leader>v", function() vs.action("workbench.action.splitEditorRight") end, opts)
map("n", "<leader>s", function() vs.action("workbench.action.splitEditorDown") end, opts)
map("n", "<leader>sc", function() vs.action("workbench.action.closeEditorsInGroup") end, opts)
map("n", "<leader>so", function() vs.action("workbench.action.closeOtherEditors") end, opts)

map("n", "<C-h>", function() vs.action("workbench.action.focusLeftGroup") end, opts)
map("n", "<C-j>", function() vs.action("workbench.action.focusBelowGroup") end, opts)
map("n", "<C-k>", function() vs.action("workbench.action.focusAboveGroup") end, opts)
map("n", "<C-l>", function() vs.action("workbench.action.focusRightGroup") end, opts)

map("n", "<leader>mh", function() vs.action("workbench.action.moveEditorToLeftGroup") end, opts)
map("n", "<leader>ml", function() vs.action("workbench.action.moveEditorToRightGroup") end, opts)
map("n", "<leader>mj", function() vs.action("workbench.action.moveEditorToBelowGroup") end, opts)
map("n", "<leader>mk", function() vs.action("workbench.action.moveEditorToAboveGroup") end, opts)

-- ========================================
-- FILE OPERATIONS
-- ========================================
map("n", "<leader>w", function() vs.action("workbench.action.files.save") end, opts)
map("n", "<leader>W", function() vs.action("workbench.action.files.saveAll") end, opts)
map("n", "<leader>q", function() vs.action("workbench.action.closeActiveEditor") end, opts)
map("n", "<leader>Q", function() vs.action("workbench.action.closeAllEditors") end, opts)

-- ========================================
-- SEARCH & REPLACE
-- ========================================
map("n", "<leader>/", function() vs.action("workbench.action.findInFiles") end, opts)
map("n", "<leader>R", function() vs.action("editor.action.startFindReplaceAction") end, opts)

-- ========================================
-- DIAGNOSTICS
-- ========================================
map("n", "[d", function() vs.action("editor.action.marker.prev") end, opts)
map("n", "]d", function() vs.action("editor.action.marker.next") end, opts)
map("n", "<leader>d", function() vs.action("workbench.actions.view.problems") end, opts)

-- ========================================
-- CODE ACTIONS / REFACTORING
-- ========================================
map("n", "<leader>ca", function() vs.action("editor.action.quickFix") end, opts)
map("n", "<leader>rn", function() vs.action("editor.action.rename") end, opts)
map("n", "<leader>rf", function() vs.action("editor.action.refactor") end, opts)
map("n", "<leader>fm", function() vs.action("editor.action.formatDocument") end, opts)
map("v", "<leader>fm", function() vs.action("editor.action.formatSelection") end, opts)
map("n", "<leader>oi", function() vs.action("editor.action.organizeImports") end, opts)

-- ========================================
-- TERMINAL
-- ========================================
map("n", "<leader>t", function() vs.action("workbench.action.terminal.toggleTerminal") end, opts)
map("n", "<leader>T", function() vs.action("workbench.action.terminal.new") end, opts)
map("n", "<leader>ts", function() vs.action("workbench.action.terminal.split") end, opts)

-- ========================================
-- COPILOT / CHAT
-- ========================================
map({ "n", "v" }, "<leader>ci", function() vs.action("inlineChat.start") end, opts)
map({ "n", "v" }, "<leader>cc", function() vs.action("workbench.action.quickchat.toggle") end, opts)
map("n", "<leader>cp", function() vs.action("workbench.action.chat.open") end, opts)
map("n", "<leader>ct", function() vs.action("github.copilot.completions.toggle") end, opts)

-- ========================================
-- VS HARPOON
-- ========================================
map("n", "<leader>Ha", function() vs.action("vscode-harpoon.addEditor") end, opts)
map("n", "<leader>Ho", function() vs.action("vscode-harpoon.editorQuickPick") end, opts)
map("n", "<leader>He", function() vs.action("vscode-harpoon.editEditors") end, opts)

-- direct jumps
map("n", "<leader>H1", function() vs.action("vscode-harpoon.gotoEditor1") end, opts)
map("n", "<leader>H2", function() vs.action("vscode-harpoon.gotoEditor2") end, opts)
map("n", "<leader>H3", function() vs.action("vscode-harpoon.gotoEditor3") end, opts)
map("n", "<leader>H4", function() vs.action("vscode-harpoon.gotoEditor4") end, opts)
map("n", "<leader>H5", function() vs.action("vscode-harpoon.gotoEditor5") end, opts)
map("n", "<leader>H6", function() vs.action("vscode-harpoon.gotoEditor6") end, opts)
map("n", "<leader>H7", function() vs.action("vscode-harpoon.gotoEditor7") end, opts)
map("n", "<leader>H8", function() vs.action("vscode-harpoon.gotoEditor8") end, opts)
map("n", "<leader>H9", function() vs.action("vscode-harpoon.gotoEditor9") end, opts)

-- ========================================
-- PROJECT MANAGER (alefragnani.project-manager)
-- ========================================
map("n", "<leader>pa", function() vs.action("projectManager.saveProject") end, opts)
map("n", "<leader>pe", function() vs.action("projectManager.editProjects") end, opts)
map("n", "<leader>po", function() vs.action("projectManager.listProjects") end, opts)
map("n", "<leader>pO", function() vs.action("projectManager.listProjectsNewWindow") end, opts)


-- Override LazyVim keybinding that breaks tab switching
-- Override LazyVim’s <leader>h/<leader>l after plugins finish
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        local vs = require("vscode")
        local map = vim.keymap.set
        local opts = { silent = true, noremap = true, nowait = true }

        -- remove LazyVim mappings if present
        pcall(vim.keymap.del, "n", "<leader>l")
        pcall(vim.keymap.del, "n", "<leader>h")

        -- your tab navigation
        map("n", "<leader>l", function() vs.action("workbench.action.nextEditor") end, opts)
        map("n", "<leader>h", function() vs.action("workbench.action.previousEditor") end, opts)
    end,
})
