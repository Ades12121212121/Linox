-- ================================================================
--  NexusGui Framework v2.0  •  Glassmorphism Edition
--  Diseño: Transparente · Gradient · Minimalista · Moderno
--  Sube este archivo a GitHub como: NexusGuiFramework.lua
-- ================================================================

local NexusGui   = {}
NexusGui.__index = NexusGui

-- ── Servicios ────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ── Paleta Glassmorphism ──────────────────────────────────────────
local T = {
    -- Bases
    BgDeep        = Color3.fromRGB(8,   8,   12),
    BgBase        = Color3.fromRGB(14,  14,  20),
    BgSurface     = Color3.fromRGB(20,  20,  30),
    BgCard        = Color3.fromRGB(26,  26,  38),
    BgCardHover   = Color3.fromRGB(32,  32,  46),
    BgInput       = Color3.fromRGB(12,  12,  18),

    -- Glass
    Glass         = Color3.fromRGB(255, 255, 255),  -- con transparencia alta
    GlassEdge     = Color3.fromRGB(200, 200, 220),

    -- Acentos
    Accent        = Color3.fromRGB(110, 90,  240),
    AccentSoft    = Color3.fromRGB(130, 110, 255),
    AccentDim     = Color3.fromRGB(70,  55,  160),
    AccentGlow    = Color3.fromRGB(90,  70,  200),

    -- Cyan secondary
    Cyan          = Color3.fromRGB(60,  200, 220),
    CyanDim       = Color3.fromRGB(40,  140, 160),

    -- Texto
    TextHigh      = Color3.fromRGB(240, 240, 250),
    TextMid       = Color3.fromRGB(160, 160, 185),
    TextLow       = Color3.fromRGB(90,  90,  115),
    TextCode      = Color3.fromRGB(140, 220, 180),

    -- Bordes
    BorderFaint   = Color3.fromRGB(40,  40,  58),
    BorderMid     = Color3.fromRGB(60,  60,  85),
    BorderGlass   = Color3.fromRGB(120, 120, 160),

    -- Semaforo
    Green         = Color3.fromRGB(80,  210, 130),
    Yellow        = Color3.fromRGB(240, 190, 60),
    Red           = Color3.fromRGB(220, 75,  75),
    Blue          = Color3.fromRGB(60,  160, 240),

    -- Gradientes (ColorSequence)
    GradAccent    = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(110, 90,  240)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(60,  180, 220)),
    }),
    GradTopbar    = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(22,  22,  34)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(16,  16,  26)),
    }),
    GradCard      = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(28,  28,  42)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(18,  18,  28)),
    }),
    GradScan      = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(110, 90,  240)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60,  170, 220)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(80,  210, 130)),
    }),
}

-- ── Constantes ────────────────────────────────────────────────────
local CR_XS   = 4
local CR_SM   = 6
local CR_MD   = 10
local CR_LG   = 14
local CR_FULL = 100

local TW_FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TW_MED  = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TW_SLOW = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local FONT      = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold
local FONT_MONO = Enum.Font.Code
local FONT_SEMI = Enum.Font.Gotham

-- ── Helpers ───────────────────────────────────────────────────────
local function tw(obj, props, info)
    TweenService:Create(obj, info or TW_MED, props):Play()
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or CR_MD)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thick, trans)
    local s       = Instance.new("UIStroke")
    s.Color       = color or T.BorderMid
    s.Thickness   = thick or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent      = parent
    return s
end

local function gradient(parent, seq, rot)
    local g  = Instance.new("UIGradient")
    g.Color  = seq or T.GradCard
    g.Rotation = rot or 135
    g.Parent = parent
    return g
end

local function padding(parent, t, r, b, l)
    local p         = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 6)
    p.PaddingRight  = UDim.new(0, r or 8)
    p.PaddingBottom = UDim.new(0, b or 6)
    p.PaddingLeft   = UDim.new(0, l or 8)
    p.Parent        = parent
    return p
end

local function listLayout(parent, dir, space, ha, va)
    local l               = Instance.new("UIListLayout")
    l.FillDirection       = dir   or Enum.FillDirection.Vertical
    l.Padding             = UDim.new(0, space or 4)
    l.HorizontalAlignment = ha    or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = va    or Enum.VerticalAlignment.Top
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent              = parent
    return l
end

local function autoCanvas(scroll, layout)
    layout.Changed:Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end)
end

local function draggable(frame, handle)
    handle = handle or frame
    local drag, di, mp, fp = false, nil, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; mp = i.Position; fp = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == di and drag then
            local d = i.Position - mp
            frame.Position = UDim2.new(fp.X.Scale, fp.X.Offset + d.X, fp.Y.Scale, fp.Y.Offset + d.Y)
        end
    end)
end

local function makeFrame(parent, size, pos, bg, trans, zindex)
    local f                      = Instance.new("Frame")
    f.Size                       = size or UDim2.new(1, 0, 0, 30)
    f.Position                   = pos  or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3           = bg   or T.BgCard
    f.BackgroundTransparency     = trans or 0
    f.BorderSizePixel            = 0
    f.ZIndex                     = zindex or 1
    f.Parent                     = parent
    return f
end

local function makeLabel(parent, text, size, color, font, xa, zi)
    local l                      = Instance.new("TextLabel")
    l.Text                       = text  or ""
    l.TextSize                   = size  or 13
    l.TextColor3                 = color or T.TextHigh
    l.Font                       = font  or FONT
    l.BackgroundTransparency     = 1
    l.TextXAlignment             = xa    or Enum.TextXAlignment.Left
    l.TextYAlignment             = Enum.TextYAlignment.Center
    l.AutomaticSize              = Enum.AutomaticSize.Y
    l.Size                       = UDim2.new(1, 0, 0, 14)
    l.TextWrapped                = true
    l.ZIndex                     = zi   or 4
    l.Parent                     = parent
    return l
end

-- ── NOTIFICACIONES ────────────────────────────────────────────────
local notifSG, notifHolder

local function ensureNotifs()
    if notifHolder and notifHolder.Parent then return end
    notifSG             = Instance.new("ScreenGui")
    notifSG.Name        = "NexusNotifs"
    notifSG.ResetOnSpawn = false
    notifSG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifSG.DisplayOrder = 999
    notifSG.Parent      = PlayerGui

    notifHolder         = Instance.new("Frame")
    notifHolder.Name    = "Holder"
    notifHolder.Size    = UDim2.new(0, 320, 1, -20)
    notifHolder.Position = UDim2.new(1, -330, 0, 10)
    notifHolder.BackgroundTransparency = 1
    notifHolder.Parent  = notifSG

    local ll = listLayout(notifHolder, Enum.FillDirection.Vertical, 6,
        Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = notifHolder
end

function NexusGui:Notify(opts)
    ensureNotifs()
    opts = opts or {}
    local title    = opts.Title    or "Notificación"
    local desc     = opts.Desc     or ""
    local duration = opts.Duration or 3
    local ntype    = opts.Type     or "info"

    local accentCol = T.Accent
    if ntype == "success" then accentCol = T.Green
    elseif ntype == "warning" then accentCol = T.Yellow
    elseif ntype == "error"   then accentCol = T.Red
    elseif ntype == "info"    then accentCol = T.Cyan
    end

    -- Card
    local card = makeFrame(notifHolder, UDim2.new(1, 0, 0, 0), UDim2.new(1, 10, 0, 0),
        T.BgCard, 0)
    card.AutomaticSize     = Enum.AutomaticSize.Y
    card.ClipsDescendants  = true
    card.ZIndex            = 100
    corner(card, CR_MD)

    -- Fondo glass gradient
    local gCard = makeFrame(card, UDim2.new(1, 0, 1, 0), nil, T.BgSurface, 0, 101)
    gradient(gCard, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 46)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28)),
    }), 135)

    stroke(card, T.BorderGlass, 1, 0.6)

    -- Barra superior accent
    local topBar = makeFrame(card, UDim2.new(1, 0, 0, 2), nil, accentCol, 0, 102)
    gradient(topBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentCol),
        ColorSequenceKeypoint.new(1, T.Cyan),
    }), 90)

    -- Barra lateral
    local sideBar = makeFrame(card, UDim2.new(0, 3, 1, 0), nil, accentCol, 0, 102)
    gradient(sideBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentCol),
        ColorSequenceKeypoint.new(1, T.BgCard),
    }), 90)
    corner(sideBar, 2)

    -- Contenido
    local inner = makeFrame(card, UDim2.new(1, -16, 0, 0), UDim2.new(0, 14, 0, 4),
        T.BgCard, 1, 103)
    inner.AutomaticSize = Enum.AutomaticSize.Y
    listLayout(inner, Enum.FillDirection.Vertical, 2)

    local tLbl = makeLabel(inner, title, 13, T.TextHigh, FONT_BOLD, nil, 104)
    tLbl.Size  = UDim2.new(1, 0, 0, 18)

    if desc ~= "" then
        local dLbl = makeLabel(inner, desc, 11, T.TextMid, FONT_SEMI, nil, 104)
        dLbl.Size  = UDim2.new(1, 0, 0, 0)
        dLbl.AutomaticSize = Enum.AutomaticSize.Y
    end

    -- Progress bar
    local pbBg = makeFrame(card, UDim2.new(1, -16, 0, 2),
        UDim2.new(0, 14, 1, -6), T.BorderFaint, 0, 103)
    corner(pbBg, 2)

    local pb   = makeFrame(pbBg, UDim2.new(1, 0, 1, 0), nil, accentCol, 0, 104)
    corner(pb, 2)
    gradient(pb, ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentCol),
        ColorSequenceKeypoint.new(1, T.Cyan),
    }), 90)

    -- Animación de entrada
    tw(card, { Position = UDim2.new(0, 0, 0, 0) }, TW_MED)

    TweenService:Create(pb, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    task.delay(duration, function()
        tw(card, { Position = UDim2.new(1, 10, 0, 0) }, TW_MED)
        task.delay(0.25, function() card:Destroy() end)
    end)
end

-- ════════════════════════════════════════════════════════════
--  WINDOW
-- ════════════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

function NexusGui:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title    or "NexusGui"
    local W     = opts.Width    or 740
    local H     = opts.Height   or 490
    local tabW  = opts.TabWidth or 140

    local sg            = Instance.new("ScreenGui")
    sg.Name             = "NexusGui_" .. title:gsub("%s","_")
    sg.ResetOnSpawn     = false
    sg.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder     = 100
    sg.Parent           = PlayerGui

    -- ── Contenedor raíz ─────────────────────────────────────
    local root          = makeFrame(sg,
        UDim2.new(0, W, 0, H),
        UDim2.new(0.5, -W/2, 0.5, -H/2),
        T.BgDeep, 0, 1)
    root.ClipsDescendants = false
    corner(root, CR_LG)

    -- Sombra exterior
    local shadow        = Instance.new("ImageLabel")
    shadow.Size         = UDim2.new(1, 60, 1, 60)
    shadow.Position     = UDim2.new(0, -30, 0, -30)
    shadow.BackgroundTransparency = 1
    shadow.Image        = "rbxassetid://6014261993"
    shadow.ImageColor3  = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.45
    shadow.ScaleType    = Enum.ScaleType.Slice
    shadow.SliceCenter  = Rect.new(49, 49, 450, 450)
    shadow.ZIndex       = 0
    shadow.Parent       = root

    -- Fondo base con gradiente diagonal
    local bgGrad        = makeFrame(root, UDim2.new(1, 0, 1, 0), nil, T.BgBase, 0, 1)
    gradient(bgGrad, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(16, 14, 24)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 18)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 10, 16)),
    }), 145)
    corner(bgGrad, CR_LG)

    -- Borde exterior glass
    stroke(root, T.BorderGlass, 1, 0.65)

    -- Línea accent superior
    local accentTop     = makeFrame(root, UDim2.new(0.6, 0, 0, 1),
        UDim2.new(0.2, 0, 0, 0), T.Accent, 0, 5)
    gradient(accentTop, T.GradAccent, 90)
    corner(accentTop, 1)

    -- ── TOPBAR ──────────────────────────────────────────────
    local topbar        = makeFrame(root, UDim2.new(1, 0, 0, 40), nil, T.BgSurface, 0, 3)
    corner(topbar, CR_LG)
    gradient(topbar, T.GradTopbar, 135)

    -- Parche inferior del topbar
    local tPatch        = makeFrame(topbar, UDim2.new(1, 0, 0, CR_LG),
        UDim2.new(0, 0, 1, -CR_LG), T.BgSurface, 0, 3)
    gradient(tPatch, T.GradTopbar, 135)

    -- Punto de acento pulsante
    local dot           = makeFrame(topbar, UDim2.new(0, 7, 0, 7),
        UDim2.new(0, 14, 0.5, -3), T.Accent, 0, 5)
    corner(dot, CR_FULL)
    gradient(dot, T.GradAccent, 135)

    -- Pulso del punto
    local pulsing = true
    task.spawn(function()
        while pulsing do
            tw(dot, { BackgroundTransparency = 0.3 }, TW_SLOW)
            task.wait(0.7)
            tw(dot, { BackgroundTransparency = 0 }, TW_SLOW)
            task.wait(0.7)
        end
    end)

    -- Título
    local titleLbl      = makeLabel(topbar, title, 13, T.TextHigh, FONT_BOLD,
        Enum.TextXAlignment.Left, 5)
    titleLbl.Size       = UDim2.new(1, -100, 1, 0)
    titleLbl.Position   = UDim2.new(0, 28, 0, 0)

    -- Sub-línea
    local subLbl        = makeLabel(topbar, "Remote Scanner & Debugger  •  v2.0",
        10, T.TextLow, FONT_SEMI, Enum.TextXAlignment.Left, 5)
    subLbl.Size         = UDim2.new(1, -100, 0, 14)
    subLbl.Position     = UDim2.new(0, 28, 1, -14)

    -- Separador topbar
    local topSep        = makeFrame(root, UDim2.new(1, -20, 0, 1),
        UDim2.new(0, 10, 0, 40), T.BorderFaint, 0, 4)
    gradient(topSep, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   T.BorderFaint),
        ColorSequenceKeypoint.new(0.5, T.BorderMid),
        ColorSequenceKeypoint.new(1,   T.BorderFaint),
    }), 90)

    -- ── Botones ctrl ────────────────────────────────────────
    local ctrlRow       = makeFrame(topbar, UDim2.new(0, 70, 0, 26),
        UDim2.new(1, -76, 0.5, -13), T.BgCard, 1, 5)
    listLayout(ctrlRow, Enum.FillDirection.Horizontal, 4,
        Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)

    local minimized = false
    local function ctrlBtn(icon, hoverCol, cb)
        local b             = Instance.new("TextButton")
        b.Size              = UDim2.new(0, 26, 0, 26)
        b.BackgroundColor3  = T.BgCard
        b.BackgroundTransparency = 0.3
        b.Text              = icon
        b.TextSize          = 11
        b.Font              = FONT_BOLD
        b.TextColor3        = T.TextMid
        b.AutoButtonColor   = false
        b.ZIndex            = 6
        b.Parent            = ctrlRow
        corner(b, CR_SM)
        stroke(b, T.BorderFaint, 1, 0.3)
        b.MouseEnter:Connect(function()
            tw(b, { BackgroundColor3 = hoverCol, BackgroundTransparency = 0, TextColor3 = Color3.new(1,1,1) })
        end)
        b.MouseLeave:Connect(function()
            tw(b, { BackgroundColor3 = T.BgCard, BackgroundTransparency = 0.3, TextColor3 = T.TextMid })
        end)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    local contentArea   -- referencia adelantada

    ctrlBtn("–", T.Yellow, function()
        minimized = not minimized
        if minimized then
            tw(root, { Size = UDim2.new(0, W, 0, 40) }, TW_MED)
        else
            tw(root, { Size = UDim2.new(0, W, 0, H) }, TW_MED)
        end
    end)

    ctrlBtn("✕", T.Red, function()
        pulsing = false
        tw(root, { BackgroundTransparency = 1, Size = UDim2.new(0, W, 0, 0) }, TW_MED)
        task.delay(0.3, function() sg:Destroy() end)
    end)

    draggable(root, topbar)

    -- ── SIDEBAR TABS ─────────────────────────────────────────
    local sidebar       = makeFrame(root,
        UDim2.new(0, tabW, 1, -42),
        UDim2.new(0, 0, 0, 42),
        T.BgSurface, 0, 3)
    gradient(sidebar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 22)),
    }), 180)

    -- Borde derecho del sidebar
    local sideDiv       = makeFrame(root, UDim2.new(0, 1, 1, -44),
        UDim2.new(0, tabW, 0, 43), T.BorderFaint, 0, 4)
    gradient(sideDiv, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   T.BorderMid),
        ColorSequenceKeypoint.new(0.5, T.BorderFaint),
        ColorSequenceKeypoint.new(1,   T.BorderFaint),
    }), 90)

    local tabScroll     = Instance.new("ScrollingFrame")
    tabScroll.Size      = UDim2.new(1, 0, 1, -12)
    tabScroll.Position  = UDim2.new(0, 0, 0, 8)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 0
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.ZIndex    = 4
    tabScroll.Parent    = sidebar
    padding(tabScroll, 4, 6, 4, 6)
    listLayout(tabScroll, Enum.FillDirection.Vertical, 3)

    -- ── CONTENT AREA ─────────────────────────────────────────
    contentArea         = makeFrame(root,
        UDim2.new(1, -(tabW + 2), 1, -44),
        UDim2.new(0, tabW + 2, 0, 42),
        T.BgBase, 1, 3)
    contentArea.ClipsDescendants = true

    -- ── Objeto Window ────────────────────────────────────────
    local self          = setmetatable({}, Window)
    self._sg            = sg
    self._root          = root
    self._tabScroll     = tabScroll
    self._contentArea   = contentArea
    self._tabs          = {}
    self._activeTab     = nil
    self._library       = NexusGui
    self._W, self._H    = W, H

    return self
end

-- ════════════════════════════════════════════════════════════
--  TAB
-- ════════════════════════════════════════════════════════════
local Tab = {}
Tab.__index = Tab

function Window:AddTab(name, icon)
    local isFirst = #self._tabs == 0

    -- Botón lateral
    local btn           = Instance.new("TextButton")
    btn.Size            = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = T.BgCard
    btn.BackgroundTransparency = 0.4
    btn.Text            = ""
    btn.AutoButtonColor = false
    btn.ZIndex          = 5
    btn.Parent          = self._tabScroll
    corner(btn, CR_SM)

    -- Indicador izquierdo
    local ind           = makeFrame(btn, UDim2.new(0, 2, 0, 16),
        UDim2.new(0, 0, 0.5, -8), T.Accent, 1, 6)
    corner(ind, 2)
    gradient(ind, T.GradAccent, 90)

    -- Texto del tab
    local tabIcon       = icon and (icon .. " ") or ""
    local tLbl          = makeLabel(btn, tabIcon .. name, 12, T.TextMid,
        FONT, Enum.TextXAlignment.Left, 6)
    tLbl.Size           = UDim2.new(1, -8, 1, 0)
    tLbl.Position       = UDim2.new(0, 12, 0, 0)

    -- Página de contenido
    local page          = Instance.new("ScrollingFrame")
    page.Size           = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = T.Accent
    page.ScrollBarImageTransparency = 0.5
    page.CanvasSize     = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible        = false
    page.ZIndex         = 4
    page.Parent         = self._contentArea
    padding(page, 12, 12, 12, 12)
    listLayout(page, Enum.FillDirection.Vertical, 8)

    local t             = setmetatable({}, Tab)
    t._win              = self
    t._page             = page
    t._btn              = btn
    t._ind              = ind
    t._lbl              = tLbl

    btn.MouseButton1Click:Connect(function() self:_activateTab(t) end)
    btn.MouseEnter:Connect(function()
        if self._activeTab ~= t then
            tw(btn, { BackgroundTransparency = 0.2 })
            tw(tLbl, { TextColor3 = T.TextHigh })
        end
    end)
    btn.MouseLeave:Connect(function()
        if self._activeTab ~= t then
            tw(btn, { BackgroundTransparency = 0.4 })
            tw(tLbl, { TextColor3 = T.TextMid })
        end
    end)

    table.insert(self._tabs, t)
    if isFirst then self:_activateTab(t) end
    return t
end

function Window:_activateTab(tab)
    if self._activeTab then
        local p = self._activeTab
        p._page.Visible = false
        tw(p._btn, { BackgroundColor3 = T.BgCard, BackgroundTransparency = 0.4 })
        tw(p._lbl, { TextColor3 = T.TextMid })
        tw(p._ind, { BackgroundTransparency = 1 })
    end
    tab._page.Visible = true
    tw(tab._btn, { BackgroundColor3 = T.BgCardHover, BackgroundTransparency = 0.1 })
    tw(tab._lbl, { TextColor3 = T.TextHigh })
    tw(tab._ind, { BackgroundTransparency = 0 })
    self._activeTab = tab
end

-- ════════════════════════════════════════════════════════════
--  SECTION (groupbox)
-- ════════════════════════════════════════════════════════════
local Section = {}
Section.__index = Section

function Tab:AddSection(title, opts)
    opts = opts or {}

    local wrap          = makeFrame(self._page,
        UDim2.new(1, 0, 0, 0), nil, T.BgCard, 0, 5)
    wrap.AutomaticSize  = Enum.AutomaticSize.Y
    corner(wrap, CR_MD)
    stroke(wrap, T.BorderFaint, 1, 0.3)
    gradient(wrap, T.GradCard, 145)

    -- Glass shimmer edge
    local shimmer       = makeFrame(wrap, UDim2.new(1, 0, 0, 1), nil, T.GlassEdge, 0.85, 6)
    corner(shimmer, CR_MD)

    -- Header
    local header        = makeFrame(wrap, UDim2.new(1, 0, 0, 28), nil, T.BgSurface, 0, 6)
    corner(header, CR_MD)
    gradient(header, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 26, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 32)),
    }), 135)

    local hPatch        = makeFrame(header, UDim2.new(1, 0, 0, CR_MD),
        UDim2.new(0, 0, 1, -CR_MD), T.BgSurface, 0, 6)
    gradient(hPatch, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 26, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 32)),
    }), 135)

    -- Dot acento header
    local hDot          = makeFrame(header, UDim2.new(0, 5, 0, 5),
        UDim2.new(0, 10, 0.5, -2), T.Accent, 0, 7)
    corner(hDot, CR_FULL)
    gradient(hDot, T.GradAccent, 90)

    local hTitle        = makeLabel(header, title:upper(), 10, T.TextLow,
        FONT_BOLD, Enum.TextXAlignment.Left, 7)
    hTitle.Size         = UDim2.new(1, -24, 1, 0)
    hTitle.Position     = UDim2.new(0, 22, 0, 0)

    -- Divider
    local div           = makeFrame(wrap, UDim2.new(1, -20, 0, 1),
        UDim2.new(0, 10, 0, 28), T.BorderFaint, 0.3, 6)
    gradient(div, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   T.BorderFaint),
        ColorSequenceKeypoint.new(0.5, T.BorderMid),
        ColorSequenceKeypoint.new(1,   T.BorderFaint),
    }), 90)

    -- Items area
    local area          = makeFrame(wrap, UDim2.new(1, 0, 0, 0),
        UDim2.new(0, 0, 0, 30), T.BgCard, 1, 6)
    area.AutomaticSize  = Enum.AutomaticSize.Y
    padding(area, 8, 10, 10, 10)
    local lay           = listLayout(area, Enum.FillDirection.Vertical, 5)
    -- auto-resize
    lay.Changed:Connect(function()
        wrap.Size = UDim2.new(1, 0, 0, 30 + lay.AbsoluteContentSize.Y + 18)
    end)

    local s             = setmetatable({}, Section)
    s._area             = area
    s._win              = self._win
    return s
end

Tab.AddGroupbox = Tab.AddSection

-- ════════════════════════════════════════════════════════════
--  COMPONENTES
-- ════════════════════════════════════════════════════════════

-- ── Label ────────────────────────────────────────────────────
function Section:AddLabel(text)
    local l         = makeLabel(self._area, text, 12, T.TextMid, FONT_SEMI, nil, 7)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.Size          = UDim2.new(1, 0, 0, 0)
    return {
        SetText   = function(_, t) l.Text = tostring(t) end,
        GetText   = function(_) return l.Text end,
        SetColor  = function(_, c) l.TextColor3 = c end,
        _instance = l,
    }
end

-- ── Button ────────────────────────────────────────────────────
function Section:AddButton(text, cb, style)
    style = style or "accent"   -- "accent" | "ghost" | "danger" | "success"

    local bgCol, bgColH, bgColP, txtCol
    if style == "ghost" then
        bgCol = T.BgCard; bgColH = T.BgCardHover; bgColP = T.BgSurface
        txtCol = T.TextMid
    elseif style == "danger" then
        bgCol = Color3.fromRGB(60,20,20); bgColH = T.Red; bgColP = Color3.fromRGB(140,40,40)
        txtCol = T.Red
    elseif style == "success" then
        bgCol = Color3.fromRGB(20,50,30); bgColH = T.Green; bgColP = Color3.fromRGB(40,130,70)
        txtCol = T.Green
    else
        bgCol = T.AccentDim; bgColH = T.Accent; bgColP = T.AccentGlow
        txtCol = Color3.new(1,1,1)
    end

    local btn           = Instance.new("TextButton")
    btn.Size            = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = bgCol
    btn.Text            = ""
    btn.AutoButtonColor = false
    btn.ZIndex          = 7
    btn.Parent          = self._area
    corner(btn, CR_SM)
    stroke(btn, T.BorderFaint, 1, 0.4)

    -- Gradient del botón
    local bGrad         = gradient(btn, ColorSequence.new({
        ColorSequenceKeypoint.new(0, bgColH),
        ColorSequenceKeypoint.new(1, bgCol),
    }), 135)

    local bLbl          = makeLabel(btn, text, 12, txtCol, FONT_BOLD,
        Enum.TextXAlignment.Center, 8)
    bLbl.Size           = UDim2.new(1, 0, 1, 0)
    bLbl.TextYAlignment = Enum.TextYAlignment.Center

    btn.MouseEnter:Connect(function()
        tw(btn, { BackgroundColor3 = bgColH })
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, { BackgroundColor3 = bgCol })
    end)
    btn.MouseButton1Down:Connect(function()
        tw(btn, { BackgroundColor3 = bgColP })
    end)
    btn.MouseButton1Up:Connect(function()
        tw(btn, { BackgroundColor3 = bgColH })
    end)
    btn.MouseButton1Click:Connect(function()
        if cb then cb() end
    end)

    return {
        SetText   = function(_, t) bLbl.Text = t end,
        _instance = btn,
    }
end

-- ── Toggle ────────────────────────────────────────────────────
function Section:AddToggle(text, default, cb)
    local val = default ~= nil and default or false

    local row           = makeFrame(self._area, UDim2.new(1, 0, 0, 30), nil, T.BgCard, 1, 7)

    local lbl           = makeLabel(row, text, 12, T.TextHigh, FONT, nil, 8)
    lbl.Size            = UDim2.new(1, -54, 1, 0)

    local track         = makeFrame(row, UDim2.new(0, 42, 0, 22),
        UDim2.new(1, -44, 0.5, -11), val and T.Accent or T.BorderFaint, 0, 8)
    corner(track, CR_FULL)
    stroke(track, T.BorderMid, 1, 0.4)
    if val then gradient(track, T.GradAccent, 90) end

    local thumb         = makeFrame(track, UDim2.new(0, 16, 0, 16),
        val and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        Color3.new(1,1,1), 0, 9)
    corner(thumb, CR_FULL)

    local click         = Instance.new("TextButton")
    click.Size          = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text          = ""
    click.ZIndex        = 9
    click.Parent        = row

    click.MouseButton1Click:Connect(function()
        val = not val
        tw(track, { BackgroundColor3 = val and T.Accent or T.BorderFaint })
        tw(thumb, { Position = val and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8) })
        if cb then cb(val) end
    end)

    return {
        SetValue = function(_, v)
            val = v
            tw(track, { BackgroundColor3 = val and T.Accent or T.BorderFaint })
            tw(thumb, { Position = val and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8) })
        end,
        GetValue = function(_) return val end,
    }
end

-- ── Input ─────────────────────────────────────────────────────
function Section:AddInput(labelText, placeholder, cb, multi)
    local wrap          = makeFrame(self._area, UDim2.new(1, 0, 0, 0), nil, T.BgCard, 1, 7)
    wrap.AutomaticSize  = Enum.AutomaticSize.Y
    listLayout(wrap, Enum.FillDirection.Vertical, 3)

    if labelText and labelText ~= "" then
        local lbl = makeLabel(wrap, labelText, 10, T.TextLow, FONT_BOLD, nil, 8)
        lbl.Size  = UDim2.new(1, 0, 0, 14)
    end

    local inputFrame    = makeFrame(wrap, UDim2.new(1, 0, 0, multi and 65 or 30),
        nil, T.BgInput, 0, 7)
    corner(inputFrame, CR_SM)
    stroke(inputFrame, T.BorderFaint, 1, 0.2)
    gradient(inputFrame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 14, 24)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 16)),
    }), 135)

    local iStroke       = stroke(inputFrame, T.BorderFaint, 1, 0.4)

    local box           = Instance.new("TextBox")
    box.Size            = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.Font            = FONT_MONO
    box.TextSize        = 12
    box.TextColor3      = T.TextCode
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = T.TextLow
    box.Text            = ""
    box.TextXAlignment  = Enum.TextXAlignment.Left
    box.TextYAlignment  = Enum.TextYAlignment.Top
    box.MultiLine       = multi or false
    box.TextWrapped     = multi or false
    box.ClearTextOnFocus = false
    box.ZIndex          = 8
    box.Parent          = inputFrame
    padding(box, 5, 8, 5, 10)

    box.Focused:Connect(function()
        tw(iStroke, { Color = T.Accent, Transparency = 0 })
        tw(inputFrame, { BackgroundColor3 = Color3.fromRGB(18, 16, 28) })
    end)
    box.FocusLost:Connect(function(enter)
        tw(iStroke, { Color = T.BorderFaint, Transparency = 0.4 })
        tw(inputFrame, { BackgroundColor3 = T.BgInput })
        if cb then cb(box.Text, enter) end
    end)
    box.Changed:Connect(function(p)
        if p == "Text" and cb then cb(box.Text, false) end
    end)

    return {
        GetText   = function(_) return box.Text end,
        SetText   = function(_, t) box.Text = tostring(t) end,
        _instance = box,
    }
end

-- ── Dropdown ──────────────────────────────────────────────────
function Section:AddDropdown(labelText, options, default, cb)
    local sel       = default or (options and options[1]) or ""
    local open      = false

    local wrap      = makeFrame(self._area, UDim2.new(1, 0, 0, 0), nil, T.BgCard, 1, 7)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    wrap.ClipsDescendants = false
    listLayout(wrap, Enum.FillDirection.Vertical, 3)

    if labelText and labelText ~= "" then
        local lbl = makeLabel(wrap, labelText, 10, T.TextLow, FONT_BOLD, nil, 8)
        lbl.Size  = UDim2.new(1, 0, 0, 14)
    end

    local btn       = Instance.new("TextButton")
    btn.Size        = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = T.BgCard
    btn.Text        = ""
    btn.AutoButtonColor = false
    btn.ZIndex      = 8
    btn.Parent      = wrap
    corner(btn, CR_SM)
    stroke(btn, T.BorderFaint, 1, 0.3)
    gradient(btn, T.GradCard, 135)

    local selLbl    = makeLabel(btn, tostring(sel), 12, T.TextHigh, FONT, nil, 9)
    selLbl.Size     = UDim2.new(1, -28, 1, 0)
    selLbl.Position = UDim2.new(0, 10, 0, 0)

    local arrow     = makeLabel(btn, "▾", 11, T.TextMid, FONT_BOLD,
        Enum.TextXAlignment.Center, 9)
    arrow.Size      = UDim2.new(0, 20, 1, 0)
    arrow.Position  = UDim2.new(1, -22, 0, 0)

    -- Menú flotante
    local menu      = makeFrame(wrap, UDim2.new(1, 0, 0, 0),
        UDim2.new(0, 0, 1, 4), T.BgSurface, 0, 20)
    menu.Visible    = false
    menu.ClipsDescendants = true
    corner(menu, CR_SM)
    stroke(menu, T.Accent, 1, 0.5)
    gradient(menu, T.GradCard, 145)

    local mScroll   = Instance.new("ScrollingFrame")
    mScroll.Size    = UDim2.new(1, 0, 1, 0)
    mScroll.BackgroundTransparency = 1
    mScroll.ScrollBarThickness = 2
    mScroll.ScrollBarImageColor3 = T.Accent
    mScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    mScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    mScroll.ZIndex  = 21
    mScroll.Parent  = menu
    padding(mScroll, 3, 4, 3, 4)
    listLayout(mScroll, Enum.FillDirection.Vertical, 2)

    local function close()
        open = false
        tw(menu, { Size = UDim2.new(1, 0, 0, 0) }, TW_FAST)
        task.delay(0.15, function() menu.Visible = false end)
        tw(arrow, { Rotation = 0 }, TW_FAST)
    end

    local function buildMenu()
        for _, c in ipairs(mScroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, opt in ipairs(options or {}) do
            local isActive = (opt == sel)
            local item     = Instance.new("TextButton")
            item.Size      = UDim2.new(1, 0, 0, 26)
            item.BackgroundColor3 = isActive and T.AccentDim or T.BgCard
            item.Text      = tostring(opt)
            item.Font      = isActive and FONT_BOLD or FONT
            item.TextSize  = 12
            item.TextColor3 = isActive and Color3.new(1,1,1) or T.TextHigh
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.AutoButtonColor = false
            item.ZIndex    = 22
            item.Parent    = mScroll
            corner(item, CR_XS)
            padding(item, 0, 0, 0, 8)

            if isActive then gradient(item, T.GradAccent, 135) end

            item.MouseEnter:Connect(function()
                if not isActive then tw(item, { BackgroundColor3 = T.BgCardHover }) end
            end)
            item.MouseLeave:Connect(function()
                if not isActive then tw(item, { BackgroundColor3 = T.BgCard }) end
            end)
            item.MouseButton1Click:Connect(function()
                sel = opt
                selLbl.Text = tostring(opt)
                close()
                buildMenu()
                if cb then cb(opt) end
            end)
        end
    end

    buildMenu()

    btn.MouseButton1Click:Connect(function()
        if open then
            close()
        else
            open = true
            menu.Visible = true
            local h = math.min(#(options or {}) * 28 + 8, 130)
            tw(menu, { Size = UDim2.new(1, 0, 0, h) }, TW_FAST)
            tw(arrow, { Rotation = 180 }, TW_FAST)
        end
    end)

    return {
        GetValue    = function(_) return sel end,
        SetValue    = function(_, v) sel = v; selLbl.Text = tostring(v); buildMenu() end,
        SetOptions  = function(_, o) options = o; buildMenu() end,
    }
end

-- ── Separator ─────────────────────────────────────────────────
function Section:AddSeparator()
    local sep = makeFrame(self._area, UDim2.new(1, 0, 0, 1), nil, T.BorderFaint, 0, 7)
    gradient(sep, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   T.BgCard),
        ColorSequenceKeypoint.new(0.4, T.BorderMid),
        ColorSequenceKeypoint.new(1,   T.BgCard),
    }), 90)
end

-- ── Space ─────────────────────────────────────────────────────
function Section:AddSpace(h)
    local sp = makeFrame(self._area, UDim2.new(1, 0, 0, h or 4), nil, T.BgCard, 1, 7)
end

-- ── ScrollList (especial para Remote Items) ────────────────────
function Section:AddScrollList(height)
    local frame         = Instance.new("ScrollingFrame")
    frame.Size          = UDim2.new(1, 0, 0, height or 200)
    frame.BackgroundColor3 = T.BgInput
    frame.BackgroundTransparency = 0.3
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = T.Accent
    frame.ScrollBarImageTransparency = 0.3
    frame.CanvasSize    = UDim2.new(0, 0, 0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.ZIndex        = 7
    frame.Parent        = self._area
    corner(frame, CR_SM)
    stroke(frame, T.BorderFaint, 1, 0.3)
    padding(frame, 4, 4, 4, 4)
    listLayout(frame, Enum.FillDirection.Vertical, 3)

    return frame
end

-- ── Exports ───────────────────────────────────────────────────
NexusGui.T       = T
NexusGui._Window = Window
NexusGui._Tab    = Tab
NexusGui._Section = Section

return NexusGui
