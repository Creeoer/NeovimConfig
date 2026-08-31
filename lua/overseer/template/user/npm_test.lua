return {
    name = "npm: test",
    builder = function()
        return require("project_tasks").spec("test")
    end,
    condition = {
        filetype = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" },
    },
}
