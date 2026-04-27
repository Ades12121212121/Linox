local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Button = {}
Button.__index = Button

function Button.new(groupbox, options)
    options = options or {}
    local text = options.Text or "Button"
    local callback = options.Callback or function() end
    local owner = groupbox.Window
    
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
        local background = pressed and theme.AccentColor or (hovered and theme.SecondaryColor or theme.MainColor)
        Utility:Animate(owner, self.ButtonFrame, { BackgroundColor3 = background }, 0.12)
        self.ButtonFrame.TextColor3 = theme.TextColor
        self.ButtonFrame.Font = theme.Font
        Utility:ApplyCorners(self.ButtonFrame, theme.ElementRadius)
        Utility:ApplyStroke(self.ButtonFrame, pressed and theme.AccentColor2 or theme.SoftOutlineColor)
    end

    Utility:RegisterThemeFor(owner, self.ButtonFrame, refresh)

    Utility:Connect(owner, self.ButtonFrame.MouseEnter, function()
        hovered = true
        refresh(ThemeManager:GetTheme())
    end)

    Utility:Connect(owner, self.ButtonFrame.MouseLeave, function()
        hovered = false
        pressed = false
        refresh(ThemeManager:GetTheme())
    end)
    
    Utility:Connect(owner, self.ButtonFrame.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pressed = true
            refresh(ThemeManager:GetTheme())
        end
    end)
    
    Utility:Connect(owner, self.ButtonFrame.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pressed = false
            refresh(ThemeManager:GetTheme())
        end
    end)
    
    Utility:Connect(owner, self.ButtonFrame.MouseButton1Click, callback)
    
    return self
end

return Button
