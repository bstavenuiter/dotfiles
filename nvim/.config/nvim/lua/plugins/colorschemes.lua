return {
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        lazy = false,    --
        config = function()
            -- onedark and onelight are separate colorschemes, so follow the
            -- <leader>ll background toggle by hand while one of them is active.
            local ours = { onedark = true, onelight = true }
            vim.api.nvim_create_autocmd("OptionSet", {
                pattern = "background",
                callback = function()
                    if ours[vim.g.colors_name] then
                        vim.cmd.colorscheme(vim.o.background == "light" and "onelight" or "onedark")
                    end
                end,
            })
        end,
    },
    {
        'ribru17/bamboo.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('bamboo').setup {
                -- optional configuration here
            }
            require('bamboo').load()
        end,
    },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            require("everforest").setup({
                -- Your config here
            })
        end,
    }
}
