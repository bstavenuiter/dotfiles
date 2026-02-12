return {
    {
        "paste-image",
        dir = vim.fn.stdpath("config") .. "/local/paste-image.nvim",
        name = "paste-image",
        ft = "markdown",
        opts = {
            dir = "~/code/zettelkasten/assets/images",
        },
    }
}
