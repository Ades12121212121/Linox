local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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

function Utility:RegisterThemeFor(owner, instance, callback)
    ThemeManager:Register(instance, callback)

    if owner then
        owner._themeObjects = owner._themeObjects or {}
        table.insert(owner._themeObjects, instance)
    end
end

function Utility:Tween(instance, info, properties)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

function Utility:Set(instance, properties)
    for key, value in pairs(properties or {}) do
        instance[key] = value
    end
end

function Utility:Animate(owner, instance, properties, duration)
    if owner and owner.Animations == false then
        self:Set(instance, properties)
        return nil
    end

    local ok, tween = pcall(function()
        return self:Tween(instance, TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    end)

    if ok then
        return tween
    end

    pcall(function()
        self:Set(instance, properties)
    end)

    return nil
end

function Utility:Track(owner, connection)
    if owner and connection then
        owner._connections = owner._connections or {}
        table.insert(owner._connections, connection)
    end

    return connection
end

function Utility:AddCleanup(owner, cleanup)
    if owner and cleanup then
        owner._cleanups = owner._cleanups or {}
        table.insert(owner._cleanups, cleanup)
    end
end

function Utility:Connect(owner, signal, callback)
    return self:Track(owner, signal:Connect(callback))
end

function Utility:Cleanup(owner)
    if not owner then
        return
    end

    for _, cleanup in ipairs(owner._cleanups or {}) do
        pcall(cleanup)
    end

    for _, connection in ipairs(owner._connections or {}) do
        if connection and connection.Disconnect then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end

    ThemeManager:UnregisterMany(owner._themeObjects)
    owner._connections = {}
    owner._themeObjects = {}
    owner._cleanups = {}
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

function Utility:MakeDraggable(topbarobject, object, owner)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    self:Connect(owner, topbarobject.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = object.Position
            
            self:Track(owner, input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end))
        end
    end)

    self:Connect(owner, topbarobject.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    self:Connect(owner, UserInputService.InputChanged, function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
end

return Utility
