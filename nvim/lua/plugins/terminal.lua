return {
    {
        "terminal.nvim",
        dir = vim.fn.stdpath("config") .. "/local/terminal.nvim",
        name = "terminal.nvim",
        config = function()
            require("terminal").setup()
        end,
    }
}
