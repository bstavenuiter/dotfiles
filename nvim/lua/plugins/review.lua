return {
    {
        "esmuellert/codediff.nvim",
        opts = {
            explorer = {
                file_filter = {
                    ignore = { ".git/**", ".jj/**", ".claude/**" }, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
                },
            },
        },
    },
    {
        "georgeguimaraes/review.nvim",
        version = "v*",
        dependencies = {
            "esmuellert/codediff.nvim",
            "MunifTanjim/nui.nvim",
        },
        cmd = { "Review" },
        keys = {
            { "<leader>r", "<cmd>Review<cr>",         desc = "Review" },
            { "<leader>R", "<cmd>Review commits<cr>", desc = "Review commits" },
        },
    }
}
