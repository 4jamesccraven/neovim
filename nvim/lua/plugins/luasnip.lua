return function()
    ---[luasnip]---
    local ls = require 'luasnip'

    ls.config.setup({
        enable_autosnippets = true,
    })

    require 'config.map' ({ 'i', 's' }, '<Tab>', function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
        end
    end)

    local snip = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    local function shell_cmd(cmd)
        local handle = io.popen(cmd)
        if not handle then return end
        local result = handle:read("*a")
        handle:close()
        return result:gsub('%s+$', '')
    end

    ls.add_snippets('all', {
        snip('dt', {
            f(function() return shell_cmd('date +%D') end)
        }),
        snip('date', {
            f(function() return shell_cmd('date "+%d %B, %Y"') end)
        }),
    })

    ls.add_snippets('nix', {
        snip({
            trig = '^f}',
            trigEngine = 'pattern',
            snippetType = 'autosnippet'
        }, {
            t('{ '),
            i(1),
            t({ '... }:', '', '' }),
            i(0),
        }),
        snip({
            trig = 'w]',
            snippetType = 'autosnippet',
        }, {
            t('with '),
            i(1, 'pkgs'),
            t({ '; [', '  ' }),
            i(2),
            t({ '', '];', '' }),
            i(0)
        }),
        snip({
            trig = "s'",
            snippetType = 'autosnippet',
        }, {
            t({ "''", '  ' }),
            i(0),
            t({ '', "'';" })
        }),
    })

    ls.add_snippets('python', {
        snip({
            trig = '^main',
            trigEngine = 'pattern',
            snippetType = 'autosnippet',
        }, {
            t({ 'def main() -> None:', '    ' }),
            i(0, '...'),
            t({ '', '', 'if __name__ == \'__main__\':', '    main()' }),
        }),
        snip({
            trig = 'def ',
            snippetType = 'autosnippet',
        }, {
            t('def '),
            i(1, 'fn'),
            t('('),
            i(2),
            t(') -> '),
            i(3, 'None'),
            t({ ':', '    ' }),
            i(0, '...')
        }),
    })
end
