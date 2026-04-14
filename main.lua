-- ////////////////////////////////////////////////////////////
--   NexusGui Framework v1.0
--   Framework GUI propio para Roblox Exploits
--   GitHub: (tu-repo)/NexusGuiFramework.lua
--   Uso: local Nexus = loadstring(game:HttpGet("URL"))()
-- ////////////////////////////////////////////////////////////

local NexusGui = {}
NexusGui.__index = NexusGui

-- ─── Servicios ────────────────────────────────────────────────
local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─── Constantes de Estilo ─────────────────────────────────────
local THEME = {
    Background   = Color3.fromRGB(15,  15,  20),
    Surface      = Color3.fromRGB(22,  22,  30),
    SurfaceAlt   = Color3.fromRGB(30,  30,  40),
    Accent       = Color3.fromRGB(100, 80,  220),
    AccentHover  = Color3.fromRGB(130, 110, 255),
    AccentPress  = Color3.fromRGB(75,  55,  180),
    TextPrimary  = Color3.fromRGB(230, 230, 240),
    TextSecondary= Color3.fromRGB(150, 150, 170),
    TextMuted    = Color3.fromRGB(90,  90,  110),
    Border       = Color3.fromRGB(45,  45,  60),
    Success      = Color3.fromRGB(80,  200, 120),
    Warning      = Color3.fromRGB(255, 200, 50),
    Error        = Color3.fromRGB(220, 70,  70),
    Scrollbar    = Color3.fromRGB(60,  60,  80),
    TabActive    = Color3.fromRGB(100, 80,  220),
    TabInactive  = Color3.fromRGB(30,  30,  40),
    InputBg      = Color3.fromRGB(18,  18,  25),
    Shadow       = Color3.fromRGB(5,   5,   10),
}

local FONT       = Enum.Font.GothamMedium
local FONT_BOLD  = Enum.Font.GothamBold
local FONT_MONO  = Enum.Font.Code
local CORNER_SM  = 4
local CORNER_MD  = 8
local TWEEN_INFO = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ─── Helpers ──────────────────────────────────────────────────
local function applyCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or CORNER_MD)
    c.Parent = obj
    return c
end

local function applyPadding(obj, top, right, bottom, left)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 6)
    p.PaddingRight  = UDim.new(0, right  or 8)
    p.PaddingBottom = UDim.new(0, bottom or 6)
    p.PaddingLeft   = UDim.new(0, left   or 8)
    p.Parent = obj
    return p
end

local function applyStroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color or THEME.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function applyListLayout(obj, dir, spacing, halign, valign)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = dir    or Enum.FillDirection.Vertical
    l.Padding             = UDim.new(0, spacing or 4)
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent = obj
    return l
end

local function autoSize(frame, layout)
    layout.Changed:Connect(function()
        frame.Size = UDim2.new(
            frame.Size.X.Scale, frame.Size.X.Offset,
            0, layout.AbsoluteContentSize.Y + 12
        )
    end)
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            mousePos  = input.Position
            framePos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

local function tween(obj, props)
    TweenService:Create(obj, TWEEN_INFO, props):Play()
end

local function newLabel(parent, text, size, color, font, xAlign)
    local l = Instance.new("TextLabel")
    l.Text                = text or ""
    l.TextSize            = size  or 13
    l.TextColor3          = color or THEME.TextPrimary
    l.Font                = font  or FONT
    l.BackgroundTransparency = 1
    l.TextXAlignment      = xAlign or Enum.TextXAlignment.Left
    l.AutomaticSize       = Enum.AutomaticSize.Y
    l.Size                = UDim2.new(1, 0, 0, 14)
    l.TextWrapped         = true
    l.Parent              = parent
    return l
end

-- ─── Notificaciones ───────────────────────────────────────────
local notifContainer

local function ensureNotifContainer()
    if notifContainer and notifContainer.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name             = "NexusNotifs"
    sg.ResetOnSpawn     = false
    sg.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    sg.Parent           = PlayerGui

    notifContainer = Instance.new("Frame")
    notifContainer.Name              = "Container"
    notifContainer.Size              = UDim2.new(0, 300, 1, 0)
    notifContainer.Position          = UDim2.new(1, -310, 0, 0)
    notifContainer.BackgroundTransparency = 1
    notifContainer.Parent            = sg
    applyListLayout(notifContainer, Enum.FillDirection.Vertical, 6,
        Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)

    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent        = notifContainer
end

function NexusGui:Notify(options)
    ensureNotifContainer()
    options = options or {}
    local title   = options.Title   or "Notificación"
    local desc    = options.Desc    or ""
    local duration = options.Duration or 3
    local ntype   = options.Type    or "info"  -- "info"|"success"|"warning"|"error"

    local iconColor = THEME.Accent
    if ntype == "success" then iconColor = THEME.Success
    elseif ntype == "warning" then iconColor = THEME.Warning
    elseif ntype == "error"   then iconColor = THEME.Error
    end

    -- Contenedor de la notif
    local card = Instance.new("Frame")
    card.Name                = "Notif"
    card.Size                = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize       = Enum.AutomaticSize.Y
    card.BackgroundColor3    = THEME.Surface
    card.ClipsDescendants    = true
    card.Position            = UDim2.new(1, 10, 0, 0)   -- empieza fuera
    card.Parent              = notifContainer
    applyCorner(card, CORNER_MD)
    applyStroke(card, THEME.Border)

    -- Barra de acento lateral
    local accent = Instance.new("Frame")
    accent.Size             = UDim2.new(0, 3, 1, 0)
    accent.Position         = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3 = iconColor
    accent.BorderSizePixel  = 0
    accent.Parent           = card
    applyCorner(accent, 2)

    local inner = Instance.new("Frame")
    inner.Size                = UDim2.new(1, -3, 0, 0)
    inner.Position            = UDim2.new(0, 3, 0, 0)
    inner.AutomaticSize       = Enum.AutomaticSize.Y
    inner.BackgroundTransparency = 1
    inner.Parent              = card
    applyPadding(inner, 8, 10, 8, 10)
    applyListLayout(inner, Enum.FillDirection.Vertical, 3)

    newLabel(inner, title, 13, THEME.TextPrimary, FONT_BOLD)
    if desc ~= "" then
        newLabel(inner, desc, 12, THEME.TextSecondary, FONT)
    end

    -- Barra de progreso
    local progressBg = Instance.new("Frame")
    progressBg.Size              = UDim2.new(1, -3, 0, 2)
    progressBg.Position          = UDim2.new(0, 3, 1, -2)
    progressBg.BackgroundColor3  = THEME.Border
    progressBg.BorderSizePixel   = 0
    progressBg.ZIndex            = 5
    progressBg.Parent            = card

    local progressBar = Instance.new("Frame")
    progressBar.Size             = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = iconColor
    progressBar.BorderSizePixel  = 0
    progressBar.Parent           = progressBg
    applyCorner(progressBar, 1)

    -- Animación de entrada
    tween(card, { Position = UDim2.new(0, 0, 0, 0) })

    -- Progreso
    tween(progressBar, { Size = UDim2.new(0, 0, 1, 0) })
    TweenService:Create(progressBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear), {}):Play()

    -- Salida
    task.delay(duration, function()
        tween(card, { Position = UDim2.new(1, 10, 0, 0) })
        task.delay(0.2, function()
            card:Destroy()
        end)
    end)
end

-- ─── Window ───────────────────────────────────────────────────
local Window = {}
Window.__index = Window

function NexusGui:CreateWindow(options)
    options = options or {}
    local title  = options.Title  or "NexusGui"
    local size   = options.Size   or UDim2.new(0, 640, 0, 420)
    local pos    = options.Position or UDim2.new(0.5, -320, 0.5, -210)

    -- ScreenGui raíz
    local sg = Instance.new("ScreenGui")
    sg.Name           = "NexusGui_" .. title
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent         = PlayerGui

    -- Sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Size              = UDim2.new(0, size.X.Offset + 30, 0, size.Y.Offset + 30)
    shadow.Position          = UDim2.new(pos.X.Scale, pos.X.Offset - 15, pos.Y.Scale, pos.Y.Offset - 15)
    shadow.BackgroundTransparency = 1
    shadow.Image             = "rbxassetid://6014261993"
    shadow.ImageColor3       = THEME.Shadow
    shadow.ImageTransparency = 0.4
    shadow.ScaleType         = Enum.ScaleType.Slice
    shadow.SliceCenter       = Rect.new(49, 49, 450, 450)
    shadow.ZIndex            = 0
    shadow.Parent            = sg

    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name              = "MainFrame"
    mainFrame.Size              = size
    mainFrame.Position          = pos
    mainFrame.BackgroundColor3  = THEME.Background
    mainFrame.ClipsDescendants  = false
    mainFrame.ZIndex            = 1
    mainFrame.Parent            = sg
    applyCorner(mainFrame, CORNER_MD)
    applyStroke(mainFrame, THEME.Border)

    -- Sincronizar sombra con movimiento
    mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        local p = mainFrame.Position
        shadow.Position = UDim2.new(p.X.Scale, p.X.Offset - 15, p.Y.Scale, p.Y.Offset - 15)
    end)

    -- ── Topbar ──────────────────────────────────────────────
    local topbar = Instance.new("Frame")
    topbar.Name             = "Topbar"
    topbar.Size             = UDim2.new(1, 0, 0, 36)
    topbar.BackgroundColor3 = THEME.Surface
    topbar.ZIndex           = 2
    topbar.Parent           = mainFrame
    applyCorner(topbar, CORNER_MD)

    -- Parche para esquinas inferiores del topbar
    local topbarPatch = Instance.new("Frame")
    topbarPatch.Size              = UDim2.new(1, 0, 0, CORNER_MD)
    topbarPatch.Position          = UDim2.new(0, 0, 1, -CORNER_MD)
    topbarPatch.BackgroundColor3  = THEME.Surface
    topbarPatch.BorderSizePixel   = 0
    topbarPatch.ZIndex            = 2
    topbarPatch.Parent            = topbar

    -- Logo/acento
    local accentBar = Instance.new("Frame")
    accentBar.Size             = UDim2.new(0, 3, 0, 20)
    accentBar.Position         = UDim2.new(0, 10, 0.5, -10)
    accentBar.BackgroundColor3 = THEME.Accent
    accentBar.BorderSizePixel  = 0
    accentBar.ZIndex           = 3
    accentBar.Parent           = topbar
    applyCorner(accentBar, 2)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text               = title
    titleLabel.Font               = FONT_BOLD
    titleLabel.TextSize           = 14
    titleLabel.TextColor3         = THEME.TextPrimary
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position           = UDim2.new(0, 22, 0, 0)
    titleLabel.Size               = UDim2.new(1, -80, 1, 0)
    titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
    titleLabel.ZIndex             = 3
    titleLabel.Parent             = topbar

    -- Botones de control
    local ctrlFrame = Instance.new("Frame")
    ctrlFrame.Size                = UDim2.new(0, 60, 1, 0)
    ctrlFrame.Position            = UDim2.new(1, -68, 0, 0)
    ctrlFrame.BackgroundTransparency = 1
    ctrlFrame.ZIndex              = 3
    ctrlFrame.Parent              = topbar
    applyListLayout(ctrlFrame, Enum.FillDirection.Horizontal, 4,
        Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)

    local function makeCtrlBtn(icon, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size               = UDim2.new(0, 24, 0, 24)
        btn.BackgroundColor3   = THEME.SurfaceAlt
        btn.Text               = icon
        btn.TextSize           = 12
        btn.Font               = FONT_BOLD
        btn.TextColor3         = color
        btn.ZIndex             = 4
        btn.AutoButtonColor    = false
        btn.Parent             = ctrlFrame
        applyCorner(btn, 4)
        btn.MouseButton1Click:Connect(callback)
        btn.MouseEnter:Connect(function()
            tween(btn, { BackgroundColor3 = color, TextColor3 = Color3.new(1,1,1) })
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, { BackgroundColor3 = THEME.SurfaceAlt, TextColor3 = color })
        end)
        return btn
    end

    local minimized = false
    local contentHolder  -- declarado después

    makeCtrlBtn("—", THEME.TextSecondary, function()
        minimized = not minimized
        if contentHolder then
            if minimized then
                tween(mainFrame, { Size = UDim2.new(0, size.X.Offset, 0, 36) })
            else
                tween(mainFrame, { Size = size })
            end
        end
    end)

    makeCtrlBtn("✕", THEME.Error, function()
        tween(mainFrame, { Size = UDim2.new(0, size.X.Offset, 0, 0) })
        task.delay(0.2, function() sg:Destroy() end)
    end)

    makeDraggable(mainFrame, topbar)

    -- ── Contenedor de Tabs ───────────────────────────────────
    local tabBar = Instance.new("Frame")
    tabBar.Name              = "TabBar"
    tabBar.Size              = UDim2.new(0, 130, 1, -36)
    tabBar.Position          = UDim2.new(0, 0, 0, 36)
    tabBar.BackgroundColor3  = THEME.Surface
    tabBar.ZIndex            = 2
    tabBar.Parent            = mainFrame

    -- Parche esquina superior derecha del tabBar
    local tabBarPatch = Instance.new("Frame")
    tabBarPatch.Size             = UDim2.new(0, CORNER_MD, 0, CORNER_MD)
    tabBarPatch.Position         = UDim2.new(1, -CORNER_MD, 0, 0)
    tabBarPatch.BackgroundColor3 = THEME.Surface
    tabBarPatch.BorderSizePixel  = 0
    tabBarPatch.ZIndex           = 2
    tabBarPatch.Parent           = tabBar

    local tabList = Instance.new("ScrollingFrame")
    tabList.Size               = UDim2.new(1, 0, 1, -8)
    tabList.Position           = UDim2.new(0, 0, 0, 8)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 2
    tabList.ScrollBarImageColor3 = THEME.Scrollbar
    tabList.CanvasSize         = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.ZIndex             = 3
    tabList.Parent             = tabBar
    applyPadding(tabList, 4, 6, 4, 6)
    applyListLayout(tabList, Enum.FillDirection.Vertical, 3)

    -- ── Área de contenido ────────────────────────────────────
    contentHolder = Instance.new("Frame")
    contentHolder.Name              = "ContentHolder"
    contentHolder.Size              = UDim2.new(1, -130, 1, -36)
    contentHolder.Position          = UDim2.new(0, 130, 0, 36)
    contentHolder.BackgroundTransparency = 1
    contentHolder.ClipsDescendants  = true
    contentHolder.ZIndex            = 2
    contentHolder.Parent            = mainFrame

    -- Separador vertical
    local divider = Instance.new("Frame")
    divider.Size             = UDim2.new(0, 1, 1, -36)
    divider.Position         = UDim2.new(0, 129, 0, 36)
    divider.BackgroundColor3 = THEME.Border
    divider.BorderSizePixel  = 0
    divider.ZIndex           = 3
    divider.Parent           = mainFrame

    local self = setmetatable({}, Window)
    self._sg           = sg
    self._mainFrame    = mainFrame
    self._tabList      = tabList
    self._contentHolder= contentHolder
    self._tabs         = {}
    self._activeTab    = nil
    self._library      = NexusGui

    return self
end

-- ─── Tab ──────────────────────────────────────────────────────
local Tab = {}
Tab.__index = Tab

function Window:AddTab(name, icon)
    -- Botón en la barra lateral
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size               = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3   = THEME.TabInactive
    tabBtn.Text               = (icon and icon .. "  " or "") .. name
    tabBtn.Font               = FONT
    tabBtn.TextSize           = 13
    tabBtn.TextColor3         = THEME.TextSecondary
    tabBtn.TextXAlignment     = Enum.TextXAlignment.Left
    tabBtn.AutoButtonColor    = false
    tabBtn.ZIndex             = 4
    tabBtn.Parent             = self._tabList
    applyCorner(tabBtn, CORNER_SM)
    applyPadding(tabBtn, 0, 0, 0, 10)

    -- Indicador activo
    local activeIndicator = Instance.new("Frame")
    activeIndicator.Size             = UDim2.new(0, 3, 0, 18)
    activeIndicator.Position         = UDim2.new(0, 0, 0.5, -9)
    activeIndicator.BackgroundColor3 = THEME.Accent
    activeIndicator.BorderSizePixel  = 0
    activeIndicator.Transparency     = 1
    activeIndicator.ZIndex           = 5
    activeIndicator.Parent           = tabBtn
    applyCorner(activeIndicator, 2)

    -- Página de contenido
    local page = Instance.new("ScrollingFrame")
    page.Name                  = name
    page.Size                  = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency= 1
    page.ScrollBarThickness    = 3
    page.ScrollBarImageColor3  = THEME.Scrollbar
    page.CanvasSize            = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    page.Visible               = false
    page.ZIndex                = 3
    page.Parent                = self._contentHolder
    applyPadding(page, 10, 10, 10, 10)
    applyListLayout(page, Enum.FillDirection.Vertical, 8)

    local t = setmetatable({}, Tab)
    t._window    = self
    t._page      = page
    t._tabBtn    = tabBtn
    t._indicator = activeIndicator
    t._name      = name

    tabBtn.MouseButton1Click:Connect(function()
        self:_setActiveTab(t)
    end)

    tabBtn.MouseEnter:Connect(function()
        if self._activeTab ~= t then
            tween(tabBtn, { BackgroundColor3 = THEME.SurfaceAlt })
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self._activeTab ~= t then
            tween(tabBtn, { BackgroundColor3 = THEME.TabInactive })
        end
    end)

    table.insert(self._tabs, t)

    -- Auto-seleccionar primer tab
    if #self._tabs == 1 then
        self:_setActiveTab(t)
    end

    return t
end

function Window:_setActiveTab(tab)
    -- Desactivar anterior
    if self._activeTab then
        local prev = self._activeTab
        prev._page.Visible = false
        tween(prev._tabBtn, { BackgroundColor3 = THEME.TabInactive, TextColor3 = THEME.TextSecondary })
        tween(prev._indicator, { Transparency = 1 })
    end
    -- Activar nuevo
    tab._page.Visible = true
    tween(tab._tabBtn, { BackgroundColor3 = THEME.SurfaceAlt, TextColor3 = THEME.TextPrimary })
    tween(tab._indicator, { Transparency = 0 })
    self._activeTab = tab
end

-- ─── Section / Groupbox ───────────────────────────────────────
local Section = {}
Section.__index = Section

function Tab:AddSection(title)
    local container = Instance.new("Frame")
    container.Name              = title
    container.Size              = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize     = Enum.AutomaticSize.Y
    container.BackgroundColor3  = THEME.Surface
    container.ZIndex            = 4
    container.Parent            = self._page
    applyCorner(container, CORNER_MD)
    applyStroke(container, THEME.Border)

    -- Header
    local header = Instance.new("Frame")
    header.Size              = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3  = THEME.SurfaceAlt
    header.ZIndex            = 5
    header.Parent            = container
    applyCorner(header, CORNER_MD)

    local headerPatch = Instance.new("Frame")
    headerPatch.Size             = UDim2.new(1, 0, 0, CORNER_MD)
    headerPatch.Position         = UDim2.new(0, 0, 1, -CORNER_MD)
    headerPatch.BackgroundColor3 = THEME.SurfaceAlt
    headerPatch.BorderSizePixel  = 0
    headerPatch.ZIndex           = 5
    headerPatch.Parent           = header

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text              = title
    titleLbl.Font              = FONT_BOLD
    titleLbl.TextSize          = 12
    titleLbl.TextColor3        = THEME.TextSecondary
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size              = UDim2.new(1, -16, 1, 0)
    titleLbl.Position          = UDim2.new(0, 10, 0, 0)
    titleLbl.TextXAlignment    = Enum.TextXAlignment.Left
    titleLbl.TextTransparency  = 0
    titleLbl.ZIndex            = 6
    titleLbl.Parent            = header

    -- Línea separadora
    local sep = Instance.new("Frame")
    sep.Size             = UDim2.new(1, -20, 0, 1)
    sep.Position         = UDim2.new(0, 10, 0, 30)
    sep.BackgroundColor3 = THEME.Border
    sep.BorderSizePixel  = 0
    sep.ZIndex           = 5
    sep.Parent           = container

    -- Área de items
    local itemArea = Instance.new("Frame")
    itemArea.Name             = "Items"
    itemArea.Size             = UDim2.new(1, 0, 0, 0)
    itemArea.Position         = UDim2.new(0, 0, 0, 32)
    itemArea.AutomaticSize    = Enum.AutomaticSize.Y
    itemArea.BackgroundTransparency = 1
    itemArea.ZIndex           = 5
    itemArea.Parent           = container
    applyPadding(itemArea, 6, 10, 8, 10)
    local layout = applyListLayout(itemArea, Enum.FillDirection.Vertical, 5)
    autoSize(container, layout)

    local s = setmetatable({}, Section)
    s._area   = itemArea
    s._window = self._window

    return s
end

-- Alias
Tab.AddGroupbox = Tab.AddSection

-- ─── Componentes ──────────────────────────────────────────────

-- Label
function Section:AddLabel(text)
    local lbl = newLabel(self._area, text, 12, THEME.TextSecondary, FONT)
    lbl.ZIndex = 6
    -- Método para actualizar
    return {
        SetText = function(_, t)
            lbl.Text = tostring(t)
        end,
        GetText = function(_)
            return lbl.Text
        end,
        _instance = lbl
    }
end

-- Button
function Section:AddButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3  = THEME.Accent
    btn.Text              = text
    btn.Font              = FONT_BOLD
    btn.TextSize          = 13
    btn.TextColor3        = Color3.new(1, 1, 1)
    btn.AutoButtonColor   = false
    btn.ZIndex            = 6
    btn.Parent            = self._area
    applyCorner(btn, CORNER_SM)

    btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundColor3 = THEME.AccentHover })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundColor3 = THEME.Accent })
    end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, { BackgroundColor3 = THEME.AccentPress })
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, { BackgroundColor3 = THEME.AccentHover })
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return {
        SetText = function(_, t) btn.Text = t end,
        _instance = btn
    }
end

-- Toggle
function Section:AddToggle(text, default, callback)
    local val = default or false

    local row = Instance.new("Frame")
    row.Size              = UDim2.new(1, 0, 0, 28)
    row.BackgroundTransparency = 1
    row.ZIndex            = 6
    row.Parent            = self._area

    local lbl = newLabel(row, text, 13, THEME.TextPrimary, FONT)
    lbl.Size     = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.ZIndex   = 7

    local trackBg = Instance.new("Frame")
    trackBg.Size             = UDim2.new(0, 40, 0, 20)
    trackBg.Position         = UDim2.new(1, -42, 0.5, -10)
    trackBg.BackgroundColor3 = val and THEME.Accent or THEME.Border
    trackBg.ZIndex           = 7
    trackBg.Parent           = row
    applyCorner(trackBg, 10)

    local thumb = Instance.new("Frame")
    thumb.Size             = UDim2.new(0, 14, 0, 14)
    thumb.Position         = val and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    thumb.ZIndex           = 8
    thumb.Parent           = trackBg
    applyCorner(thumb, 7)

    local clickArea = Instance.new("TextButton")
    clickArea.Size   = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text   = ""
    clickArea.ZIndex = 8
    clickArea.Parent = row

    clickArea.MouseButton1Click:Connect(function()
        val = not val
        tween(trackBg, { BackgroundColor3 = val and THEME.Accent or THEME.Border })
        tween(thumb, { Position = val and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
        if callback then callback(val) end
    end)

    return {
        SetValue = function(_, v)
            val = v
            tween(trackBg, { BackgroundColor3 = val and THEME.Accent or THEME.Border })
            tween(thumb, { Position = val and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
        end,
        GetValue = function(_) return val end,
    }
end

-- Input
function Section:AddInput(text, placeholder, callback, isMultiLine)
    local wrapper = Instance.new("Frame")
    wrapper.Size              = UDim2.new(1, 0, 0, 0)
    wrapper.AutomaticSize     = Enum.AutomaticSize.Y
    wrapper.BackgroundTransparency = 1
    wrapper.ZIndex            = 6
    wrapper.Parent            = self._area
    applyListLayout(wrapper, Enum.FillDirection.Vertical, 3)

    if text and text ~= "" then
        newLabel(wrapper, text, 11, THEME.TextMuted, FONT):GetPropertyChangedSignal("Parent")
    end

    local inputFrame = Instance.new("Frame")
    inputFrame.Size             = UDim2.new(1, 0, 0, isMultiLine and 70 or 30)
    inputFrame.BackgroundColor3 = THEME.InputBg
    inputFrame.ZIndex           = 7
    inputFrame.Parent           = wrapper
    applyCorner(inputFrame, CORNER_SM)
    applyStroke(inputFrame, THEME.Border)

    local box = Instance.new("TextBox")
    box.Size                 = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.Font                 = FONT_MONO
    box.TextSize             = 12
    box.TextColor3           = THEME.TextPrimary
    box.PlaceholderText      = placeholder or ""
    box.PlaceholderColor3    = THEME.TextMuted
    box.Text                 = ""
    box.TextXAlignment       = Enum.TextXAlignment.Left
    box.TextYAlignment       = Enum.TextYAlignment.Top
    box.MultiLine            = isMultiLine or false
    box.TextWrapped          = isMultiLine or false
    box.ClearTextOnFocus     = false
    box.ZIndex               = 8
    box.Parent               = inputFrame
    applyPadding(box, 4, 8, 4, 8)

    -- Focus highlight
    box.Focused:Connect(function()
        tween(inputFrame, { BackgroundColor3 = THEME.SurfaceAlt })
    end)
    box.FocusLost:Connect(function(enter)
        tween(inputFrame, { BackgroundColor3 = THEME.InputBg })
        if callback then callback(box.Text, enter) end
    end)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        if callback then callback(box.Text, false) end
    end)

    return {
        GetText  = function(_) return box.Text end,
        SetText  = function(_, t) box.Text = tostring(t) end,
        _instance = box,
    }
end

-- Dropdown
function Section:AddDropdown(text, options, default, callback)
    local selected = default or (options and options[1]) or ""
    local isOpen   = false

    local wrapper = Instance.new("Frame")
    wrapper.Size             = UDim2.new(1, 0, 0, 0)
    wrapper.AutomaticSize    = Enum.AutomaticSize.Y
    wrapper.BackgroundTransparency = 1
    wrapper.ZIndex           = 6
    wrapper.Parent           = self._area
    applyListLayout(wrapper, Enum.FillDirection.Vertical, 3)

    if text and text ~= "" then
        newLabel(wrapper, text, 11, THEME.TextMuted, FONT)
    end

    local btnFrame = Instance.new("TextButton")
    btnFrame.Size              = UDim2.new(1, 0, 0, 30)
    btnFrame.BackgroundColor3  = THEME.SurfaceAlt
    btnFrame.Text              = ""
    btnFrame.AutoButtonColor   = false
    btnFrame.ZIndex            = 7
    btnFrame.Parent            = wrapper
    applyCorner(btnFrame, CORNER_SM)
    applyStroke(btnFrame, THEME.Border)

    local selLabel = newLabel(btnFrame, selected, 12, THEME.TextPrimary, FONT)
    selLabel.Size     = UDim2.new(1, -30, 1, 0)
    selLabel.Position = UDim2.new(0, 8, 0, 0)
    selLabel.ZIndex   = 8

    local arrow = newLabel(btnFrame, "▾", 12, THEME.TextSecondary, FONT_BOLD, Enum.TextXAlignment.Center)
    arrow.Size     = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.ZIndex   = 8

    -- Menú desplegable
    local menu = Instance.new("Frame")
    menu.Size              = UDim2.new(1, 0, 0, 0)
    menu.BackgroundColor3  = THEME.Surface
    menu.ZIndex            = 20
    menu.Visible           = false
    menu.ClipsDescendants  = true
    menu.Parent            = wrapper
    applyCorner(menu, CORNER_SM)
    applyStroke(menu, THEME.Accent)

    local menuScroll = Instance.new("ScrollingFrame")
    menuScroll.Size               = UDim2.new(1, 0, 1, 0)
    menuScroll.BackgroundTransparency = 1
    menuScroll.ScrollBarThickness = 2
    menuScroll.ScrollBarImageColor3 = THEME.Scrollbar
    menuScroll.CanvasSize         = UDim2.new(0, 0, 0, 0)
    menuScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    menuScroll.ZIndex             = 21
    menuScroll.Parent             = menu
    applyPadding(menuScroll, 3, 4, 3, 4)
    applyListLayout(menuScroll, Enum.FillDirection.Vertical, 2)

    local function closeMenu()
        isOpen = false
        tween(menu, { Size = UDim2.new(1, 0, 0, 0) })
        task.delay(0.15, function()
            menu.Visible = false
        end)
        tween(arrow, { Rotation = 0 })
    end

    local function openMenu()
        isOpen = true
        menu.Visible = true
        local itemH = math.min(#options * 28 + 6, 120)
        tween(menu, { Size = UDim2.new(1, 0, 0, itemH) })
        tween(arrow, { Rotation = 180 })
    end

    local function buildMenu()
        for _, child in ipairs(menuScroll:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        for _, opt in ipairs(options or {}) do
            local item = Instance.new("TextButton")
            item.Size              = UDim2.new(1, 0, 0, 26)
            item.BackgroundColor3  = opt == selected and THEME.Accent or THEME.SurfaceAlt
            item.Text              = tostring(opt)
            item.Font              = FONT
            item.TextSize          = 12
            item.TextColor3        = opt == selected and Color3.new(1,1,1) or THEME.TextPrimary
            item.TextXAlignment    = Enum.TextXAlignment.Left
            item.AutoButtonColor   = false
            item.ZIndex            = 22
            item.Parent            = menuScroll
            applyCorner(item, 4)
            applyPadding(item, 0, 0, 0, 8)

            item.MouseEnter:Connect(function()
                if opt ~= selected then
                    tween(item, { BackgroundColor3 = THEME.SurfaceAlt })
                end
            end)
            item.MouseLeave:Connect(function()
                if opt ~= selected then
                    tween(item, { BackgroundColor3 = Color3.fromRGB(28, 28, 38) })
                end
            end)
            item.MouseButton1Click:Connect(function()
                selected = opt
                selLabel.Text = tostring(opt)
                closeMenu()
                buildMenu()
                if callback then callback(opt) end
            end)
        end
    end

    buildMenu()
    btnFrame.MouseButton1Click:Connect(function()
        if isOpen then closeMenu() else openMenu() end
    end)

    return {
        GetValue = function(_) return selected end,
        SetValue = function(_, v)
            selected = v
            selLabel.Text = tostring(v)
            buildMenu()
        end,
        SetOptions = function(_, opts)
            options = opts
            buildMenu()
        end,
    }
end

-- Separator
function Section:AddSeparator()
    local sep = Instance.new("Frame")
    sep.Size             = UDim2.new(1, 0, 0, 1)
    sep.BackgroundColor3 = THEME.Border
    sep.BorderSizePixel  = 0
    sep.ZIndex           = 6
    sep.Parent           = self._area
end

-- Spacer
function Section:AddSpace(height)
    local sp = Instance.new("Frame")
    sp.Size                = UDim2.new(1, 0, 0, height or 4)
    sp.BackgroundTransparency = 1
    sp.ZIndex              = 6
    sp.Parent              = self._area
end

-- ─── Exports ──────────────────────────────────────────────────
NexusGui.THEME   = THEME
NexusGui._Window = Window
NexusGui._Tab    = Tab
NexusGui._Section = Section

return NexusGui
