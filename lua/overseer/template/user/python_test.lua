return {
  name = "Python: pytest",
  builder = function()
    return require("python_env").task("pytest")
  end,
  condition = { filetype = { "python" } },
}
