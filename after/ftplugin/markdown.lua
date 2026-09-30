if vim.g.vscode then
  return
end

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
-- Display long prose lines without inserting hard line breaks while typing.
vim.opt_local.textwidth = 0
vim.opt_local.formatoptions:remove("t")

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal wrap< linebreak< spell< textwidth< formatoptions<"
