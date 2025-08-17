-- ~/.config/nvim/lua/vscode-lazy.lua
if not vim.g.vscode then return end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Use LazyVim as a plugin (library)
    { "LazyVim/LazyVim",                       import = "lazyvim.plugins" },

    -- Enable only when running inside VS Code
    { import = "lazyvim.plugins.extras.vscode" },

    -- Strip out UI that duplicates VS Code (optional but recommended)
    { "nvim-neo-tree/neo-tree.nvim",           enabled = false },
    { "nvim-telescope/telescope.nvim",         enabled = false },
    { "folke/noice.nvim",                      enabled = false },
    { "rcarriga/nvim-notify",                  enabled = false },
    { "nvim-lualine/lualine.nvim",             enabled = false },
    { "lewis6991/gitsigns.nvim",               enabled = false },
    { "akinsho/bufferline.nvim",               enabled = false },
    { "ggandor/leap.nvim",                     enabled = false },
    { "ggandor/flit.nvim",                     enabled = false },
    -- If you prefer VS Code’s diagnostics/LSP entirely:
    { "neovim/nvim-lspconfig",                 enabled = false },
    { "williamboman/mason.nvim",               enabled = false },
    { "hrsh7th/nvim-cmp",                      enabled = false },
}, {
    ui = { border = "rounded" },
})
