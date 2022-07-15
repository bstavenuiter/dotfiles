local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
    return
end

onedark.setup{
    toggle_style_list = {'warm', 'light'},
    style = 'warm'
}
onedark.load()
