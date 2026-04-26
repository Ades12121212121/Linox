local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Label = {}
Label.__index = Label

function Label.new(groupbox, text)
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({}, Label)
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    return self
end

return Label
