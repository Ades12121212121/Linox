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
    local GroupName = options.Name or "Groupbox"
    local Side = string.lower(options.Side or "left")
    local theme = ThemeManager:GetTheme()
    
    local self = setmetatable({
        Tab = tab,
    }, Groupbox)
    
    local ParentColumn = (Side == "left") and tab.LeftColumn or tab.RightColumn
    
    self.Frame = Utility:Create("Frame", {
        Name = GroupName,
        Parent = ParentColumn,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundColor3 = theme.BackgroundColor,
        BorderSizePixel = 0
    })
    Utility:ApplyCorners(self.Frame)
    Utility:ApplyStroke(self.Frame)
    
    local Title = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = self.Frame,
        Size = UDim2.new(1, -16, 0, 25),
        Position = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        Text = GroupName,
        TextColor3 = theme.TextColor,
        Font = theme.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local TitleLine = Utility:Create("Frame", {
        Name = "TitleLine",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.fromOffset(0, 25),
        BackgroundColor3 = theme.OutlineColor,
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
    
    self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
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
