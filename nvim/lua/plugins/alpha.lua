return function()
    ---[alpha-nvim]---
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    local ts = require 'telescope.builtin'

    local function new_file()
        local Input = require 'nui.input'
        local event = require 'nui.utils.autocmd'.event

        local opts = {
            position = '50%',
            size = 25,
            border = {
                style = 'rounded',
                text = {
                    top = 'File Name',
                }
            }
        }

        local input = Input(opts, {
            prompt = " ",
            on_submit = function(path)
                if path == "" then
                    return
                end

                -- Expand relative paths
                path = vim.fn.fnamemodify(path, ':p')

                -- Create a new buf with the user's input
                local buf = vim.api.nvim_create_buf(true, false)
                vim.api.nvim_buf_set_name(buf, path)
                vim.api.nvim_set_current_buf(buf)
                vim.cmd [[filetype detect]]
            end
        })

        input:map('i', '<Esc>', function()
            input:unmount()
        end, { noremap = true })

        input:mount()

        input:on(event.BufLeave, function()
            input:unmount()
        end)
    end

    local function edit_nix_configs()
        vim.cmd [[cd /home/jamescraven/nixos/]]
        ts.find_files()
    end

    -- Set header image
    dashboard.section.header = require 'config.header'

    -- Define functionality
    dashboard.section.buttons.val = {
        dashboard.button('n', ' New File', new_file),
        dashboard.button('f', '󰍉 Find Files', ts.find_files),
        dashboard.button('g', ' Live Grep', ts.live_grep),
        dashboard.button('N', ' Edit NixOS Configuration', edit_nix_configs), -- NIX
        dashboard.button('q', ' Quit', ':qa<CR>'),
    }

    dashboard.config.layout = {
        { type = 'padding', val = 3 },
        dashboard.section.header,
        { type = 'padding', val = 3 },
        dashboard.section.buttons,
    }

    alpha.setup(dashboard.config)
end
