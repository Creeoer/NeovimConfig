return {
    name = "C/C++: Build and Run",
    builder = function()
        local file = vim.fn.expand("%:p")
        local outfile = vim.fn.expand("%:p:r")
        return {
            cmd = { "bash" },
            args = { "-c", string.format("g++ %s -o %s && %s", file, outfile, outfile) },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
