local UserInputService = game:GetService("UserInputService")
local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Slider = {}
Slider.__index = Slider

function Slider.new(groupbox, options)
    options = options or {}
    local SliderName = options.Text or "Slider"
    local Default = options.Default or 0
    local Min = options.Min or 0
    local Max = options.Max or 100
    local Rounding = options.Rounding or 0
    local Callback = options.Callback or function() end
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({
        Value = Default
    }, Slider)
    
    self.Frame = Utility:Create("Frame", {
        Name = SliderName .. "Slider",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = SliderName,
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.ValueLabel = Utility:Create("TextLabel", {
        Name = "Value",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = tostring(Default),
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    self.Background = Utility:Create("TextButton", {
        Name = "Background",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.fromOffset(0, 20),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    })
    Utility:ApplyCorners(self.Background, UDim.new(0, 4))
    Utility:ApplyStroke(self.Background)
    
    self.Fill = Utility:Create("Frame", {
        Name = "Fill",
        Parent = self.Background,
        Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
        BackgroundColor3 = theme.AccentColor,
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.Fill, UDim.new(0, 4))
    
    local function UpdateSlider(input)
        local percent = math.clamp((input.Position.X - self.Background.AbsolutePosition.X) / self.Background.AbsoluteSize.X, 0, 1)
        local value = Min + ((Max - Min) * percent)
        value = math.round(value * (10^Rounding)) / (10^Rounding)
        
        self.Value = value
        self.Fill.Size = UDim2.new(percent, 0, 1, 0)
        self.ValueLabel.Text = tostring(value)
        Callback(value)
    end
    
    local dragging = false
    self.Background.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    
    function self:SetValue(val)
        val = math.clamp(val, Min, Max)
        local percent = (val - Min) / (Max - Min)
        self.Value = val
        self.Fill.Size = UDim2.new(percent, 0, 1, 0)
        self.ValueLabel.Text = tostring(val)
        Callback(val)
    end
    
    return self
end

return Slider
