local M = {}

function M.setup()
  local lint = require("lint")
  local package_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "sqlfluff", "venv")
  local python = vim.fs.joinpath(package_dir,
    require("platform").is_windows and "Scripts/python.exe" or "bin/python")
  local adapter = vim.fs.joinpath(vim.fn.stdpath("config"), "scripts", "sql_lint.py")
  local sqlfluff = lint.linters.sqlfluff
  -- Keep nvim-lint's JSON parser and severity mapping, using SQLFluff's own
  -- configuration loader to apply a fallback dialect without overriding one.
  sqlfluff.cmd = python
  sqlfluff.args = { adapter, function() return vim.api.nvim_buf_get_name(0) end }
  lint.linters_by_ft.sql = { "sqlfluff" }

  local warned = false
  local function run(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "sql"
      or vim.bo[bufnr].buftype ~= "" then return end
    if vim.fn.executable(python) ~= 1 then
      if not warned then
        vim.notify("SQL diagnostics need SQLFluff; install it with :MasonInstall sqlfluff", vim.log.levels.WARN)
        warned = true
      end
      return
    end
    warned = false
    vim.api.nvim_buf_call(bufnr, function()
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local cwd = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
      lint.try_lint("sqlfluff", { cwd = cwd })
    end)
  end
  local group = vim.api.nvim_create_augroup("user_sql_diagnostics", { clear = true })
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave", "FileType" }, {
    group = group,
    callback = function(args) run(args.buf) end,
  })
  vim.api.nvim_create_user_command("SqlLint", function() run(vim.api.nvim_get_current_buf()) end,
    { desc = "Check SQL syntax and style without modifying the buffer" })
  run(vim.api.nvim_get_current_buf())
end

return M
