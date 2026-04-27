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
        LeftGroupboxes = 0,
        RightGroupboxes = 0
    }, Tab)
    
    self.Button = Utility:Create("TextButton", {
        Name = tabName .. "Button",
        Parent = window.TabContainer,
        Size = UDim2.fromOffset(100, 35),
        BorderSizePixel = 0,
        Text = tabName,
        TextSize = 13,
        AutoButtonColor = false
    })
    Utility:ApplyCorners(self.Button)
    Utility:ApplyStroke(self.Button)

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

    function self:Refresh(theme)
        local selected = window.CurrentTab == self
        self.Button.BackgroundColor3 = selected and theme.SecondaryColor or theme.MainColor
        self.Button.TextColor3 = selected and theme.TextColor or theme.DisabledTextColor
        self.Button.Font = theme.Font
        self.Content.ScrollBarImageColor3 = theme.AccentColor
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
        self:UpdateCanvas()
    end

    self.Button.MouseButton1Click:Connect(function()
        selectTab()
    end)

    if not window.CurrentTab then
        selectTab()
    end

    Utility:RegisterTheme(self.Button, function(theme)
        self:Refresh(theme)
    end)
    
    return self
end

function Tab:UpdateCanvas()
    local leftSize = self.LeftLayout.AbsoluteContentSize.Y
    local rightSize = self.RightLayout.AbsoluteContentSize.Y
    self.Content.CanvasSize = UDim2.new(0, 0, 0, math.max(leftSize, rightSize) + 20)
end

function Tab:AddGroupbox(options)
    local groupbox = GroupboxModule.new(self, options)
    self:UpdateCanvas()
    return groupbox
end

return Tab
