local M = {}

local function require_all(dir)
    local scan = vim.loop.fs_scandir(dir)
    if not scan then return end

    while true do
        local name, fs_type = vim.loop.fs_scandir_next(scan)
        if not name then break end

        if fs_type == 'file' and name:match("%.lua$") and name ~= "init.lua" then
            local module = 'plugins.' .. name:gsub("%.lua$", '')
            local ok, conf = pcall(require, module)
            if not ok then
                vim.notify(
                    'failed to load plugin config: ' .. module .. '\n' .. conf,
                    vim.log.levels.ERROR
                )
            elseif type(conf) == 'function' then
                local success, err = pcall(conf)
                if not success then
                    vim.notify(
                        'Error in ' .. module .. '\n' .. err,
                        vim.log.levels.ERROR
                    )
                end
            end
        end
    end
end

require_all(vim.fn.stdpath('config') .. '/lua/plugins')

return M
