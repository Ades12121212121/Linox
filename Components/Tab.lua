local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)
local GroupboxModule = require(script.Parent.Groupbox)

local Tab = {}
Tab.__index = Tab

function Tab.new(window, options)
    options = options or {}
    local tabName = options.Name or "Tab"

    local self = setmetatable({
        Window = window,
        Name = tabName,
    }, Tab)

    self.Button = Utility:Create("TextButton", {
        Name = tabName .. "Button",
        Parent = window.TabContainer,
        Size = UDim2.fromOffset(options.Width or 100, 35),
        BorderSizePixel = 0,
        Text = tabName,
        TextSize = 13,
        AutoButtonColor = false
    })

    self.Content = Utility:Create("ScrollingFrame", {
        Name = tabName .. "Content",
        Parent = window.ContentContainer,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0
    })

    self.ContentRoot = Utility:Create("Frame", {
        Name = "ContentRoot",
        Parent = self.Content,
        Size = UDim2.new(1, -4, 0, 0),
        BackgroundTransparency = 1
    })

    self.ContentLayout = Utility:Create("UIListLayout", {
        Parent = self.ContentRoot,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    self.TopColumn = Utility:Create("Frame", {
        Name = "TopColumn",
        Parent = self.ContentRoot,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 1
    })

    self.MiddleZone = Utility:Create("Frame", {
        Name = "MiddleZone",
        Parent = self.ContentRoot,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 2
    })

    self.BottomColumn = Utility:Create("Frame", {
        Name = "BottomColumn",
        Parent = self.ContentRoot,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 3
    })

    self.LeftColumn = Utility:Create("Frame", {
        Name = "LeftColumn",
        Parent = self.MiddleZone,
        Size = UDim2.new(0.5, -5, 1, 0),
        BackgroundTransparency = 1
    })

    self.RightColumn = Utility:Create("Frame", {
        Name = "RightColumn",
        Parent = self.MiddleZone,
        Size = UDim2.new(0.5, -5, 1, 0),
        Position = UDim2.new(0.5, 5, 0, 0),
        BackgroundTransparency = 1
    })

    self.TopLayout = Utility:Create("UIListLayout", { Parent = self.TopColumn, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
    self.LeftLayout = Utility:Create("UIListLayout", { Parent = self.LeftColumn, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
    self.RightLayout = Utility:Create("UIListLayout", { Parent = self.RightColumn, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
    self.BottomLayout = Utility:Create("UIListLayout", { Parent = self.BottomColumn, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

    function self:Refresh(theme)
        local selected = window.CurrentTab == self
        local background = selected and theme.SecondaryColor or theme.MainColor

        self.Button.TextColor3 = selected and theme.TextColor or theme.DisabledTextColor
        self.Button.Font = theme.Font
        self.Content.ScrollBarImageColor3 = theme.AccentColor
        Utility:Animate(window, self.Button, { BackgroundColor3 = background }, 0.12)
        Utility:ApplyCorners(self.Button, theme.ElementRadius)
        Utility:ApplyStroke(self.Button, selected and theme.AccentColor or theme.SoftOutlineColor)
    end

    local function selectTab()
        if window.CurrentTab then
            window.CurrentTab.Content.Visible = false
            window.CurrentTab:Refresh(ThemeManager:GetTheme())
        end

        self.Content.Visible = true
        window.CurrentTab = self

        for _, tab in ipairs(window.Tabs) do
            tab:Refresh(ThemeManager:GetTheme())
        end

        self:Refresh(ThemeManager:GetTheme())
        self:UpdateCanvas()
    end

    Utility:Connect(window, self.Button.MouseButton1Click, selectTab)

    if not window.CurrentTab then
        selectTab()
    end

    Utility:RegisterThemeFor(window, self.Button, function(theme)
        self:Refresh(theme)
    end)

    return self
end

function Tab:UpdateCanvas()
    local topSize = self.TopLayout.AbsoluteContentSize.Y
    local leftSize = self.LeftLayout.AbsoluteContentSize.Y
    local rightSize = self.RightLayout.AbsoluteContentSize.Y
    local bottomSize = self.BottomLayout.AbsoluteContentSize.Y
    local middleSize = math.max(leftSize, rightSize)

    self.TopColumn.Size = UDim2.new(1, 0, 0, topSize)
    self.MiddleZone.Size = UDim2.new(1, 0, 0, middleSize)
    self.BottomColumn.Size = UDim2.new(1, 0, 0, bottomSize)

    local contentSize = topSize + middleSize + bottomSize + 30
    self.ContentRoot.Size = UDim2.new(1, -4, 0, contentSize)
    self.Content.CanvasSize = UDim2.new(0, 0, 0, contentSize + 10)
end

function Tab:ResolveZone(options)
    options = options or {}
    local zone = string.lower(options.Zone or options.Side or "left")

    if zone == "top" then
        return self.TopColumn
    elseif zone == "bottom" then
        return self.BottomColumn
    elseif zone == "right" then
        return self.RightColumn
    end

    return self.LeftColumn
end

function Tab:AddGroupbox(options)
    local groupbox = GroupboxModule.new(self, options)
    self:UpdateCanvas()
    return groupbox
end

return Tab
