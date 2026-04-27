local UserInputService = game:GetService("UserInputService")
local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Keybind = {}
Keybind.__index = Keybind

local function displayKey(value)
    if value == nil or value == Enum.KeyCode.Unknown then
        return "None"
    end

    return value.Name or tostring(value)
end

local function inputMatches(input, value)
    if value == nil or value == Enum.KeyCode.Unknown then
        return false
    end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        return input.KeyCode == value
    end

    return input.UserInputType == value
end

function Keybind.new(groupbox, options)
    options = options or {}
    local keyName = options.Text or "Keybind"
    local default = options.Default or Enum.KeyCode.Unknown
    local callback = options.Callback or function() end
    local changedCallback = options.Changed or options.OnChanged or function() end
    local owner = groupbox.Window

    local self = setmetatable({
        Value = default,
        Pressed = false,
    }, Keybind)

    self.Frame = Utility:Create("Frame", {
        Name = keyName .. "Keybind",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1
    })

    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = self.Frame,
        Size = UDim2.new(1, -78, 1, 0),
        BackgroundTransparency = 1,
        Text = keyName,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    self.Button = Utility:Create("TextButton", {
        Name = "Button",
        Parent = self.Frame,
        Size = UDim2.new(0, 76, 1, 0),
        Position = UDim2.new(1, -76, 0, 0),
        BorderSizePixel = 0,
        Text = displayKey(default),
        TextSize = 12,
        AutoButtonColor = false
    })

    local binding = false

    local function refresh(theme)
        self.Label.TextColor3 = theme.TextColor
        self.Label.Font = theme.Font
        self.Button.BackgroundColor3 = binding and theme.SecondaryColor or theme.MainColor
        self.Button.TextColor3 = binding and theme.AccentColor or theme.TextColor
        self.Button.Font = theme.Font
        Utility:ApplyCorners(self.Button, theme.ElementRadius)
        Utility:ApplyStroke(self.Button, binding and theme.AccentColor or theme.SoftOutlineColor)
    end

    function self:SetValue(value, fireChanged)
        self.Value = value or Enum.KeyCode.Unknown
        self.Button.Text = displayKey(self.Value)
        refresh(ThemeManager:GetTheme())

        if fireChanged then
            changedCallback(self.Value)
        end
    end

    Utility:RegisterThemeFor(owner, self.Frame, refresh)

    Utility:Connect(owner, self.Button.MouseButton1Click, function()
        binding = true
        self.Button.Text = "..."
        refresh(ThemeManager:GetTheme())
    end)

    Utility:Connect(owner, UserInputService.InputBegan, function(input, gameProcessed)
        if binding then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                binding = false
                self.Pressed = false
                self:SetValue(input.KeyCode == Enum.KeyCode.Escape and Enum.KeyCode.Unknown or input.KeyCode, true)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                binding = false
                self.Pressed = false
                self:SetValue(input.UserInputType, true)
            end

            return
        end

        if gameProcessed or self.Pressed or not inputMatches(input, self.Value) then
            return
        end

        self.Pressed = true
        callback(self.Value)
    end)

    Utility:Connect(owner, UserInputService.InputEnded, function(input)
        if inputMatches(input, self.Value) then
            self.Pressed = false
        end
    end)

    return self
end

return Keybind
