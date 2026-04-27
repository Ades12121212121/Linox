local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(groupbox, options)
    options = options or {}
    local dropName = options.Text or "Dropdown"
    local values = options.Values or {}
    local default = options.Default or 1
    local callback = options.Callback or function() end
    local owner = groupbox.Window

    local function resolveDefault()
        if typeof(default) == "number" then
            return values[default]
        end

        for _, value in ipairs(values) do
            if value == default then
                return value
            end
        end

        return values[1]
    end
    
    local self = setmetatable({
        Value = resolveDefault(),
        ItemConnections = {}
    }, Dropdown)

    Utility:AddCleanup(owner, function()
        for _, connection in ipairs(self.ItemConnections) do
            if connection and connection.Disconnect then
                connection:Disconnect()
            end
        end
        self.ItemConnections = {}
    end)
    
    self.Frame = Utility:Create("Frame", {
        Name = dropName .. "Dropdown",
        Parent = groupbox.ElementContainer,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1
    })
    
    self.Label = Utility:Create("TextLabel", {
        Name = "Label",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = dropName,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.Button = Utility:Create("TextButton", {
        Name = "Button",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.fromOffset(0, 20),
        BorderSizePixel = 0,
        Text = "  " .. tostring(self.Value or "None"),
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
        TextSize = 13
    })
    
    self.List = Utility:Create("ScrollingFrame", {
        Name = "List",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.fromOffset(0, 50),
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        Visible = false,
        ZIndex = 5,
        ClipsDescendants = true
    })
    
    self.ListLayout = Utility:Create("UIListLayout", {
        Parent = self.List,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local Open = false

    local function refresh(theme)
        self.Label.TextColor3 = theme.TextColor
        self.Label.Font = theme.Font
        self.Button.BackgroundColor3 = theme.MainColor
        self.Button.TextColor3 = self.Value and theme.TextColor or theme.DisabledTextColor
        self.Button.Font = theme.Font
        self.Icon.TextColor3 = theme.TextColor
        self.Icon.Font = theme.Font
        self.List.BackgroundColor3 = theme.MainColor
        self.List.ScrollBarImageColor3 = theme.AccentColor
        Utility:ApplyCorners(self.Button, theme.ElementRadius)
        Utility:ApplyCorners(self.List, theme.ElementRadius)
        Utility:ApplyStroke(self.Button, theme.SoftOutlineColor)
        Utility:ApplyStroke(self.List, theme.OutlineColor)
    end

    Utility:RegisterThemeFor(owner, self.Frame, refresh)
    
    local function UpdateList()
        for _, connection in ipairs(self.ItemConnections) do
            if connection and connection.Disconnect then
                connection:Disconnect()
            end
        end
        self.ItemConnections = {}

        for _, child in pairs(self.List:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local theme = ThemeManager:GetTheme()
        
        if #values == 0 then
            local Empty = Utility:Create("TextButton", {
                Name = "Empty",
                Parent = self.List,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = "  No values",
                TextColor3 = theme.DisabledTextColor,
                Font = theme.Font,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                AutoButtonColor = false
            })
            Empty.Active = false
        end
        
        for i, val in ipairs(values) do
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
            
            local connection = Item.MouseButton1Click:Connect(function()
                self.Value = val
                self.Button.Text = "  " .. tostring(val)
                Open = false
                self.List.Visible = false
                self.Icon.Text = "v"
                UpdateList()
                refresh(ThemeManager:GetTheme())
                callback(val)
            end)
            table.insert(self.ItemConnections, connection)
        end
        self.List.CanvasSize = UDim2.new(0, 0, 0, self.ListLayout.AbsoluteContentSize.Y)
    end
    
    Utility:Connect(owner, self.Button.MouseButton1Click, function()
        Open = not Open
        if Open then
            UpdateList()
            self.List.Visible = true
            Utility:Animate(owner, self.List, {
                Size = UDim2.new(1, 0, 0, math.min(math.max(#values, 1) * 25, 125))
            }, 0.12)
            self.Icon.Text = "^"
        else
            Utility:Animate(owner, self.List, {
                Size = UDim2.new(1, 0, 0, 0)
            }, 0.1)
            task.delay(0.11, function()
                if not Open then
                    self.List.Visible = false
                end
            end)
            self.Icon.Text = "v"
        end
    end)
    
    function self:SetValue(val)
        self.Value = val
        self.Button.Text = "  " .. tostring(val or "None")
        UpdateList()
        refresh(ThemeManager:GetTheme())
        callback(val)
    end
    
    UpdateList()
    return self
end

return Dropdown
