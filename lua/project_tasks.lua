local M = {}

local function project_root(bufnr)
  return vim.fs.root(bufnr or 0, { "package.json" })
end

local function package_json(root)
  local path = vim.fs.joinpath(root, "package.json")
  local ok, contents = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end

  local decoded, package = pcall(vim.json.decode, table.concat(contents, "\n"))
  return decoded and package or nil
end

---@param script string
---@return overseer.TaskDefinition
function M.spec(script)
  local root = project_root(0)
  assert(root, "No package.json found above the current buffer")

  local package = package_json(root)
  assert(package and package.scripts and package.scripts[script], "No npm script named '" .. script .. "'")

  local platform = require("platform")
  local npm_candidates = platform.is_windows and { "npm.cmd", "npm" } or { "npm" }
  return {
    name = "npm: " .. script,
    cmd = platform.first_executable(npm_candidates),
    args = { "run", script },
    cwd = root,
    components = { { "on_output_quickfix", open = false }, "default" },
  }
end

---@param script string
function M.run(script)
  local ok, spec = pcall(M.spec, script)
  if not ok then
    vim.notify(spec, vim.log.levels.WARN)
    return
  end

  local task = require("overseer").new_task(spec)
  task:start()
end

return M
