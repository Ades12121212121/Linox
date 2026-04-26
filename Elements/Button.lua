local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Button = {}
Button.__index = Button

function Button.new(groupbox, options)
    options = options or {}
    local Text = options.Text or "Button"
    local Callback = options.Callback or function() end
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({}, Button)
    
    self.ButtonFrame = Utility:Create("TextButton", {
        Name = Text .. "Button",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0,
        Text = Text,
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13,
        AutoButtonColor = false
    })
    Utility:ApplyCorners(self.ButtonFrame, UDim.new(0, 4))
    Utility:ApplyStroke(self.ButtonFrame)
    
    self.ButtonFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.ButtonFrame.BackgroundColor3 = theme.AccentColor
        end
    end)
    
    self.ButtonFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.ButtonFrame.BackgroundColor3 = theme.MainColor
        end
    end)
    
    self.ButtonFrame.MouseButton1Click:Connect(Callback)
    
    return self
end

return Button
