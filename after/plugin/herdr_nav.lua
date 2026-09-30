-- vim-herdr-navigation editor side: <C-h/j/k/l> across nvim splits and herdr panes.
-- Sources the file shipped with the installed herdr plugin so updates flow through
-- (the install dir's hash suffix changes on plugin update).
-- Deferred: lazy.setup() sources after/plugin during startup, before the
-- keymaps at the end of regular-config.lua — these maps must land after those.
if vim.g.vscode then return end
vim.schedule(function()
  local matches = vim.fn.glob(
    vim.fn.expand("~/.config/herdr/plugins/github/vim-herdr-navigation-*/editor/nvim.lua"),
    true,
    true
  )
  if #matches > 0 then
    dofile(matches[#matches])
  end
end)
