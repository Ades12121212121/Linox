local UserInputService = game:GetService("UserInputService")
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Utility = {}

function Utility:Create(class, properties)
    local instance = Instance.new(class)
    for key, value in pairs(properties or {}) do
        instance[key] = value
    end
    return instance
end

function Utility:ApplyCorners(instance, customRadius)
    local theme = ThemeManager:GetTheme()
    local radius = customRadius or theme.CornerRadius or UDim.new(0, 0)
    local corner = instance:FindFirstChildOfClass("UICorner") or self:Create("UICorner", {
        Parent = instance
    })

    corner.CornerRadius = radius
    return corner
end

function Utility:ApplyStroke(instance, customColor)
    local theme = ThemeManager:GetTheme()
    local stroke = instance:FindFirstChildOfClass("UIStroke") or self:Create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = instance
    })

    stroke.Color = customColor or theme.OutlineColor
    stroke.Thickness = theme.StrokeThickness or 1
    stroke.Transparency = 0
    return stroke
end

function Utility:ApplyPadding(instance, padding)
    local pad = instance:FindFirstChildOfClass("UIPadding") or self:Create("UIPadding", {
        Parent = instance
    })

    pad.PaddingTop = UDim.new(0, padding.Top or padding.Y or 0)
    pad.PaddingBottom = UDim.new(0, padding.Bottom or padding.Y or 0)
    pad.PaddingLeft = UDim.new(0, padding.Left or padding.X or 0)
    pad.PaddingRight = UDim.new(0, padding.Right or padding.X or 0)
    return pad
end

function Utility:ApplyGradient(instance, colorA, colorB, rotation)
    local gradient = instance:FindFirstChildOfClass("UIGradient") or self:Create("UIGradient", {
        Parent = instance
    })

    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colorA),
        ColorSequenceKeypoint.new(1, colorB)
    })
    gradient.Rotation = rotation or 0
    return gradient
end

function Utility:RegisterTheme(instance, callback)
    ThemeManager:Register(instance, callback)
end

function Utility:Tween(instance, info, properties)
    local TweenService = game:GetService("TweenService")
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

function Utility:SetTextScaled(label, enabled)
    label.TextScaled = enabled == true
    if label.TextScaled and not label:FindFirstChildOfClass("UITextSizeConstraint") then
        self:Create("UITextSizeConstraint", {
            MinTextSize = 10,
            MaxTextSize = label.TextSize,
            Parent = label
        })
    end
end

function Utility:MakeDraggable(topbarobject, object)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
end

return Utility
