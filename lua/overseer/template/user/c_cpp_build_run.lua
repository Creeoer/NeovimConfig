return {
    name = "C/C++: Build and Run",
    builder = function()
        local platform = require("platform")
        local file = vim.fn.expand("%:p")
        local file_dir = vim.fn.expand("%:p:h")
        local filetype = vim.bo.filetype
        local compilers = filetype == "c"
            and { "cc", "clang", "gcc" }
            or { "c++", "clang++", "g++" }
        local compiler = platform.first_executable(compilers)
        local outfile = platform.executable_output(vim.fn.expand("%:p:r"))

        return {
            cmd = outfile,
            cwd = file_dir,
            components = {
                {
                    "dependencies",
                    tasks = {
                        {
                            name = "Compile " .. vim.fn.expand("%:t"),
                            cmd = compiler,
                            args = { file, "-o", outfile },
                            cwd = file_dir,
                            components = { { "on_output_quickfix", open = true }, "default" },
                        },
                    },
                    sequential = true,
                },
                { "on_output_quickfix", open = true },
                "default",
            },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
