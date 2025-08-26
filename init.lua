-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- Check if running in VSCode
if vim.g.vscode then
  require("vscode-lazy")
  -- VSCode-specific config
  require('vscode-config')
else
  -- Regular terminal nvim config
  local ok, err = pcall(require, "regular-config")
  if not ok then
    vim.api.nvim_err_writeln("!! ERROR IN YOUR CONFIG: init.lua")

    -- Print the error message itself
    vim.api.nvim_err_writeln(err)

    vim.api.nvim_err_writeln(debug.traceback())
    -- Basic settings if regular-config doesn't exist
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
  end
end
