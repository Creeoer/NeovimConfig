local M = {}

local function project_root(bufnr)
  return vim.fs.root(bufnr or 0, { "package.json" }) or vim.fs.root(vim.fn.getcwd(), { "package.json" })
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

function M.workspace_root(root)
  return vim.fs.root(root, { "pnpm-workspace.yaml", "pnpm-lock.yaml", "yarn.lock", "bun.lock", "bun.lockb", "package-lock.json" }) or root
end

function M.package_manager(root)
  -- Workspace packages often declare the manager only in the root manifest.
  for directory in vim.fs.parents(vim.fs.joinpath(root, "package.json")) do
    local package = package_json(directory)
    local manager = package and type(package.packageManager) == "string"
      and package.packageManager:match("^(%w+)@")
    if manager and vim.tbl_contains({ "npm", "pnpm", "yarn", "bun" }, manager) then
      return manager
    end
  end
  local markers = {
    ["pnpm-workspace.yaml"] = "pnpm", ["pnpm-lock.yaml"] = "pnpm",
    ["yarn.lock"] = "yarn", ["bun.lock"] = "bun", ["bun.lockb"] = "bun",
    ["package-lock.json"] = "npm",
  }
  for directory in vim.fs.parents(vim.fs.joinpath(root, "package.json")) do
    for marker, manager in pairs(markers) do
      if vim.uv.fs_stat(vim.fs.joinpath(directory, marker)) then
        return manager
      end
    end
  end
  return "npm"
end

---@param script string
---@param workspace? boolean Run at the workspace root instead of the current package
---@return overseer.TaskDefinition
function M.spec(script, workspace)
  local root = project_root(0)
  assert(root, "No package.json found above the current buffer")
  root = workspace and M.workspace_root(root) or root

  local package = package_json(root)
  assert(package and package.scripts and package.scripts[script], "No package script named '" .. script .. "' in " .. root)

  local platform = require("platform")
  local manager = M.package_manager(root)
  local candidates = platform.is_windows and { manager .. ".cmd", manager .. ".exe", manager } or { manager }
  return {
    name = manager .. ": " .. script,
    cmd = platform.first_executable(candidates),
    args = { "run", script },
    cwd = root,
    components = { { "on_output_quickfix", open = false }, "default" },
  }
end

---@param script string
function M.run(script, workspace)
  local ok, spec = pcall(M.spec, script, workspace)
  if not ok then
    vim.notify(spec, vim.log.levels.WARN)
    return
  end

  local task = require("overseer").new_task(spec)
  task:start()
end

function M.mobile_spec(script)
  local root = project_root(0)
  local package = root and package_json(root)
  local dependencies = package
    and vim.tbl_extend("force", package.dependencies or {}, package.devDependencies or {}) or {}
  assert(dependencies["react-native"] or dependencies.expo,
    "No React Native or Expo package found above the current buffer")
  return M.spec(script)
end

function M.run_mobile(script)
  local ok, spec = pcall(M.mobile_spec, script)
  if not ok then
    vim.notify(spec, vim.log.levels.WARN)
    return
  end
  local task = require("overseer").new_task(spec)
  task:start()
  task:open_output("horizontal")
end

return M
