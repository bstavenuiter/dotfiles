return {
    {
        "jira",
        dir = vim.fn.stdpath("config") .. "/local/jira.nvim",
        name = "jira",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {},
        config = function(_, opts)
            require("jira").setup(opts)
        end,
    }
}
