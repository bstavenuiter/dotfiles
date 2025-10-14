return {
    {
        "folke/sidekick.nvim",
        keys = {
            { "<leader>og", function () require("sidekick.cli").toggle("gemini") end, desc = "open sidekick"},
        },
    },
}
