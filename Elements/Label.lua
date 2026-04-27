local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Label = {}
Label.__index = Label

function Label.new(groupbox, text)
    local self = setmetatable({}, Label)
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true
    })

    Utility:RegisterTheme(self.Label, function(theme)
        self.Label.TextColor3 = theme.TextColor
        self.Label.Font = theme.Font
    end)

    self.Label:GetPropertyChangedSignal("TextBounds"):Connect(function()
        self.Label.Size = UDim2.new(1, 0, 0, math.max(18, self.Label.TextBounds.Y + 2))
    end)
    
    return self
end

return Label
