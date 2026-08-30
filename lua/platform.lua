local M = {}

M.is_windows = vim.fn.has("win32") == 1
M.is_macos = vim.fn.has("macunix") == 1
M.path_separator = package.config:sub(1, 1)

---@param candidates string[]
---@return string
function M.first_executable(candidates)
  for _, command in ipairs(candidates) do
    local path = vim.fn.exepath(command)
    if path ~= "" then
      return path
    end
  end

  return candidates[1]
end

---@return string
function M.python()
  if M.is_windows then
    -- Prefer python3 when available so unrelated bundled python.exe files do
    -- not win PATH resolution on Windows.
    return M.first_executable({ "python3", "python" })
  end

  return M.first_executable({ "python3", "python" })
end

---@return string, string[]
function M.python_task()
  local python = M.python()
  if vim.fn.executable(python) == 1 then
    return python, {}
  end

  if M.is_windows and vim.fn.executable("py") == 1 then
    return vim.fn.exepath("py"), { "-3" }
  end

  return python, {}
end

---@param path string
---@return string
function M.executable_output(path)
  if M.is_windows and not path:lower():match("%.exe$") then
    return path .. ".exe"
  end

  return path
end

return M
