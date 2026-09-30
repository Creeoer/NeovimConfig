local M = {}

function M.path()
  return vim.fs.normalize(vim.fn.expand(vim.env.NVIM_OBSIDIAN_VAULT or "~/Documents/Frank's Notes"))
end

function M.is_note(bufnr)
  if vim.fn.isdirectory(M.path()) ~= 1 then return false end
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then return false end
  local root = vim.uv.fs_realpath(M.path()) or M.path()
  filename = vim.uv.fs_realpath(filename) or vim.fn.resolve(filename)
  root, filename = vim.fs.normalize(root), vim.fs.normalize(filename)
  if require("platform").is_windows then
    root, filename = root:lower(), filename:lower()
  end
  return vim.startswith(filename, root:gsub("/$", "") .. "/")
end

function M.options()
  return {
    legacy_commands = false,
    workspaces = { { name = "personal", path = M.path(), strict = true } },
    picker = { name = "telescope.nvim" },
    note_id_func = require("obsidian.builtin").title_id,
    new_notes_location = "current_dir",
    note = { template = vim.NIL },
    frontmatter = { enabled = false },
    daily_notes = { folder = "Quick Notes/Daily", date_format = "YYYY-MM-DD" },
    templates = { folder = "templates" },
    attachments = { folder = "./attachments" },
    link = { style = "wiki", auto_update = true },
    ui = { enable = false }, -- render-markdown already renders the buffer.
    callbacks = {
      enter_note = function()
        local commands = {
          mn = { "new", "New note" },
          ms = { "search", "Search notes" },
          mb = { "backlinks", "Backlinks" },
          md = { "today", "Daily note" },
          mt = { "template", "Insert template" },
          ml = { "follow_link", "Follow link" },
        }
        for key, action in pairs(commands) do
          vim.keymap.set("n", "<leader>" .. key, "<cmd>Obsidian " .. action[1] .. "<CR>", {
            buffer = true, silent = true, desc = "Obsidian: " .. action[2],
          })
        end
      end,
    },
  }
end

return M
