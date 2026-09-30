return {
  name = "Python: Run File",
  builder = function()
    return require("python_env").task("run")
  end,
  condition = {
    filetype = { "python" },
  },
}
