local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)
local TabModule = require(script.Parent.Tab)

local LocalPlayer = Players.LocalPlayer
local guiParent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui

local Window = {}
Window.__index = Window

local windowCount = 0

function Window.new(options)
    options = options or {}
    local windowName = options.Name or "Linox UI"
    local windowSize = options.Size or UDim2.fromOffset(580, 610)

    windowCount += 1
    
    local self = setmetatable({
        Tabs = {},
        CurrentTab = nil,
        Name = windowName,
    }, Window)

    self.ScreenGui = Utility:Create("ScreenGui", {
        Name = "LinoxUI_" .. tostring(windowCount),
        Parent = guiParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
    })
    
    self.MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        Size = windowSize,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.MainFrame)
    Utility:ApplyStroke(self.MainFrame)

    self.TopBar = Utility:Create("Frame", {
        Name = "TopBar",
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 36),
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.TopBar)
    
    self.TopBarFix = Utility:Create("Frame", {
        Name = "BottomFix",
        Parent = self.TopBar,
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BorderSizePixel = 0
    })

    self.Title = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = self.TopBar,
        Size = UDim2.new(1, -28, 1, 0),
        Position = UDim2.fromOffset(14, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.Underline = Utility:Create("Frame", {
        Name = "Underline",
        Parent = self.TopBar,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0
    })
    
    Utility:MakeDraggable(self.TopBar, self.MainFrame)
    
    self.TabContainer = Utility:Create("Frame", {
        Name = "TabContainer",
        Parent = self.MainFrame,
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.fromOffset(10, 46),
        BackgroundTransparency = 1
    })

    Utility:Create("UIListLayout", {
        Parent = self.TabContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    self.ContentContainer = Utility:Create("Frame", {
        Name = "ContentContainer",
        Parent = self.MainFrame,
        Size = UDim2.new(1, -20, 1, -96),
        Position = UDim2.fromOffset(10, 86),
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.ContentContainer)
    Utility:ApplyStroke(self.ContentContainer)

    Utility:RegisterTheme(self.MainFrame, function(theme)
        self.MainFrame.BackgroundColor3 = theme.BackgroundColor
        self.MainFrame.BackgroundTransparency = theme.Transparency or 0
        self.TopBar.BackgroundColor3 = theme.MainColor
        self.TopBarFix.BackgroundColor3 = theme.MainColor
        self.Title.TextColor3 = theme.TextColor
        self.Title.Font = theme.Font
        self.Underline.BackgroundColor3 = theme.AccentColor
        self.ContentContainer.BackgroundColor3 = theme.MainColor

        Utility:ApplyCorners(self.MainFrame, theme.CornerRadius)
        Utility:ApplyCorners(self.TopBar, theme.CornerRadius)
        Utility:ApplyCorners(self.ContentContainer, theme.CornerRadius)
        Utility:ApplyStroke(self.MainFrame, theme.OutlineColor)
        Utility:ApplyStroke(self.ContentContainer, theme.SoftOutlineColor)
        Utility:ApplyGradient(self.TopBar, theme.MainColor, theme.SecondaryColor, theme.GradientRotation)
    end)

    return self
end

function Window:AddTab(options)
    local tab = TabModule.new(self, options)
    table.insert(self.Tabs, tab)
    return tab
end

return Window
