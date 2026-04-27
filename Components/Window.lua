local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)
local TabModule = require(script.Parent.Tab)

local Window = {}
Window.__index = Window

local function getRegistry()
    local ok, registry = pcall(function()
        return getgenv and getgenv() or _G
    end)

    return ok and registry or _G
end

local function getGuiParent()
    local localPlayer = Players.LocalPlayer
    local playerGui = localPlayer and (localPlayer:FindFirstChildOfClass("PlayerGui") or localPlayer:WaitForChild("PlayerGui", 2))

    if RunService:IsStudio() and playerGui then
        return playerGui
    end

    local okHui, hui = pcall(function()
        return gethui and gethui()
    end)

    if okHui and hui then
        return hui
    end

    local ok = pcall(function()
        return CoreGui.Name
    end)

    return ok and CoreGui or playerGui
end

function Window.new(options)
    options = options or {}

    local windowName = options.Name or "Linox UI"
    local windowId = options.Id or windowName:gsub("%W+", "")
    local screenName = "LinoxUI_" .. windowId
    local registry = getRegistry()

    registry.__LinoxUIWindows = registry.__LinoxUIWindows or {}

    if options.AutoUnload ~= false then
        local previous = registry.__LinoxUIWindows[windowId]
        if previous then
            pcall(function()
                if type(previous) == "table" and previous.Destroy then
                    previous:Destroy()
                elseif typeof(previous) == "Instance" then
                    previous:Destroy()
                end
            end)
        end
    end

    local guiParent = getGuiParent()
    local existingGui = guiParent and guiParent:FindFirstChild(screenName)
    if existingGui and options.AutoUnload ~= false then
        existingGui:Destroy()
    end

    local self = setmetatable({
        Id = windowId,
        Name = windowName,
        Tabs = {},
        CurrentTab = nil,
        Visible = true,
        Destroyed = false,
        Animations = options.Animations ~= false,
        CloseKey = options.CloseKey == nil and Enum.KeyCode.RightShift or options.CloseKey,
        _connections = {},
        _themeObjects = {},
        _registry = registry,
    }, Window)

    self.ScreenGui = Utility:Create("ScreenGui", {
        Name = screenName,
        Parent = guiParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
    })

    registry.__LinoxUIWindows[windowId] = self

    self.MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        Size = options.Size or UDim2.fromOffset(620, 560),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0
    })

    self.Scale = Utility:Create("UIScale", {
        Parent = self.MainFrame,
        Scale = 1
    })

    self.TopBar = Utility:Create("Frame", {
        Name = "TopBar",
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 36),
        BorderSizePixel = 0
    })

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
        Size = UDim2.new(1, -56, 1, 0),
        Position = UDim2.fromOffset(14, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    self.CloseButton = Utility:Create("TextButton", {
        Name = "Close",
        Parent = self.TopBar,
        Size = UDim2.fromOffset(34, 28),
        Position = UDim2.new(1, -38, 0, 4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "X",
        TextSize = 14,
        AutoButtonColor = false
    })

    self.Underline = Utility:Create("Frame", {
        Name = "Underline",
        Parent = self.TopBar,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0
    })

    Utility:MakeDraggable(self.TopBar, self.MainFrame, self)

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

    Utility:RegisterThemeFor(self, self.MainFrame, function(theme)
        self.MainFrame.BackgroundColor3 = theme.BackgroundColor
        self.MainFrame.BackgroundTransparency = theme.Transparency or 0
        self.TopBar.BackgroundColor3 = theme.MainColor
        self.TopBarFix.BackgroundColor3 = theme.MainColor
        self.Title.TextColor3 = theme.TextColor
        self.Title.Font = theme.Font
        self.CloseButton.TextColor3 = theme.DisabledTextColor
        self.CloseButton.Font = theme.Font
        self.Underline.BackgroundColor3 = theme.AccentColor
        self.ContentContainer.BackgroundColor3 = theme.MainColor

        Utility:ApplyCorners(self.MainFrame, theme.CornerRadius)
        Utility:ApplyCorners(self.TopBar, theme.CornerRadius)
        Utility:ApplyCorners(self.CloseButton, theme.ElementRadius)
        Utility:ApplyCorners(self.ContentContainer, theme.CornerRadius)
        Utility:ApplyStroke(self.MainFrame, theme.OutlineColor)
        Utility:ApplyStroke(self.ContentContainer, theme.SoftOutlineColor)
        Utility:ApplyGradient(self.TopBar, theme.MainColor, theme.SecondaryColor, theme.GradientRotation)
    end)

    Utility:Connect(self, self.CloseButton.MouseEnter, function()
        local theme = ThemeManager:GetTheme()
        Utility:Animate(self, self.CloseButton, {
            BackgroundTransparency = 0,
            BackgroundColor3 = theme.SecondaryColor,
            TextColor3 = theme.TextColor
        }, 0.12)
    end)

    Utility:Connect(self, self.CloseButton.MouseLeave, function()
        Utility:Animate(self, self.CloseButton, {
            BackgroundTransparency = 1,
            TextColor3 = ThemeManager:GetTheme().DisabledTextColor
        }, 0.12)
    end)

    Utility:Connect(self, self.CloseButton.MouseButton1Click, function()
        self:Destroy()
    end)

    if self.CloseKey then
        Utility:Connect(self, UserInputService.InputBegan, function(input, gameProcessed)
            if gameProcessed or self._closeKeyHeld then
                return
            end

            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.CloseKey then
                self._closeKeyHeld = true
                self:Toggle()
            end
        end)

        Utility:Connect(self, UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.CloseKey then
                self._closeKeyHeld = false
            end
        end)
    end

    self:Open()
    return self
end

function Window:Open()
    if self.Destroyed then
        return
    end

    self.Visible = true
    self.ScreenGui.Enabled = true
    self.MainFrame.Visible = true

    if self.Animations then
        self.Scale.Scale = 0.96
        Utility:Animate(self, self.Scale, { Scale = 1 }, 0.16)
    else
        self.Scale.Scale = 1
    end
end

function Window:Close()
    if self.Destroyed then
        return
    end

    self.Visible = false

    if self.Animations then
        Utility:Animate(self, self.Scale, { Scale = 0.96 }, 0.12)
        task.delay(0.13, function()
            if not self.Destroyed and not self.Visible then
                self.MainFrame.Visible = false
            end
        end)
    else
        self.MainFrame.Visible = false
    end
end

function Window:Toggle()
    if self.Visible then
        self:Close()
    else
        self:Open()
    end
end

function Window:Destroy()
    if self.Destroyed then
        return
    end

    self.Destroyed = true
    Utility:Cleanup(self)

    if self._registry and self._registry.__LinoxUIWindows and self._registry.__LinoxUIWindows[self.Id] == self then
        self._registry.__LinoxUIWindows[self.Id] = nil
    end

    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

function Window:AddTab(options)
    local tab = TabModule.new(self, options)
    table.insert(self.Tabs, tab)
    return tab
end

return Window
