local Themes = require(script.Parent.List)

local ThemeManager = {
    CurrentThemeName = "NextGen",
    CurrentTheme = Themes.NextGen,
    Watchers = {}
}

function ThemeManager:SetTheme(themeName)
    local theme = Themes[themeName]
    if not theme then
        return false
    end

    self.CurrentThemeName = themeName
    self.CurrentTheme = theme

    for object, callback in pairs(self.Watchers) do
        if object == nil or object.Parent == nil then
            self.Watchers[object] = nil
        else
            callback(theme, themeName)
        end
    end

    return true
end

function ThemeManager:GetTheme()
    return self.CurrentTheme
end

function ThemeManager:GetThemeName()
    return self.CurrentThemeName
end

function ThemeManager:GetThemes()
    return Themes
end

function ThemeManager:Register(object, callback)
    if object and callback then
        self.Watchers[object] = callback
        callback(self.CurrentTheme, self.CurrentThemeName)
    end
end

function ThemeManager:Unregister(object)
    self.Watchers[object] = nil
end

return ThemeManager
