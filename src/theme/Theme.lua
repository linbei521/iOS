-- iOS Theme Manager
local Colors = require(script.Parent.Colors)
local Typography = require(script.Parent.Typography)

local Theme = {}
Theme.__index = Theme

-- Current theme
Theme.current = "light"
Theme.automaticSwitching = true

-- Theme definitions
Theme.themes = {
    light = {
        colors = Colors.light,
        typography = Typography.regular
    },
    dark = {
        colors = Colors.dark,
        typography = Typography.regular
    }
}

function Theme.setTheme(themeName)
    if Theme.themes[themeName] then
        Theme.current = themeName
        Theme.updateAppearance()
    end
end

function Theme.toggleTheme()
    Theme.current = Theme.current == "light" and "dark" or "light"
    Theme.updateAppearance()
end

function Theme.updateAppearance()
    -- Notify all views to update their appearance
    -- This would trigger a re-render in a real implementation
end

function Theme.getColor(colorName)
    local theme = Theme.themes[Theme.current]
    return theme.colors[colorName] or Colors.light[colorName]
end

function Theme.getFont(fontName)
    local theme = Theme.themes[Theme.current]
    return theme.typography[fontName] or Typography.regular[fontName]
end

-- Convenience accessors
Theme.Colors = setmetatable({}, {
    __index = function(_, key)
        return Theme.getColor(key)
    end
})

Theme.Typography = setmetatable({}, {
    __index = function(_, key)
        return Theme.getFont(key)
    end
})

return Theme