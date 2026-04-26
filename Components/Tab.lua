local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)
local GroupboxModule = require(script.Parent.Groupbox)

local Tab = {}
Tab.__index = Tab

function Tab.new(window, options)
    options = options or {}
    local TabName = options.Name or "Tab"
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({
        Window = window,
        Name = TabName,
        LeftGroupboxes = 0,
        RightGroupboxes = 0
    }, Tab)
    
    self.Button = Utility:Create("TextButton", {
        Name = TabName .. "Button",
        Parent = window.TabContainer,
        Size = UDim2.fromOffset(100, 35),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0,
        Text = TabName,
        TextColor3 = theme.DisabledTextColor,
        Font = theme.Font,
        TextSize = 13,
        AutoButtonColor = false
    })
    Utility:ApplyCorners(self.Button)
    Utility:ApplyStroke(self.Button)

    self.Content = Utility:Create("ScrollingFrame", {
        Name = TabName .. "Content",
        Parent = window.ContentContainer,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarImageColor3 = theme.AccentColor,
        BorderSizePixel = 0
    })
    
    self.LeftColumn = Utility:Create("Frame", {
        Name = "LeftColumn",
        Parent = self.Content,
        Size = UDim2.new(0.5, -5, 1, 0),
        BackgroundTransparency = 1
    })
    
    self.RightColumn = Utility:Create("Frame", {
        Name = "RightColumn",
        Parent = self.Content,
        Size = UDim2.new(0.5, -5, 1, 0),
        Position = UDim2.new(0.5, 5, 0, 0),
        BackgroundTransparency = 1
    })

    self.LeftLayout = Utility:Create("UIListLayout", { Parent = self.LeftColumn, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
    self.RightLayout = Utility:Create("UIListLayout", { Parent = self.RightColumn, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

    self.Button.MouseButton1Click:Connect(function()
        if window.CurrentTab then
            window.CurrentTab.Button.TextColor3 = theme.DisabledTextColor
            window.CurrentTab.Button.BackgroundColor3 = theme.MainColor
            window.CurrentTab.Content.Visible = false
        end
        self.Button.TextColor3 = theme.TextColor
        self.Button.BackgroundColor3 = theme.BackgroundColor
        self.Content.Visible = true
        window.CurrentTab = self
    end)

    if not window.CurrentTab then
        self.Button.TextColor3 = theme.TextColor
        self.Button.BackgroundColor3 = theme.BackgroundColor
        self.Content.Visible = true
        window.CurrentTab = self
    end
    
    return self
end

function Tab:UpdateCanvas()
    local leftSize = self.LeftLayout.AbsoluteContentSize.Y
    local rightSize = self.RightLayout.AbsoluteContentSize.Y
    self.Content.CanvasSize = UDim2.new(0, 0, 0, math.max(leftSize, rightSize) + 20)
end

function Tab:AddGroupbox(options)
    return GroupboxModule.new(self, options)
end

return Tab
