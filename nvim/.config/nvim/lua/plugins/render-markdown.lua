return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },     -- if you use the mini.nvim suite
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            enabled = false,
            link = {
                -- Turn on / off inline link icon rendering.
                enabled = false,
            }
        },
        keys = {
            {"<leader>rm", "<cmd>RenderMarkdown toggle<cr>"}
        }
    }
}
