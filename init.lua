-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Check if running in VSCode
if vim.g.vscode then
  -- VSCode-specific config
  require('vscode-config')
else
  -- Regular terminal nvim config
  local ok, _ = pcall(require, 'regular-config')
  if not ok then
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
