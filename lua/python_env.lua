local M = {}

local markers = {
  "pyproject.toml",
  "pyrightconfig.json",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  ".git",
}

function M.root(start)
  start = start or 0
  local root = vim.fs.root(start, markers)
  if root then
    return root
  end
  local path = type(start) == "number" and vim.api.nvim_buf_get_name(start) or start
  if path and path ~= "" then
    local stat = vim.uv.fs_stat(path)
    return stat and stat.type == "directory" and path or vim.fs.dirname(path)
  end
  return vim.fn.getcwd()
end

local function env_python(directory, conda)
  if not directory or directory == "" then
    return nil
  end
  local path = require("platform").is_windows
      and vim.fs.joinpath(directory, conda and "python.exe" or "Scripts/python.exe")
    or vim.fs.joinpath(directory, "bin/python")
  return vim.fn.executable(path) == 1 and path or nil
end

-- Keep analysis, task execution, and the debug target on the same interpreter.
-- debugpy itself runs in Mason's separate environment.
function M.python(start)
  local active = env_python(vim.env.VIRTUAL_ENV) or env_python(vim.env.CONDA_PREFIX, true)
  if active then
    return active
  end
  local root = M.root(start)
  for directory in vim.fs.parents(vim.fs.joinpath(root, "placeholder")) do
    for _, name in ipairs({ ".venv", "venv" }) do
      local python = env_python(vim.fs.joinpath(directory, name))
      if python then
        return python
      end
    end
    if vim.uv.fs_stat(vim.fs.joinpath(directory, ".git")) then
      break
    end
  end
  return require("platform").python()
end

function M.task(kind)
  local file = vim.api.nvim_buf_get_name(0)
  assert(file ~= "", "Save the Python buffer before running a task")
  local python = M.python(0)
  local prefix = {}
  if vim.fn.executable(python) ~= 1 then
    python, prefix = require("platform").python_task()
  end
  return {
    name = kind == "pytest" and "Python: pytest" or "Python: Run File",
    cmd = python,
    args = vim.list_extend(prefix, kind == "pytest" and { "-m", "pytest" } or { file }),
    cwd = M.root(0),
    components = { { "on_output_quickfix", open = false }, "default" },
  }
end

function M.run(kind)
  local ok, spec = pcall(M.task, kind)
  if not ok then
    vim.notify(spec, vim.log.levels.WARN)
    return
  end
  require("overseer").new_task(spec):start()
end

return M
