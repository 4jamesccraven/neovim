return function()
    ---[nvim-treesitter]---
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(event)
            local bufnr = event.buf
            local ft = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
            local excluded = {
                csv = true, -- Decisive.nvim provides a better parser
            }
            -- no parser for ft or explicitly excluded
            if not ft or excluded[ft] then
                return
            end

            local ok = pcall(vim.treesitter.get_parser, bufnr, ft)
            if ok then
                vim.treesitter.start(bufnr, ft)
            end
        end,
    })
end
