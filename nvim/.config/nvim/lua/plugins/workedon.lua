return {
    {
        "workedon",
        dir = vim.fn.stdpath("config") .. "/local/workedon.nvim",
        name = "workedon",
        dependencies = { "jira", "gitlab" },
        cmd = { "WorkedOn" },
        config = function()
            require("workedon").setup()
        end,
    }
}
