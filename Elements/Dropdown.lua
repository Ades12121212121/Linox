local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(groupbox, options)
    options = options or {}
    local DropName = options.Text or "Dropdown"
    local Values = options.Values or {}
    local Default = options.Default or 1
    local Callback = options.Callback or function() end
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({
        Value = Values[Default]
    }, Dropdown)
    
    self.Frame = Utility:Create("Frame", {
        Name = DropName .. "Dropdown",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1
    })
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = DropName,
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.Button = Utility:Create("TextButton", {
        Name = "Button",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.fromOffset(0, 20),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0,
        Text = "  " .. tostring(self.Value),
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })
    Utility:ApplyCorners(self.Button, UDim.new(0, 4))
    Utility:ApplyStroke(self.Button)
    
    self.Icon = Utility:Create("TextLabel", {
        Name = "Icon",
        Parent = self.Button,
        Size = UDim2.new(0, 25, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "v",
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13
    })
    
    self.List = Utility:Create("ScrollingFrame", {
        Name = "List",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.fromOffset(0, 50),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        Visible = false,
        ZIndex = 5,
        ScrollBarImageColor3 = theme.AccentColor
    })
    Utility:ApplyCorners(self.List, UDim.new(0, 4))
    Utility:ApplyStroke(self.List)
    
    self.ListLayout = Utility:Create("UIListLayout", {
        Parent = self.List,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local Open = false
    
    local function UpdateList()
        for _, child in pairs(self.List:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for i, val in ipairs(Values) do
            local Item = Utility:Create("TextButton", {
                Name = "Item" .. tostring(i),
                Parent = self.List,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = "  " .. tostring(val),
                TextColor3 = (self.Value == val) and theme.AccentColor or theme.TextColor,
                Font = theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            })
            
            Item.MouseButton1Click:Connect(function()
                self.Value = val
                self.Button.Text = "  " .. tostring(val)
                Open = false
                self.List.Visible = false
                self.Icon.Text = "v"
                UpdateList()
                Callback(val)
            end)
        end
        self.List.CanvasSize = UDim2.new(0, 0, 0, self.ListLayout.AbsoluteContentSize.Y)
    end
    
    self.Button.MouseButton1Click:Connect(function()
        Open = not Open
        if Open then
            UpdateList()
            self.List.Size = UDim2.new(1, 0, 0, math.min(#Values * 25, 125))
            self.List.Visible = true
            self.Icon.Text = "^"
        else
            self.List.Visible = false
            self.Icon.Text = "v"
        end
    end)
    
    function self:SetValue(val)
        self.Value = val
        self.Button.Text = "  " .. tostring(val)
        UpdateList()
        Callback(val)
    end
    
    UpdateList()
    return self
end

return Dropdown
