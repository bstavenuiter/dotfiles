local status_ok, npairs = pcall(require, "lsp_signature")
if not status_ok then
    return
end

function _TEST()
    print('signature')
end

require "lsp_signature".setup()
