return function()
    ---[nvim-colorizer-lua]---
    require 'colorizer'.setup({ '*' }, {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        names = false,
        rgb_fn = true,
        hsl_fn = true,
    })
end
