return {
    name = "Python: Run File",
    builder = function()
        local platform = require("platform")
        local file = vim.fn.expand("%:p")
        local python, prefix_args = platform.python_task()
        local args = vim.list_extend(prefix_args, { file })
        return {
            cmd = python,
            args = args,
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "python" },
    },
}
