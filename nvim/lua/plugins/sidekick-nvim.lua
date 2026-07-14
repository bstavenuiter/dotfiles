return {
    {
        "folke/sidekick.nvim",
        keys = {
            { "<leader>og", function () require("sidekick.cli").toggle("claude") end, desc = "Sidekick open"},
            { "<leader>of", function () require("sidekick.cli").send({ msg = "{file}"}) end, desc = "Sidekick send file"},
            { "<leader>ol", function () require("sidekick.cli").send({ msg = "{line}"}) end, desc = "Sidekick send line"},
        },
    },
}
