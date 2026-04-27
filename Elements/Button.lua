local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Button = {}
Button.__index = Button

function Button.new(groupbox, options)
    options = options or {}
    local text = options.Text or "Button"
    local callback = options.Callback or function() end
    
    local self = setmetatable({}, Button)
    
    self.ButtonFrame = Utility:Create("TextButton", {
        Name = text .. "Button",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 28),
        BorderSizePixel = 0,
        Text = text,
        TextSize = 13,
        AutoButtonColor = false
    })

    local pressed = false
    local hovered = false

    local function refresh(theme)
        self.ButtonFrame.BackgroundColor3 = pressed and theme.AccentColor or (hovered and theme.SecondaryColor or theme.MainColor)
        self.ButtonFrame.TextColor3 = theme.TextColor
        self.ButtonFrame.Font = theme.Font
        Utility:ApplyCorners(self.ButtonFrame, theme.ElementRadius)
        Utility:ApplyStroke(self.ButtonFrame, pressed and theme.AccentColor2 or theme.SoftOutlineColor)
    end

    Utility:RegisterTheme(self.ButtonFrame, refresh)

    self.ButtonFrame.MouseEnter:Connect(function()
        hovered = true
        refresh(ThemeManager:GetTheme())
    end)

    self.ButtonFrame.MouseLeave:Connect(function()
        hovered = false
        pressed = false
        refresh(ThemeManager:GetTheme())
    end)
    
    self.ButtonFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pressed = true
            refresh(ThemeManager:GetTheme())
        end
    end)
    
    self.ButtonFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pressed = false
            refresh(ThemeManager:GetTheme())
        end
    end)
    
    self.ButtonFrame.MouseButton1Click:Connect(callback)
    
    return self
end

return Button
