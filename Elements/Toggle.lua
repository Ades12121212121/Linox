local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(groupbox, options)
    options = options or {}
    local toggleName = options.Text or "Toggle"
    local default = options.Default == true
    local callback = options.Callback or function() end
    local owner = groupbox.Window
    
    local self = setmetatable({
        Value = default
    }, Toggle)
    
    self.Frame = Utility:Create("Frame", {
        Name = toggleName .. "Toggle",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1
    })
    
    self.Checkbox = Utility:Create("TextButton", {
        Name = "Checkbox",
        Parent = self.Frame,
        Size = UDim2.fromOffset(34, 18),
        Position = UDim2.fromOffset(0, 2),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    })

    self.Knob = Utility:Create("Frame", {
        Name = "Knob",
        Parent = self.Checkbox,
        Size = UDim2.fromOffset(12, 12),
        BorderSizePixel = 0
    })
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = self.Frame,
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.fromOffset(44, 0),
        BackgroundTransparency = 1,
        Text = toggleName,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local function refresh(theme)
        Utility:Animate(owner, self.Checkbox, {
            BackgroundColor3 = self.Value and theme.AccentColor or theme.MainColor
        }, 0.12)
        Utility:Animate(owner, self.Knob, {
            BackgroundColor3 = self.Value and theme.TextColor or theme.DisabledTextColor,
            Position = self.Value and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
        }, 0.12)
        self.Label.TextColor3 = self.Value and theme.TextColor or theme.DisabledTextColor
        self.Label.Font = theme.Font
        Utility:ApplyCorners(self.Checkbox, UDim.new(0, 9))
        Utility:ApplyCorners(self.Knob, UDim.new(0, 6))
        Utility:ApplyStroke(self.Checkbox, self.Value and theme.AccentColor2 or theme.SoftOutlineColor)
    end

    Utility:RegisterThemeFor(owner, self.Frame, refresh)
    
    Utility:Connect(owner, self.Checkbox.MouseButton1Click, function()
        self:SetValue(not self.Value)
    end)
    
    function self:SetValue(val)
        self.Value = val == true
        refresh(ThemeManager:GetTheme())
        callback(self.Value)
    end
    
    return self
end

return Toggle
