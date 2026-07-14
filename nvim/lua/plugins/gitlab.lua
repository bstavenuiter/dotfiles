return {
    {
        "gitlab",
        dir = vim.fn.stdpath("config") .. "/local/gitlab.nvim",
        name = "gitlab",
        cmd = { "GitlabMR", "GitlabRepo", "GitlabMRs", "GitlabPipeline", "GitlabVariables", "GitlabTags", "GitlabFile" },
        keys = {
            { "<leader>glm", "<cmd>GitlabMR<CR>", desc = "GitLab: current MR" },
            { "<leader>glr", "<cmd>GitlabRepo<CR>", desc = "GitLab: repository" },
            { "<leader>glo", "<cmd>GitlabMRs<CR>", desc = "GitLab: merge requests" },
            { "<leader>glp", "<cmd>GitlabPipeline<CR>", desc = "GitLab: pipelines" },
            { "<leader>glv", "<cmd>GitlabVariables<CR>", desc = "GitLab: CI/CD variables" },
            { "<leader>glt", "<cmd>GitlabTags<CR>", desc = "GitLab: tags" },
            { "<leader>glf", "<cmd>GitlabFile<CR>", desc = "GitLab: open file" },
            { "<leader>glf", ":'<,'>GitlabFile<CR>", mode = "v", desc = "GitLab: open file (selection)" },
        },
        config = function(_, opts)
            require("gitlab").setup({host = "gitlab.leadsio.dev"})
        end,
    }
}
