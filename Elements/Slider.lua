local UserInputService = game:GetService("UserInputService")
local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Slider = {}
Slider.__index = Slider

function Slider.new(groupbox, options)
    options = options or {}
    local sliderName = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local rounding = options.Rounding or 0
    local callback = options.Callback or function() end
    local owner = groupbox.Window

    if max < min then
        min, max = max, min
    end

    local default = math.clamp(options.Default or min, min, max)
    
    local self = setmetatable({
        Value = default
    }, Slider)
    
    self.Frame = Utility:Create("Frame", {
        Name = sliderName .. "Slider",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = sliderName,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.ValueLabel = Utility:Create("TextLabel", {
        Name = "Value",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    self.Background = Utility:Create("TextButton", {
        Name = "Background",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.fromOffset(0, 20),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    })
    
    self.Fill = Utility:Create("Frame", {
        Name = "Fill",
        Parent = self.Background,
        BorderSizePixel = 0
    })

    local function rounded(value)
        if rounding <= 0 then
            return math.round(value)
        end

        local unit = 10 ^ rounding
        return math.round(value * unit) / unit
    end

    local function percentFromValue(value)
        if max == min then
            return 0
        end

        return math.clamp((value - min) / (max - min), 0, 1)
    end

    local function refresh(theme)
        local percent = percentFromValue(self.Value)
        self.Label.TextColor3 = theme.TextColor
        self.ValueLabel.TextColor3 = theme.TextColor
        self.Label.Font = theme.Font
        self.ValueLabel.Font = theme.Font
        self.Background.BackgroundColor3 = theme.MainColor
        self.Fill.BackgroundColor3 = theme.AccentColor
        Utility:Animate(owner, self.Fill, {
            Size = UDim2.new(percent, 0, 1, 0)
        }, 0.1)
        self.ValueLabel.Text = tostring(self.Value)
        Utility:ApplyCorners(self.Background, theme.ElementRadius)
        Utility:ApplyCorners(self.Fill, theme.ElementRadius)
        Utility:ApplyStroke(self.Background, theme.SoftOutlineColor)
        Utility:ApplyGradient(self.Fill, theme.AccentColor, theme.AccentColor2, 0)
    end

    Utility:RegisterThemeFor(owner, self.Frame, refresh)
    
    local function updateSlider(input)
        local width = self.Background.AbsoluteSize.X
        local percent = width <= 0 and 0 or math.clamp((input.Position.X - self.Background.AbsolutePosition.X) / width, 0, 1)
        local value = rounded(min + ((max - min) * percent))
        self:SetValue(value)
    end
    
    local dragging = false
    Utility:Connect(owner, self.Background.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    Utility:Connect(owner, UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    Utility:Connect(owner, UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    function self:SetValue(val)
        val = rounded(math.clamp(val, min, max))
        if self.Value == val then
            return
        end

        self.Value = val
        refresh(ThemeManager:GetTheme())
        callback(val)
    end
    
    return self
end

return Slider
