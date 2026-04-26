local Themes = require(script.Parent.List)

local ThemeManager = {
    CurrentTheme = Themes.NextGen
}

function ThemeManager:SetTheme(themeName)
    if Themes[themeName] then
        self.CurrentTheme = Themes[themeName]
    end
end

function ThemeManager:GetTheme()
    return self.CurrentTheme
end

return ThemeManager
