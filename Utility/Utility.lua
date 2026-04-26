local UserInputService = game:GetService("UserInputService")
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Utility = {}

function Utility:Create(class, properties)
    local instance = Instance.new(class)
    for i, v in pairs(properties) do
        instance[i] = v
    end
    return instance
end

function Utility:ApplyCorners(instance, customRadius)
    local theme = ThemeManager:GetTheme()
    local radius = customRadius or theme.CornerRadius
    if radius.Offset > 0 or radius.Scale > 0 then
        self:Create("UICorner", {
            CornerRadius = radius,
            Parent = instance
        })
    end
end

function Utility:ApplyStroke(instance, customColor)
    local theme = ThemeManager:GetTheme()
    if theme.StrokeThickness > 0 then
        self:Create("UIStroke", {
            Color = customColor or theme.OutlineColor,
            Thickness = theme.StrokeThickness,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Parent = instance
        })
    end
end

function Utility:MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
    end)
end

return Utility
