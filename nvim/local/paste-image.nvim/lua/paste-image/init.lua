local M = {}

M.config = {
    dir = "assets/images",
}

function M.setup(config)
    M.config = vim.tbl_deep_extend("force", M.config, config or {})

    vim.api.nvim_create_user_command("PasteImage", function()
        M.paste()
    end, { desc = "Paste image from clipboard" })
end

local function get_save_command(filepath)
    -- macOS
    if vim.fn.has("mac") == 1 then
        if vim.fn.executable("pngpaste") == 1 then
            return { "pngpaste", filepath }
        end

        -- JXA Fallback
        -- Escape path for JXA string literal
        local js_path = filepath:gsub("\\", "\\\\"):gsub('"', '\\"')

        return { "osascript", "-l", "JavaScript", "-e", string.format([[
            var app = Application.currentApplication();
            app.includeStandardAdditions = true;
            ObjC.import("AppKit");

            var path = "%s";
            var pboard = $.NSPasteboard.generalPasteboard;
            var classArray = $.NSArray.arrayWithObject($.NSImage.class);

            if (pboard.canReadObjectForClassesOptions(classArray, $())) {
                var objects = pboard.readObjectsForClassesOptions(classArray, $());
                var image = objects.objectAtIndex(0);

                var tiffData = image.TIFFRepresentation;
                var bitmapRep = $.NSBitmapImageRep.imageRepWithData(tiffData);
                var pngData = bitmapRep.representationUsingTypeProperties($.NSPNGFileType, $());

                var result = pngData.writeToFileAtomically(path, true);
                if (!result) {
                    throw "Failed to write file";
                }
            } else {
                throw "No image in clipboard";
            }
        ]], js_path) }
    end

    -- Linux
    if vim.fn.executable("wl-paste") == 1 then
        return { "sh", "-c", "wl-paste --type image/png > " .. vim.fn.shellescape(filepath) }
    end

    if vim.fn.executable("xclip") == 1 then
        return { "sh", "-c", "xclip -selection clipboard -t image/png -o > " .. vim.fn.shellescape(filepath) }
    end

    return nil
end

function M.paste()
    local buf_dir = vim.fn.expand("%:p:h")
    local config_dir = M.config.dir

    -- Check if config_dir is absolute
    local is_absolute = config_dir:match("^/") or config_dir:match("^~")

    local full_dir_path
    if is_absolute then
        full_dir_path = vim.fn.expand(config_dir)
    else
        full_dir_path = vim.fs.joinpath(buf_dir, config_dir)
    end

    -- Ensure directory exists
    if vim.fn.isdirectory(full_dir_path) == 0 then
        vim.fn.mkdir(full_dir_path, "p")
    end

    local timestamp = os.date("%Y-%m-%d-%H-%M-%S")
    local filename = timestamp .. ".png"
    local full_file_path = vim.fs.joinpath(full_dir_path, filename)

    local cmd = get_save_command(full_file_path)
    if not cmd then
        vim.notify("PasteImage: No suitable clipboard tool found (pngpaste/osascript/wl-paste/xclip)",
            vim.log.levels.ERROR)
        return
    end

    -- Execute command
    local result = vim.system(cmd, { text = true }):wait()

    if result.code == 0 then
        -- Insert markdown link
        local text = string.format("![Image](%s)", full_file_path)
        vim.api.nvim_put({ text }, "c", true, true)
    else
        -- If it failed, it likely wasn't an image or tool failed.
        vim.notify("PasteImage failed: " .. (result.stderr or "No image in clipboard or tool error"), vim.log.levels
        .WARN)
    end
end

return M
