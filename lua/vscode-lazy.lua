-- ~/.config/nvim/lua/vscode-lazy.lua
if not vim.g.vscode then return end

local plugin_root = vim.fn.stdpath("data") .. "/lazy-vscode"
local lazypath = plugin_root .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "LazyVim/LazyVim",                       import = "lazyvim.plugins" },

    { import = "lazyvim.plugins.extras.vscode" },
    { "nvim-neo-tree/neo-tree.nvim",           enabled = false },
    { "nvim-telescope/telescope.nvim",         enabled = false },
    { "folke/noice.nvim",                      enabled = false },
    { "rcarriga/nvim-notify",                  enabled = false },
    { "nvim-lualine/lualine.nvim",             enabled = false },
    { "lewis6991/gitsigns.nvim",               enabled = false },
    { "akinsho/bufferline.nvim",               enabled = false },
    { url = "https://codeberg.org/andyg/leap.nvim.git", name = "leap.nvim", enabled = false },
    { "ggandor/flit.nvim",                     enabled = false },
    { "neovim/nvim-lspconfig",                 enabled = false },
    { "mason-org/mason.nvim",                  enabled = false },
    { "hrsh7th/nvim-cmp",                      enabled = false },
    { "folke/flash.nvim",                      enabled = true, vscode = true },
}, {
    root = plugin_root,
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock-vscode.json",
    rocks = { enabled = false },
    ui = { border = "rounded" },
})
