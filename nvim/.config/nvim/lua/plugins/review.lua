-- review.nvim v1.9.1 predates codediff v2.50.0, which changed
-- lifecycle.get_paths() to return typed Path tables instead of strings.
-- Upstream review.nvim is unmaintained, so patch it on install/update.
local function patch_review(plugin)
    local patch = vim.fn.stdpath("config") .. "/patches/review-codediff-path.patch"
    local function git_apply(args)
        args = vim.list_extend({ "git", "apply" }, args)
        return vim.system(vim.list_extend(args, { patch }), { cwd = plugin.dir }):wait()
    end

    if git_apply({ "--reverse", "--check" }).code == 0 then
        return -- already applied
    end
    local result = git_apply({})
    if result.code ~= 0 then
        error("review.nvim: failed to apply " .. patch .. "\n" .. (result.stderr or ""))
    end
end

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
        build = patch_review,
        dependencies = {
            "esmuellert/codediff.nvim",
            "MunifTanjim/nui.nvim",
        },
        cmd = { "Review" },
        opts = {},
    }
}
