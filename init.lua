local ThemeManager = require(script.Themes.ThemeManager)
local WindowModule = require(script.Components.Window)

local LinoxUI = {
    Version = "1.1.0"
}

function LinoxUI:CreateWindow(options)
    return WindowModule.new(options)
end

function LinoxUI:SetTheme(themeName)
    return ThemeManager:SetTheme(themeName)
end

function LinoxUI:GetThemeManager()
    return ThemeManager
end

function LinoxUI:GetThemes()
    return ThemeManager:GetThemes()
end

return LinoxUI
