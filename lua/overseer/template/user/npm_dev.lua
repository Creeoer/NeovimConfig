return {
    name = "npm: dev",
    builder = function()
        return require("project_tasks").spec("dev")
    end,
    condition = {
        filetype = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" },
    },
}
