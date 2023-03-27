
local onedark_status_ok, onedark = pcall(require, "onedark")
if not onedark_status_ok then
	return
end

onedark.setup  {
    toggle_style_key = '<leader>ss', -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    -- 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
    toggle_style_list = {'darker', 'light'}, -- List of styles to toggle between
}

