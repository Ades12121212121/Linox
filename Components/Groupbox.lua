local Utility = require(script.Parent.Parent.Utility.Utility)
local ThemeManager = require(script.Parent.Parent.Themes.ThemeManager)

local ToggleModule = require(script.Parent.Parent.Elements.Toggle)
local SliderModule = require(script.Parent.Parent.Elements.Slider)
local ButtonModule = require(script.Parent.Parent.Elements.Button)
local DropdownModule = require(script.Parent.Parent.Elements.Dropdown)
local KeybindModule = require(script.Parent.Parent.Elements.Keybind)
local LabelModule = require(script.Parent.Parent.Elements.Label)

local Groupbox = {}
Groupbox.__index = Groupbox

function Groupbox.new(tab, options)
    options = options or {}
    local groupName = options.Name or "Groupbox"
    local side = string.lower(options.Side or "left")
    
    local self = setmetatable({
        Tab = tab,
        Window = tab.Window,
    }, Groupbox)
    
    local parentColumn = tab:ResolveZone({
        Zone = options.Zone,
        Side = side
    })
    
    self.Frame = Utility:Create("Frame", {
        Name = groupName,
        Parent = parentColumn,
        Size = UDim2.new(1, 0, 0, 20),
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.Frame)
    Utility:ApplyStroke(self.Frame)
    
    self.Title = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = self.Frame,
        Size = UDim2.new(1, -16, 0, 25),
        Position = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        Text = groupName,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    self.TitleLine = Utility:Create("Frame", {
        Name = "TitleLine",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.fromOffset(0, 25),
        BorderSizePixel = 0
    })
    
    self.ElementContainer = Utility:Create("Frame", {
        Name = "ElementContainer",
        Parent = self.Frame,
        Size = UDim2.new(1, -16, 1, -35),
        Position = UDim2.fromOffset(8, 30),
        BackgroundTransparency = 1
    })
    
    self.Layout = Utility:Create("UIListLayout", {
        Parent = self.ElementContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })

    Utility:RegisterThemeFor(self.Window, self.Frame, function(theme)
        self.Frame.BackgroundColor3 = theme.SurfaceColor
        self.Title.TextColor3 = theme.TextColor
        self.Title.Font = theme.Font
        self.TitleLine.BackgroundColor3 = theme.SoftOutlineColor
        Utility:ApplyCorners(self.Frame, theme.CornerRadius)
        Utility:ApplyStroke(self.Frame, theme.SoftOutlineColor)
    end)
    
    Utility:Connect(self.Window, self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        self.Frame.Size = UDim2.new(1, 0, 0, self.Layout.AbsoluteContentSize.Y + 40)
        tab:UpdateCanvas()
    end)
    
    return self
end

function Groupbox:AddToggle(options)
    return ToggleModule.new(self, options)
end

function Groupbox:AddSlider(options)
    return SliderModule.new(self, options)
end

function Groupbox:AddButton(options)
    return ButtonModule.new(self, options)
end

function Groupbox:AddDropdown(options)
    return DropdownModule.new(self, options)
end

function Groupbox:AddKeybind(options)
    return KeybindModule.new(self, options)
end

function Groupbox:AddLabel(text)
    return LabelModule.new(self, text)
end

return Groupbox
