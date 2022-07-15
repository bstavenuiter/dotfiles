local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

-- snippet shorthands
local ls = require('luasnip')
local i = ls.insert_node
local snippet = ls.s
local fmt = require "luasnip.extras.fmt".fmt
local t = ls.text_node

ls.add_snippets("all", {

    snippet("date", {
        ls.function_node(function()
            return os.date("%Y-%m-%d")
        end, {}),
    }),

    -- php type snippets
    snippet("sa", fmt("self::assert{}({})", { i(1, "Name"), i(2, "test")})),
    snippet("vd", fmt("var_dump({});", { i(1, "What") })),
    snippet("pr", fmt("print_r({});", { i(1, "What") })),
    snippet("e", t("exit;")),
    snippet("pubf", fmt([[public function {}() 
{{
    //{}
}}]], { i(1, "name"), i(2, "code")})),
})

vim.api.nvim_set_keymap("i", "<c-e>", "v:lua.tab_complete()", {expr = true})

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif luasnip and luasnip.expand_or_jumpable() then
        return t("<Plug>luasnip-expand-or-jump")
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
    return ""
end

local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup {
    -- completion = {
    --     autocomplete = false,
    -- },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
                "i",
                "s",
            }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
                "i",
                "s",
            }),
    },
    formatting = {
        -- fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    }),
    -- sources = {
    --     { name = "nvim_lsp" },
    --     { name = "luasnip" },
    --     { name = "buffer", option = {get_bufnrs = function() return vim.api.nvim_list_bufs() end }},
    --     { name = "path" },
    -- },
    -- confirm_opts = {
    --     behavior = cmp.ConfirmBehavior.Replace,
    --     select = false,
    -- },
    -- window = {
    --     documentation = {
    --         border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    --     }
    -- },
    -- experimental = {
    --     ghost_text = false,
    --     native_menu = false,
    -- },
}
-- Set configuration for specific filetype.
cmp.setup.filetype('vimwiki', {
    sources = { 
        { name = 'buffer' },
        { name = 'buffer' }
    }
})

vim.cmd [[
    autocmd FileType markdown,vimwiki lua require('cmp').setup.buffer {
    \   sources = {
    \     { name = 'path' },
    \     { name = 'buffer' },
    \   }
    \ }
]]
