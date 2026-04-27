local UserInputService = game:GetService("UserInputService")
local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(groupbox, options)
    options = options or {}
    local keyName = options.Text or "Keybind"
    local default = options.Default or Enum.KeyCode.Unknown
    local callback = options.Callback or function() end
    
    local self = setmetatable({
        Value = default
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
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = keyName,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.Button = Utility:Create("TextButton", {
        Name = "Button",
        Parent = self.Frame,
        Size = UDim2.new(0, 68, 1, 0),
        Position = UDim2.new(1, -68, 0, 0),
        BorderSizePixel = 0,
        Text = (default == Enum.KeyCode.Unknown) and "None" or default.Name,
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

    Utility:RegisterTheme(self.Frame, refresh)
    
    self.Button.MouseButton1Click:Connect(function()
        binding = true
        self.Button.Text = "..."
        refresh(ThemeManager:GetTheme())
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if binding then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode
                if key == Enum.KeyCode.Escape then
                    key = Enum.KeyCode.Unknown
                end
                self.Value = key
                self.Button.Text = (key == Enum.KeyCode.Unknown) and "None" or key.Name
                binding = false
                refresh(ThemeManager:GetTheme())
                callback(key)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                local key = input.UserInputType
                self.Value = key
                self.Button.Text = key.Name
                binding = false
                refresh(ThemeManager:GetTheme())
                callback(key)
            end
        elseif self.Value == Enum.KeyCode.Unknown then
            return
        elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Value then
            callback(self.Value)
        elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == self.Value then
            callback(self.Value)
        end
    end)
    
    return self
end

return Keybind
