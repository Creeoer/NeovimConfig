return {
    name = "Java: Build and Run",
    builder = function()
        local file_path = vim.fn.expand("%:p")
        local file_dir = vim.fn.expand("%:p:h")
        -- In Java, the class name is the filename without the extension
        local class_name = vim.fn.expand("%:t:r")

        -- This uses a "serial" task template to run commands in order
        return {
            cmd = { "bash" },
            args = { "-c", string.format("javac %s && java %s", file_path, class_name) },
            -- We set the current working directory to the file's directory
            cwd = file_dir,
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "java" },
    },
}
