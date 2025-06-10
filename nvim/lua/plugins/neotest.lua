return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "olimorris/neotest-phpunit",
        },
        keys = {
            {"<leader>tn", function() require("neotest").run.run() end, {desc = "Run nearest test"}},
            {"<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, {desc = "Run test file"}},
            {"<leader>to", function() require("neotest").output_panel.toggle() end, {desc = "Show neotest summary window"}},

        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-phpunit")
                },
            })
        end
    }
}
