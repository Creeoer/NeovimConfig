return {
    name = "Java: Build and Run",
    builder = function()
        local file_path = vim.fn.expand("%:p")
        local file_dir = vim.fn.expand("%:p:h")

        -- Java 11+ can compile and run a source file in one portable command.
        return {
            cmd = "java",
            args = { file_path },
            cwd = file_dir,
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "java" },
    },
}
