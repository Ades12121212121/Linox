local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)
local TabModule = require(script.Parent.Tab)

local LocalPlayer = Players.LocalPlayer
local guiParent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui

local LinoxScreenGui = Utility:Create("ScreenGui", {
    Name = "LinoxUI",
    Parent = guiParent,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})

local Window = {}
Window.__index = Window

function Window.new(options)
    options = options or {}
    local WindowName = options.Name or "Linox UI"
    local WindowSize = options.Size or UDim2.fromOffset(550, 600)
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({
        Tabs = {},
        CurrentTab = nil,
    }, Window)
    
    self.MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Parent = LinoxScreenGui,
        Size = WindowSize,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.BackgroundColor,
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.MainFrame)
    Utility:ApplyStroke(self.MainFrame)

    self.TopBar = Utility:Create("Frame", {
        Name = "TopBar",
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.TopBar)
    
    Utility:Create("Frame", {
        Name = "BottomFix",
        Parent = self.TopBar,
        Size = UDim2.new(1, 0, 0, theme.CornerRadius.Offset),
        Position = UDim2.new(0, 0, 1, -theme.CornerRadius.Offset),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0
    })

    Utility:Create("TextLabel", {
        Name = "Title",
        Parent = self.TopBar,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(15, 0),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local Underline = Utility:Create("Frame", {
        Name = "Underline",
        Parent = self.TopBar,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.AccentColor,
        BorderSizePixel = 0
    })
    
    Utility:MakeDraggable(self.TopBar, self.MainFrame)
    
    self.TabContainer = Utility:Create("Frame", {
        Name = "TabContainer",
        Parent = self.MainFrame,
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.fromOffset(10, 40),
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
        Size = UDim2.new(1, -20, 1, -90),
        Position = UDim2.fromOffset(10, 80),
        BackgroundColor3 = theme.MainColor,
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.ContentContainer)
    Utility:ApplyStroke(self.ContentContainer)

    return self
end

function Window:AddTab(options)
    local tab = TabModule.new(self, options)
    table.insert(self.Tabs, tab)
    return tab
end

return Window
