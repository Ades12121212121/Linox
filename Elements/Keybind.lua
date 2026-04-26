local UserInputService = game:GetService("UserInputService")
local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(groupbox, options)
    options = options or {}
    local KeyName = options.Text or "Keybind"
    local Default = options.Default or Enum.KeyCode.Unknown
    local Callback = options.Callback or function() end
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({
        Value = Default
    }, Keybind)
    
    self.Frame = Utility:Create("Frame", {
        Name = KeyName .. "Keybind",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1
    })
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = self.Frame,
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = KeyName,
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.Button = Utility:Create("TextButton", {
        Name = "Button",
        Parent = self.Frame,
        Size = UDim2.new(0, 50, 1, 0),
        Position = UDim2.new(1, -50, 0, 0),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0,
        Text = (Default == Enum.KeyCode.Unknown) and "None" or Default.Name,
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 12,
        AutoButtonColor = false
    })
    Utility:ApplyCorners(self.Button, UDim.new(0, 4))
    Utility:ApplyStroke(self.Button)
    
    local binding = false
    
    self.Button.MouseButton1Click:Connect(function()
        binding = true
        self.Button.Text = "..."
        self.Button.TextColor3 = theme.AccentColor
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
                self.Button.TextColor3 = theme.TextColor
                binding = false
                Callback(key)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                local key = input.UserInputType
                self.Value = key
                self.Button.Text = key.Name
                self.Button.TextColor3 = theme.TextColor
                binding = false
                Callback(key)
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Value then
            Callback(self.Value)
        elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == self.Value then
            Callback(self.Value)
        end
    end)
    
    return self
end

return Keybind
