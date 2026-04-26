local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(groupbox, options)
    options = options or {}
    local ToggleName = options.Text or "Toggle"
    local Default = options.Default or false
    local Callback = options.Callback or function() end
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({
        Value = Default
    }, Toggle)
    
    self.Frame = Utility:Create("Frame", {
        Name = ToggleName .. "Toggle",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1
    })
    
    self.Checkbox = Utility:Create("TextButton", {
        Name = "Checkbox",
        Parent = self.Frame,
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = Default and theme.AccentColor or theme.MainColor,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    })
    Utility:ApplyCorners(self.Checkbox, UDim.new(0, 4))
    Utility:ApplyStroke(self.Checkbox)
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = self.Frame,
        Size = UDim2.new(1, -28, 1, 0),
        Position = UDim2.fromOffset(28, 0),
        BackgroundTransparency = 1,
        Text = ToggleName,
        TextColor3 = Default and theme.TextColor or theme.DisabledTextColor,
        Font = theme.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.Checkbox.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
    
    function self:SetValue(val)
        self.Value = val
        self.Checkbox.BackgroundColor3 = val and theme.AccentColor or theme.MainColor
        self.Label.TextColor3 = val and theme.TextColor or theme.DisabledTextColor
        Callback(self.Value)
    end
    
    return self
end

return Toggle
