--[[
    ╔══════════════════════════════════════════════════════╗
    ║           L I N O X   F R A M E W O R K             ║
    ║           UI Library for Roblox  •  v3.0            ║
    ║   github.com/Ades12121212121/Linox                  ║
    ╚══════════════════════════════════════════════════════╝
]]

local Linox          = {}
Linox.__index        = Linox

-- ── Services ─────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LP               = Players.LocalPlayer
local PG               = LP:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════════════════════════════
--  THEME
-- ══════════════════════════════════════════════════════════════════
local C = {
    -- Backgrounds
    Bg0          = Color3.fromRGB(6,    6,   10),
    Bg1          = Color3.fromRGB(10,  10,   16),
    Bg2          = Color3.fromRGB(15,  15,   23),
    Bg3          = Color3.fromRGB(20,  20,   31),
    Bg4          = Color3.fromRGB(26,  26,   40),
    BgHover      = Color3.fromRGB(31,  31,   48),

    -- Accent  (purple → teal gradient)
    A0           = Color3.fromRGB(88,  66,  220),
    A1           = Color3.fromRGB(108, 86,  245),
    A2           = Color3.fromRGB(128, 108, 255),
    A3           = Color3.fromRGB(48,  200, 210),
    ADim         = Color3.fromRGB(55,  40,  140),

    -- Borders
    B0           = Color3.fromRGB(28,  28,   42),
    B1           = Color3.fromRGB(42,  42,   62),
    B2           = Color3.fromRGB(65,  65,   95),
    BGlass       = Color3.fromRGB(100, 100, 145),

    -- Text
    T0           = Color3.fromRGB(235, 235, 248),
    T1           = Color3.fromRGB(155, 155, 185),
    T2           = Color3.fromRGB(85,  85,  115),
    TCode        = Color3.fromRGB(120, 210, 175),
    TAccent      = Color3.fromRGB(140, 120, 255),

    -- Semantic
    Green        = Color3.fromRGB(55,  210, 140),
    GreenDim     = Color3.fromRGB(20,  65,  42),
    Red          = Color3.fromRGB(235, 70,  70),
    RedDim       = Color3.fromRGB(70,  20,  20),
    Yellow       = Color3.fromRGB(235, 175, 45),
    YellowDim    = Color3.fromRGB(70,  52,  14),
    Blue         = Color3.fromRGB(55,  185, 245),
    BlueDim      = Color3.fromRGB(16,  55,  80),

    -- Gradients
    GAccent  = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(108, 86,  245)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(48,  200, 210)),
    }),
    GDark    = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(18,  17,  28)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(11,  11,  17)),
    }),
    GCard    = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(24,  23,  36)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(16,  16,  25)),
    }),
    GSurface = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(15,  14,  23)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(10,  10,  16)),
    }),
    White = Color3.new(1,1,1),
}

-- ── Tween presets ────────────────────────────────────────────────
local TS = {
    Snap   = TweenInfo.new(0.08, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
    Fast   = TweenInfo.new(0.15, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
    Mid    = TweenInfo.new(0.22, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
    Slow   = TweenInfo.new(0.38, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.45, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
}

-- ── Fonts ────────────────────────────────────────────────────────
local F = {
    Regular = Enum.Font.Gotham,
    Medium  = Enum.Font.GothamMedium,
    Bold    = Enum.Font.GothamBold,
    SemiBold= Enum.Font.GothamSemibold,
    Mono    = Enum.Font.Code,
}

-- ── Corner radii ────────────────────────────────────────────────
local R = { XS=3, SM=6, MD=10, LG=14, XL=20, Full=999 }

-- ══════════════════════════════════════════════════════════════════
--  PRIMITIVES
-- ══════════════════════════════════════════════════════════════════
local function tw(obj, props, info)
    TweenService:Create(obj, info or TS.Mid, props):Play()
end

local function rnd(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or R.MD)
    c.Parent = parent; return c
end

local function str(parent, col, thick, transp)
    local s = Instance.new("UIStroke")
    s.Color = col or C.B1; s.Thickness = thick or 1
    s.Transparency = transp or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent; return s
end

local function grad(parent, cs, rot)
    local g = Instance.new("UIGradient")
    g.Color = cs or C.GCard; g.Rotation = rot or 135
    g.Parent = parent; return g
end

local function pad(parent, t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 6)
    p.PaddingRight  = UDim.new(0, r or 8)
    p.PaddingBottom = UDim.new(0, b or 6)
    p.PaddingLeft   = UDim.new(0, l or 8)
    p.Parent = parent; return p
end

local function ll(parent, dir, space, ha, va)
    local u = Instance.new("UIListLayout")
    u.FillDirection       = dir   or Enum.FillDirection.Vertical
    u.Padding             = UDim.new(0, space or 4)
    u.HorizontalAlignment = ha    or Enum.HorizontalAlignment.Left
    u.VerticalAlignment   = va    or Enum.VerticalAlignment.Top
    u.SortOrder           = Enum.SortOrder.LayoutOrder
    u.Parent = parent; return u
end

local function frame(parent, size, pos, bg, trans, zi)
    local f = Instance.new("Frame")
    f.Size                   = size  or UDim2.new(1,0,0,30)
    f.Position               = pos   or UDim2.new(0,0,0,0)
    f.BackgroundColor3       = bg    or C.Bg3
    f.BackgroundTransparency = trans or 0
    f.BorderSizePixel        = 0
    f.ZIndex                 = zi    or 1
    f.Parent                 = parent
    return f
end

local function lbl(parent, text, size, col, font, xa, zi)
    local l = Instance.new("TextLabel")
    l.Text                   = text  or ""
    l.TextSize               = size  or 13
    l.TextColor3             = col   or C.T0
    l.Font                   = font  or F.Medium
    l.BackgroundTransparency = 1
    l.TextXAlignment         = xa    or Enum.TextXAlignment.Left
    l.TextYAlignment         = Enum.TextYAlignment.Center
    l.Size                   = UDim2.new(1,0,0,14)
    l.AutomaticSize          = Enum.AutomaticSize.Y
    l.TextWrapped            = true
    l.ZIndex                 = zi    or 4
    l.Parent                 = parent
    return l
end

local function imgLbl(parent, id, size, pos, zi)
    local i = Instance.new("ImageLabel")
    i.Image                  = "rbxassetid://" .. id
    i.Size                   = size  or UDim2.new(0,16,0,16)
    i.Position               = pos   or UDim2.new(0,0,0.5,-8)
    i.BackgroundTransparency = 1
    i.ZIndex                 = zi    or 5
    i.Parent                 = parent
    return i
end

local function draggable(root, handle)
    local drag, di, mp, fp = false, nil, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag=true; mp=i.Position; fp=root.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement then di=i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i==di and drag then
            local d=i.Position-mp
            root.Position=UDim2.new(fp.X.Scale,fp.X.Offset+d.X,fp.Y.Scale,fp.Y.Offset+d.Y)
        end
    end)
end

-- ══════════════════════════════════════════════════════════════════
--  ICON SYSTEM  (ImageLabel icons via Roblox asset IDs)
-- ══════════════════════════════════════════════════════════════════
-- Clean icon asset IDs (Roblox built-in UI icons)
local Icons = {
    scan       = 3926305904,
    execute    = 3926307534,
    hook       = 3926307048,
    debug      = 3926305904,
    close      = 3926305688,
    minimize   = 3926307308,
    chevronD   = 3926305678,
    chevronR   = 3926307670,
    check      = 3926305524,
    warning    = 3926309486,
    error      = 3926305688,
    info       = 3926307258,
    copy       = 3926307166,
    trash      = 3926309386,
    refresh    = 3926309486,
    play       = 3926307534,
    plus       = 3926307630,
    search     = 3926305904,
    link       = 3926307258,
    settings   = 3926309268,
}

local function icon(parent, id, color, size, pos, zi)
    local img = imgLbl(parent, id or 3926305904,
        size or UDim2.new(0,14,0,14),
        pos  or UDim2.new(0,0,0.5,-7),
        zi   or 6)
    img.ImageColor3 = color or C.T1
    return img
end

-- ══════════════════════════════════════════════════════════════════
--  NOTIFICATIONS
-- ══════════════════════════════════════════════════════════════════
local notifSG, notifStack

local function ensureNotif()
    if notifStack and notifStack.Parent then return end
    notifSG             = Instance.new("ScreenGui")
    notifSG.Name        = "LinoxNotifs"
    notifSG.ResetOnSpawn = false
    notifSG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifSG.DisplayOrder = 999
    notifSG.Parent      = PG

    notifStack          = frame(notifSG,
        UDim2.new(0,310,1,-20), UDim2.new(1,-318,0,10),
        C.Bg0, 1, 1)
    local layout = ll(notifStack, Enum.FillDirection.Vertical, 6,
        Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
    local p = Instance.new("UIPadding")
    p.PaddingBottom = UDim.new(0,10)
    p.Parent = notifStack
end

function Linox:Notify(opts)
    ensureNotif()
    opts = opts or {}
    local title    = opts.Title    or "Notificacion"
    local desc     = opts.Desc     or ""
    local duration = opts.Duration or 3
    local ntype    = opts.Type     or "info"

    local acol = C.A1
    local icol = Icons.info
    if ntype == "success" then acol = C.Green;  icol = Icons.check
    elseif ntype == "warning" then acol = C.Yellow; icol = Icons.warning
    elseif ntype == "error"   then acol = C.Red;    icol = Icons.error
    elseif ntype == "info"    then acol = C.Blue;   icol = Icons.info
    end

    -- Card
    local card = frame(notifStack,
        UDim2.new(1,0,0,0),
        UDim2.new(1,10,0,0),
        C.Bg3, 0)
    card.AutomaticSize    = Enum.AutomaticSize.Y
    card.ClipsDescendants = true
    card.ZIndex           = 100
    rnd(card, R.MD)

    -- Background
    local bg = frame(card, UDim2.new(1,0,1,0), nil, C.Bg2, 0, 100)
    grad(bg, C.GCard, 135)
    rnd(bg, R.MD)

    -- Glass border
    str(card, C.B1, 1, 0.3)

    -- Top accent strip
    local topStrip = frame(card, UDim2.new(1,0,0,1), nil, acol, 0, 102)
    grad(topStrip, ColorSequence.new({
        ColorSequenceKeypoint.new(0, acol),
        ColorSequenceKeypoint.new(0.7, C.A3),
        ColorSequenceKeypoint.new(1, acol),
    }), 90)

    -- Left accent strip
    local leftStrip = frame(card, UDim2.new(0,2,0,0), UDim2.new(0,0,0,1), acol, 0, 102)
    leftStrip.AutomaticSize = Enum.AutomaticSize.Y

    -- Content
    local inner = frame(card, UDim2.new(1,-18,0,0), UDim2.new(0,18,0,8), C.Bg3, 1, 103)
    inner.AutomaticSize = Enum.AutomaticSize.Y
    ll(inner, Enum.FillDirection.Vertical, 2)

    -- Icon + Title row
    local titleRow = frame(inner, UDim2.new(1,0,0,18), nil, C.Bg3, 1, 104)
    ll(titleRow, Enum.FillDirection.Horizontal, 6, nil, Enum.VerticalAlignment.Center)

    local ic = imgLbl(titleRow, icol, UDim2.new(0,13,0,13), UDim2.new(0,0,0,0), 105)
    ic.ImageColor3 = acol
    ic.Size        = UDim2.new(0,13,0,13)

    local tl = lbl(titleRow, title, 13, C.T0, F.Bold, nil, 105)
    tl.Size  = UDim2.new(1,-20,0,18)
    tl.AutomaticSize = Enum.AutomaticSize.None

    if desc ~= "" then
        local dl = lbl(inner, desc, 11, C.T1, F.Regular, nil, 104)
        dl.AutomaticSize = Enum.AutomaticSize.Y
    end

    -- Bottom padding
    local bp = frame(inner, UDim2.new(1,0,0,6), nil, C.Bg3, 1, 104)

    -- Progress bar track
    local track = frame(card, UDim2.new(1,-18,0,2), UDim2.new(0,18,1,-6), C.B0, 0, 103)
    rnd(track, R.Full)

    local bar = frame(track, UDim2.new(1,0,1,0), nil, acol, 0, 104)
    rnd(bar, R.Full)
    grad(bar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, acol),
        ColorSequenceKeypoint.new(1, C.A3),
    }), 90)

    -- Animate in
    tw(card, { Position = UDim2.new(0,0,0,0) }, TS.Spring)

    TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear),
        { Size = UDim2.new(0,0,1,0) }):Play()

    task.delay(duration, function()
        tw(card, { Position = UDim2.new(1,10,0,0) }, TS.Mid)
        task.delay(0.25, function() card:Destroy() end)
    end)
end

-- ══════════════════════════════════════════════════════════════════
--  WINDOW
-- ══════════════════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

function Linox:CreateWindow(opts)
    opts   = opts or {}
    local W      = opts.Width    or 800
    local H      = opts.Height   or 520
    local title  = opts.Title    or "Linox"
    local tabW   = opts.TabWidth or 155

    -- ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name          = "Linox_" .. title:gsub("%s","_")
    sg.ResetOnSpawn  = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder  = 100
    sg.Parent        = PG

    -- Root frame
    local root = frame(sg,
        UDim2.new(0,W,0,H),
        UDim2.new(0.5,-W/2,0.5,-H/2),
        C.Bg1, 0, 1)
    root.ClipsDescendants = false
    rnd(root, R.LG)

    -- Outer glow/shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Size             = UDim2.new(1,80,1,80)
    shadow.Position         = UDim2.new(0,-40,0,-40)
    shadow.BackgroundTransparency = 1
    shadow.Image            = "rbxassetid://6014261993"
    shadow.ImageColor3      = C.Bg0
    shadow.ImageTransparency = 0.3
    shadow.ScaleType        = Enum.ScaleType.Slice
    shadow.SliceCenter      = Rect.new(49,49,450,450)
    shadow.ZIndex           = 0
    shadow.Parent           = root

    -- Background gradient
    local bgf = frame(root, UDim2.new(1,0,1,0), nil, C.Bg1, 0, 1)
    grad(bgf, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(13, 12, 20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(9,  9,  15)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(7,  7,  12)),
    }), 150)
    rnd(bgf, R.LG)

    -- Subtle noise overlay (glass feel)
    str(root, C.BGlass, 1, 0.78)

    -- Top accent line (gradient)
    local topLine = frame(root, UDim2.new(0.55,0,0,1),
        UDim2.new(0.225,0,0,0), C.A1, 0, 8)
    grad(topLine, C.GAccent, 90)
    rnd(topLine, R.Full)

    -- ── TOPBAR ────────────────────────────────────────────────────
    local topbar = frame(root, UDim2.new(1,0,0,42), nil, C.Bg2, 0, 4)
    rnd(topbar, R.LG)
    grad(topbar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18,17,28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12,12,19)),
    }), 135)

    -- Topbar bottom patch (square corners on bottom)
    local tbPatch = frame(topbar, UDim2.new(1,0,0,R.LG),
        UDim2.new(0,0,1,-R.LG), C.Bg2, 0, 4)
    grad(tbPatch, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18,17,28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12,12,19)),
    }), 135)

    -- Topbar bottom separator
    local tbSep = frame(root, UDim2.new(1,-24,0,1),
        UDim2.new(0,12,0,42), C.B0, 0, 5)
    grad(tbSep, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.Bg1),
        ColorSequenceKeypoint.new(0.3, C.B1),
        ColorSequenceKeypoint.new(0.7, C.B1),
        ColorSequenceKeypoint.new(1,   C.Bg1),
    }), 90)

    -- Logo mark (animated dot cluster)
    local logoWrap = frame(topbar, UDim2.new(0,22,0,22),
        UDim2.new(0,14,0.5,-11), C.Bg3, 1, 6)
    ll(logoWrap, Enum.FillDirection.Horizontal, 2,
        Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)

    local function logoDot(col, size, delay)
        local d = frame(logoWrap, UDim2.new(0,size,0,size), nil, col, 0, 7)
        rnd(d, R.Full)
        grad(d, C.GAccent, 135)
        task.spawn(function()
            while task.wait(0.8 + delay) do
                tw(d, { BackgroundTransparency = 0.6 }, TS.Slow)
                task.wait(0.5)
                tw(d, { BackgroundTransparency = 0 }, TS.Slow)
            end
        end)
        return d
    end
    logoDot(C.A1, 6, 0)
    logoDot(C.A2, 5, 0.2)
    logoDot(C.A3, 4, 0.4)

    -- Title
    local titleLbl = lbl(topbar, title, 14, C.T0, F.Bold, Enum.TextXAlignment.Left, 6)
    titleLbl.Size     = UDim2.new(0,200,1,0)
    titleLbl.Position = UDim2.new(0,44,0,0)
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center

    -- Subtitle
    local subLbl = lbl(topbar, "UI Framework  v3.0",
        10, C.T2, F.Regular, Enum.TextXAlignment.Left, 6)
    subLbl.Size     = UDim2.new(0,160,0,12)
    subLbl.Position = UDim2.new(0,44,1,-14)

    -- Control buttons
    local ctrlWrap = frame(topbar, UDim2.new(0,58,0,24),
        UDim2.new(1,-66,0.5,-12), C.Bg3, 1, 6)
    ll(ctrlWrap, Enum.FillDirection.Horizontal, 4,
        Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)

    local minimized = false
    local function ctrlBtn(iconId, hoverCol, size, cb)
        local b = Instance.new("TextButton")
        b.Size               = UDim2.new(0,size or 26,0,size or 26)
        b.BackgroundColor3   = C.Bg3
        b.BackgroundTransparency = 0.2
        b.Text               = ""
        b.AutoButtonColor    = false
        b.ZIndex             = 7
        b.Parent             = ctrlWrap
        rnd(b, R.SM)
        str(b, C.B0, 1, 0.4)

        local ic = imgLbl(b, iconId, UDim2.new(0,10,0,10),
            UDim2.new(0.5,-5,0.5,-5), 8)
        ic.ImageColor3 = C.T2

        b.MouseEnter:Connect(function()
            tw(b, { BackgroundColor3=hoverCol, BackgroundTransparency=0 })
            tw(ic, { ImageColor3=C.White })
        end)
        b.MouseLeave:Connect(function()
            tw(b, { BackgroundColor3=C.Bg3, BackgroundTransparency=0.2 })
            tw(ic, { ImageColor3=C.T2 })
        end)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    local contentRoot  -- declared below

    ctrlBtn(Icons.minimize, C.Yellow, 26, function()
        minimized = not minimized
        tw(root, { Size = minimized
            and UDim2.new(0,W,0,42)
            or  UDim2.new(0,W,0,H) }, TS.Mid)
    end)
    ctrlBtn(Icons.close, C.Red, 26, function()
        tw(root, { Size=UDim2.new(0,W,0,0), BackgroundTransparency=1 }, TS.Mid)
        task.delay(0.3, function() sg:Destroy() end)
    end)

    draggable(root, topbar)

    -- ── SIDEBAR ───────────────────────────────────────────────────
    local sidebar = frame(root,
        UDim2.new(0,tabW,1,-44),
        UDim2.new(0,0,0,44),
        C.Bg2, 0, 3)
    grad(sidebar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15,14,23)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,16)),
    }), 180)

    -- Sidebar right border
    local sbBorder = frame(root, UDim2.new(0,1,1,-46),
        UDim2.new(0,tabW,0,45), C.B0, 0, 4)
    grad(sbBorder, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.B1),
        ColorSequenceKeypoint.new(0.5, C.B0),
        ColorSequenceKeypoint.new(1,   C.Bg1),
    }), 180)

    -- Linox watermark bottom of sidebar
    local wm = lbl(sidebar, "LINOX", 9, C.T2, F.Bold,
        Enum.TextXAlignment.Center, 4)
    wm.Size     = UDim2.new(1,0,0,12)
    wm.Position = UDim2.new(0,0,1,-18)
    grad(wm, C.GAccent, 90)
    wm.TextTransparency = 0.5

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size      = UDim2.new(1,0,1,-28)
    tabScroll.Position  = UDim2.new(0,0,0,6)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 0
    tabScroll.CanvasSize = UDim2.new(0,0,0,0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.ZIndex    = 4
    tabScroll.Parent    = sidebar
    pad(tabScroll, 4,6,4,6)
    ll(tabScroll, Enum.FillDirection.Vertical, 2)

    -- ── CONTENT AREA ──────────────────────────────────────────────
    contentRoot = frame(root,
        UDim2.new(1,-(tabW+1),1,-44),
        UDim2.new(0,tabW+1,0,44),
        C.Bg1, 1, 3)
    contentRoot.ClipsDescendants = true

    -- Subtle radial highlight (top-right)
    local radial = Instance.new("ImageLabel")
    radial.Size             = UDim2.new(0,400,0,300)
    radial.Position         = UDim2.new(1,-350,0,-80)
    radial.BackgroundTransparency = 1
    radial.Image            = "rbxassetid://6014261993"
    radial.ImageColor3      = C.A0
    radial.ImageTransparency = 0.94
    radial.ScaleType        = Enum.ScaleType.Slice
    radial.SliceCenter      = Rect.new(49,49,450,450)
    radial.ZIndex           = 2
    radial.Parent           = contentRoot

    -- Self object
    local self = setmetatable({}, Window)
    self._sg          = sg
    self._root        = root
    self._tabScroll   = tabScroll
    self._contentRoot = contentRoot
    self._tabs        = {}
    self._activeTab   = nil
    self._lib         = Linox
    self._W, self._H  = W, H

    return self
end

-- ══════════════════════════════════════════════════════════════════
--  TAB
-- ══════════════════════════════════════════════════════════════════
local Tab = {}
Tab.__index = Tab

function Window:AddTab(name, iconId)
    local isFirst = #self._tabs == 0

    -- Tab button
    local btn = Instance.new("TextButton")
    btn.Size               = UDim2.new(1,0,0,36)
    btn.BackgroundColor3   = C.Bg2
    btn.BackgroundTransparency = 0.5
    btn.Text               = ""
    btn.AutoButtonColor    = false
    btn.ZIndex             = 5
    btn.Parent             = self._tabScroll
    rnd(btn, R.SM)

    -- Active indicator bar (left)
    local ind = frame(btn, UDim2.new(0,2,0,0),
        UDim2.new(0,0,0.5,-10), C.A1, 1, 7)
    ind.Size = UDim2.new(0,2,0,20)
    rnd(ind, R.Full)
    grad(ind, C.GAccent, 90)

    -- Icon
    local tabIcon
    if iconId then
        tabIcon = imgLbl(btn, iconId, UDim2.new(0,14,0,14),
            UDim2.new(0,10,0.5,-7), 7)
        tabIcon.ImageColor3 = C.T2
    end

    -- Label
    local tabLbl = lbl(btn, name, 12, C.T1, F.Medium,
        Enum.TextXAlignment.Left, 7)
    tabLbl.Size     = UDim2.new(1,-14,1,0)
    tabLbl.Position = UDim2.new(0, iconId and 30 or 12, 0, 0)
    tabLbl.TextYAlignment = Enum.TextYAlignment.Center

    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Size               = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.A1
    page.ScrollBarImageTransparency = 0.6
    page.CanvasSize         = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible            = false
    page.ZIndex             = 4
    page.Parent             = self._contentRoot
    pad(page, 14,14,14,14)
    ll(page, Enum.FillDirection.Vertical, 10)

    local t = setmetatable({}, Tab)
    t._win  = self; t._page = page; t._btn = btn
    t._ind  = ind; t._lbl = tabLbl; t._ico = tabIcon

    btn.MouseButton1Click:Connect(function() self:_activate(t) end)
    btn.MouseEnter:Connect(function()
        if self._activeTab ~= t then
            tw(btn, { BackgroundTransparency=0.2 }, TS.Fast)
            tw(tabLbl, { TextColor3=C.T0 }, TS.Fast)
            if tabIcon then tw(tabIcon, { ImageColor3=C.T1 }, TS.Fast) end
        end
    end)
    btn.MouseLeave:Connect(function()
        if self._activeTab ~= t then
            tw(btn, { BackgroundTransparency=0.5 }, TS.Fast)
            tw(tabLbl, { TextColor3=C.T1 }, TS.Fast)
            if tabIcon then tw(tabIcon, { ImageColor3=C.T2 }, TS.Fast) end
        end
    end)

    table.insert(self._tabs, t)
    if isFirst then self:_activate(t) end
    return t
end

function Window:_activate(tab)
    if self._activeTab then
        local p = self._activeTab
        p._page.Visible = false
        tw(p._btn, { BackgroundColor3=C.Bg2, BackgroundTransparency=0.5 }, TS.Fast)
        tw(p._lbl, { TextColor3=C.T1 }, TS.Fast)
        tw(p._ind, { BackgroundTransparency=1 }, TS.Fast)
        if p._ico then tw(p._ico, { ImageColor3=C.T2 }, TS.Fast) end
    end
    tab._page.Visible = true
    tw(tab._btn, { BackgroundColor3=C.Bg4, BackgroundTransparency=0 }, TS.Fast)
    tw(tab._lbl, { TextColor3=C.T0 }, TS.Fast)
    tw(tab._ind, { BackgroundTransparency=0 }, TS.Fast)
    if tab._ico then tw(tab._ico, { ImageColor3=C.TAccent }, TS.Fast) end
    self._activeTab = tab
end

-- ══════════════════════════════════════════════════════════════════
--  SECTION
-- ══════════════════════════════════════════════════════════════════
local Section = {}
Section.__index = Section

function Tab:AddSection(title)
    local wrap = frame(self._page, UDim2.new(1,0,0,0), nil, C.Bg3, 0, 5)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    rnd(wrap, R.MD)
    str(wrap, C.B0, 1, 0.2)
    grad(wrap, C.GCard, 150)

    -- Top glass shimmer
    local shimmer = frame(wrap, UDim2.new(1,0,0,1), nil, C.BGlass, 0.78, 6)
    rnd(shimmer, R.MD)

    -- Header
    local header = frame(wrap, UDim2.new(1,0,0,32), nil, C.Bg2, 0, 6)
    rnd(header, R.MD)
    grad(header, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22,21,34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,23)),
    }), 135)

    -- Header square-corners patch (bottom)
    local hp = frame(header, UDim2.new(1,0,0,R.MD),
        UDim2.new(0,0,1,-R.MD), C.Bg2, 0, 6)
    grad(hp, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22,21,34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,23)),
    }), 135)

    -- Section title accent dot
    local dot = frame(header, UDim2.new(0,4,0,4),
        UDim2.new(0,12,0.5,-2), C.A1, 0, 8)
    rnd(dot, R.Full)
    grad(dot, C.GAccent, 135)

    -- Section title text
    local titleLbl = lbl(header, title:upper(), 10, C.T2, F.Bold,
        Enum.TextXAlignment.Left, 8)
    titleLbl.Size     = UDim2.new(1,-30,1,0)
    titleLbl.Position = UDim2.new(0,24,0,0)
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center

    -- Divider under header
    local div = frame(wrap, UDim2.new(1,-20,0,1),
        UDim2.new(0,10,0,32), C.B0, 0.2, 6)
    grad(div, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.Bg3),
        ColorSequenceKeypoint.new(0.4, C.B1),
        ColorSequenceKeypoint.new(1,   C.Bg3),
    }), 90)

    -- Items area
    local area = frame(wrap, UDim2.new(1,0,0,0),
        UDim2.new(0,0,0,34), C.Bg3, 1, 6)
    area.AutomaticSize = Enum.AutomaticSize.Y
    pad(area, 6, 12, 12, 12)
    local layout = ll(area, Enum.FillDirection.Vertical, 6)

    -- Auto-resize wrapper
    layout.Changed:Connect(function()
        wrap.Size = UDim2.new(1,0,0, 34 + layout.AbsoluteContentSize.Y + 18)
    end)

    local s = setmetatable({}, Section)
    s._area = area; s._win = self._win
    return s
end
Tab.AddGroupbox = Tab.AddSection

-- ══════════════════════════════════════════════════════════════════
--  COMPONENTS
-- ══════════════════════════════════════════════════════════════════

-- ── Label ────────────────────────────────────────────────────────
function Section:AddLabel(text)
    local l = lbl(self._area, text, 12, C.T1, F.Regular, nil, 7)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.Size          = UDim2.new(1,0,0,0)
    return {
        SetText  = function(_, t) l.Text = tostring(t) end,
        GetText  = function(_)    return l.Text end,
        SetColor = function(_, c) l.TextColor3 = c end,
        SetSize  = function(_, s) l.TextSize = s end,
        _i = l,
    }
end

-- ── Button ────────────────────────────────────────────────────────
function Section:AddButton(text, cb, style, iconId)
    style = style or "primary"

    local schemes = {
        primary = {
            bg    = C.ADim,
            bgH   = C.A1,
            bgP   = C.A0,
            txt   = C.White,
            gr    = C.GAccent,
            bdr   = C.A0,
        },
        ghost = {
            bg    = C.Bg3,
            bgH   = C.Bg4,
            bgP   = C.Bg2,
            txt   = C.T1,
            gr    = nil,
            bdr   = C.B1,
        },
        danger = {
            bg    = C.RedDim,
            bgH   = C.Red,
            bgP   = Color3.fromRGB(150,30,30),
            txt   = C.Red,
            gr    = nil,
            bdr   = C.Red,
        },
        success = {
            bg    = C.GreenDim,
            bgH   = C.Green,
            bgP   = Color3.fromRGB(25,100,55),
            txt   = C.Green,
            gr    = nil,
            bdr   = C.Green,
        },
    }
    local s = schemes[style] or schemes.primary

    local btn = Instance.new("TextButton")
    btn.Size               = UDim2.new(1,0,0,32)
    btn.BackgroundColor3   = s.bg
    btn.Text               = ""
    btn.AutoButtonColor    = false
    btn.ZIndex             = 7
    btn.Parent             = self._area
    rnd(btn, R.SM)
    str(btn, s.bdr, 1, style == "primary" and 0.6 or 0.55)

    if s.gr then
        local g = grad(btn, s.gr, 135)
    end

    -- Icon
    local xStart = 0
    if iconId then
        local ic = imgLbl(btn, iconId, UDim2.new(0,13,0,13),
            UDim2.new(0,12,0.5,-6), 9)
        ic.ImageColor3 = style == "primary" and C.White or s.txt
        xStart = 28
    end

    local bLbl = lbl(btn, text, 12, s.txt, F.Bold,
        iconId and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center, 8)
    bLbl.Size     = iconId and UDim2.new(1,-40,1,0) or UDim2.new(1,0,1,0)
    bLbl.Position = iconId and UDim2.new(0,xStart,0,0) or UDim2.new(0,0,0,0)
    bLbl.TextYAlignment = Enum.TextYAlignment.Center

    btn.MouseEnter:Connect(function()
        tw(btn, { BackgroundColor3=s.bgH }, TS.Fast)
        if style ~= "primary" then tw(bLbl, { TextColor3=C.White }, TS.Fast) end
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, { BackgroundColor3=s.bg }, TS.Fast)
        if style ~= "primary" then tw(bLbl, { TextColor3=s.txt }, TS.Fast) end
    end)
    btn.MouseButton1Down:Connect(function()
        tw(btn, { BackgroundColor3=s.bgP }, TS.Snap)
    end)
    btn.MouseButton1Up:Connect(function()
        tw(btn, { BackgroundColor3=s.bgH }, TS.Snap)
    end)
    btn.MouseButton1Click:Connect(function()
        if cb then task.spawn(cb) end
    end)

    return { SetText = function(_, t) bLbl.Text = t end, _i = btn }
end

-- ── Toggle ────────────────────────────────────────────────────────
function Section:AddToggle(text, default, cb)
    local val = default or false

    local row = frame(self._area, UDim2.new(1,0,0,32), nil, C.Bg3, 1, 7)

    local l = lbl(row, text, 12, C.T0, F.Medium, nil, 8)
    l.Size     = UDim2.new(1,-56,1,0)
    l.Position = UDim2.new(0,0,0,0)
    l.TextYAlignment = Enum.TextYAlignment.Center

    -- Track
    local track = frame(row, UDim2.new(0,44,0,24),
        UDim2.new(1,-46,0.5,-12), val and C.A1 or C.B1, 0, 8)
    rnd(track, R.Full)
    str(track, val and C.A0 or C.B1, 1, 0.4)
    if val then grad(track, C.GAccent, 90) end

    -- Thumb
    local thumb = frame(track, UDim2.new(0,18,0,18),
        val and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
        C.White, 0, 9)
    rnd(thumb, R.Full)

    local click = Instance.new("TextButton")
    click.Size               = UDim2.new(1,0,1,0)
    click.BackgroundTransparency = 1
    click.Text               = ""
    click.ZIndex             = 10
    click.Parent             = row

    click.MouseButton1Click:Connect(function()
        val = not val
        tw(track, { BackgroundColor3 = val and C.A1 or C.B1 }, TS.Fast)
        tw(thumb, { Position = val
            and UDim2.new(1,-21,0.5,-9)
            or  UDim2.new(0,3,0.5,-9) }, TS.Mid)
        if cb then cb(val) end
    end)

    return {
        SetValue = function(_, v)
            val = v
            tw(track, { BackgroundColor3 = val and C.A1 or C.B1 }, TS.Fast)
            tw(thumb, { Position = val
                and UDim2.new(1,-21,0.5,-9)
                or  UDim2.new(0,3,0.5,-9) }, TS.Mid)
        end,
        GetValue = function(_) return val end,
    }
end

-- ── Input ─────────────────────────────────────────────────────────
function Section:AddInput(labelText, placeholder, cb, multi)
    local wrap = frame(self._area, UDim2.new(1,0,0,0), nil, C.Bg3, 1, 7)
    wrap.AutomaticSize = Enum.AutomaticSize.Y
    ll(wrap, Enum.FillDirection.Vertical, 3)

    if labelText and labelText ~= "" then
        local hRow = frame(wrap, UDim2.new(1,0,0,14), nil, C.Bg3, 1, 8)
        ll(hRow, Enum.FillDirection.Horizontal, 4, nil, Enum.VerticalAlignment.Center)
        local il = lbl(hRow, labelText, 10, C.T2, F.Bold, nil, 9)
        il.Size = UDim2.new(1,0,0,14)
        il.AutomaticSize = Enum.AutomaticSize.None
    end

    local inputBg = frame(wrap, UDim2.new(1,0,0, multi and 70 or 32),
        nil, C.Bg1, 0, 8)
    rnd(inputBg, R.SM)
    grad(inputBg, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10,10,16)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(7,7,12)),
    }), 135)

    local iStr = str(inputBg, C.B1, 1, 0.4)

    local box = Instance.new("TextBox")
    box.Size               = UDim2.new(1,0,1,0)
    box.BackgroundTransparency = 1
    box.Font               = F.Mono
    box.TextSize           = 12
    box.TextColor3         = C.TCode
    box.PlaceholderText    = placeholder or ""
    box.PlaceholderColor3  = C.T2
    box.Text               = ""
    box.TextXAlignment     = Enum.TextXAlignment.Left
    box.TextYAlignment     = Enum.TextYAlignment.Top
    box.MultiLine          = multi or false
    box.TextWrapped        = multi or false
    box.ClearTextOnFocus   = false
    box.ZIndex             = 9
    box.Parent             = inputBg
    pad(box, 5, 8, 5, 10)

    box.Focused:Connect(function()
        tw(iStr, { Color=C.A1, Transparency=0 }, TS.Fast)
        tw(inputBg, { BackgroundColor3=Color3.fromRGB(13,12,21) }, TS.Fast)
    end)
    box.FocusLost:Connect(function(enter)
        tw(iStr, { Color=C.B1, Transparency=0.4 }, TS.Fast)
        tw(inputBg, { BackgroundColor3=C.Bg1 }, TS.Fast)
        if cb then cb(box.Text, enter) end
    end)
    box.Changed:Connect(function(p)
        if p == "Text" and cb then cb(box.Text, false) end
    end)

    return {
        GetText  = function(_) return box.Text end,
        SetText  = function(_, t) box.Text = tostring(t) end,
        Clear    = function(_) box.Text = "" end,
        _i       = box,
    }
end

-- ── Dropdown ──────────────────────────────────────────────────────
function Section:AddDropdown(labelText, options, default, cb)
    local sel  = default or (options and options[1]) or ""
    local open = false

    local wrap = frame(self._area, UDim2.new(1,0,0,0), nil, C.Bg3, 1, 7)
    wrap.AutomaticSize  = Enum.AutomaticSize.Y
    wrap.ClipsDescendants = false
    ll(wrap, Enum.FillDirection.Vertical, 3)

    if labelText and labelText ~= "" then
        local l = lbl(wrap, labelText, 10, C.T2, F.Bold, nil, 8)
        l.Size  = UDim2.new(1,0,0,14)
        l.AutomaticSize = Enum.AutomaticSize.None
    end

    local btn = Instance.new("TextButton")
    btn.Size               = UDim2.new(1,0,0,32)
    btn.BackgroundColor3   = C.Bg2
    btn.Text               = ""
    btn.AutoButtonColor    = false
    btn.ZIndex             = 8
    btn.Parent             = wrap
    rnd(btn, R.SM)
    str(btn, C.B1, 1, 0.35)
    grad(btn, C.GDark, 135)

    local selLbl = lbl(btn, tostring(sel), 12, C.T0, F.Medium, nil, 9)
    selLbl.Size     = UDim2.new(1,-32,1,0)
    selLbl.Position = UDim2.new(0,10,0,0)
    selLbl.TextYAlignment = Enum.TextYAlignment.Center

    -- Chevron icon
    local chev = imgLbl(btn, Icons.chevronD, UDim2.new(0,11,0,11),
        UDim2.new(1,-19,0.5,-5), 9)
    chev.ImageColor3 = C.T2

    -- Dropdown menu
    local menu = frame(wrap, UDim2.new(1,0,0,0), UDim2.new(0,0,1,4), C.Bg2, 0, 20)
    menu.Visible         = false
    menu.ClipsDescendants = true
    rnd(menu, R.SM)
    str(menu, C.A1, 1, 0.6)
    grad(menu, C.GDark, 145)

    local mScroll = Instance.new("ScrollingFrame")
    mScroll.Size               = UDim2.new(1,0,1,0)
    mScroll.BackgroundTransparency = 1
    mScroll.ScrollBarThickness = 2
    mScroll.ScrollBarImageColor3 = C.A1
    mScroll.CanvasSize         = UDim2.new(0,0,0,0)
    mScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    mScroll.ZIndex             = 21
    mScroll.Parent             = menu
    pad(mScroll, 3,4,3,4)
    ll(mScroll, Enum.FillDirection.Vertical, 2)

    local function close()
        open = false
        tw(menu, { Size=UDim2.new(1,0,0,0) }, TS.Fast)
        task.delay(0.15, function() menu.Visible = false end)
        tw(chev, { Rotation=0 }, TS.Fast)
        tw(btn,  { BackgroundColor3=C.Bg2 }, TS.Fast)
    end

    local function build()
        for _,c in ipairs(mScroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, opt in ipairs(options or {}) do
            local active = (opt == sel)
            local item   = Instance.new("TextButton")
            item.Size    = UDim2.new(1,0,0,28)
            item.BackgroundColor3 = active and C.ADim or C.Bg3
            item.Text    = tostring(opt)
            item.Font    = active and F.Bold or F.Medium
            item.TextSize = 12
            item.TextColor3 = active and C.TAccent or C.T1
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.AutoButtonColor = false
            item.ZIndex  = 22
            item.Parent  = mScroll
            rnd(item, R.XS)
            pad(item, 0,0,0,10)

            if active then
                str(item, C.A0, 1, 0.5)
                grad(item, ColorSequence.new({
                    ColorSequenceKeypoint.new(0, C.ADim),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,30,100)),
                }), 135)

                -- Active checkmark
                local ck = imgLbl(item, Icons.check, UDim2.new(0,10,0,10),
                    UDim2.new(1,-16,0.5,-5), 23)
                ck.ImageColor3 = C.A2
            end

            item.MouseEnter:Connect(function()
                if not active then tw(item, { BackgroundColor3=C.Bg4 }, TS.Snap) end
            end)
            item.MouseLeave:Connect(function()
                if not active then tw(item, { BackgroundColor3=C.Bg3 }, TS.Snap) end
            end)
            item.MouseButton1Click:Connect(function()
                sel = opt
                selLbl.Text = tostring(opt)
                close(); build()
                if cb then cb(opt) end
            end)
        end
    end

    build()

    btn.MouseButton1Click:Connect(function()
        if open then
            close()
        else
            open = true
            menu.Visible = true
            local h = math.min(#(options or {}) * 30 + 8, 160)
            tw(menu, { Size=UDim2.new(1,0,0,h) }, TS.Fast)
            tw(chev, { Rotation=180 }, TS.Fast)
            tw(btn,  { BackgroundColor3=C.Bg4 }, TS.Fast)
        end
    end)

    return {
        GetValue   = function(_) return sel end,
        SetValue   = function(_, v) sel=v; selLbl.Text=tostring(v); build() end,
        SetOptions = function(_, o) options=o; build() end,
    }
end

-- ── Separator ─────────────────────────────────────────────────────
function Section:AddSeparator()
    local s = frame(self._area, UDim2.new(1,0,0,1), nil, C.B0, 0.1, 7)
    grad(s, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.Bg3),
        ColorSequenceKeypoint.new(0.3, C.B1),
        ColorSequenceKeypoint.new(0.7, C.B1),
        ColorSequenceKeypoint.new(1,   C.Bg3),
    }), 90)
end

-- ── Space ─────────────────────────────────────────────────────────
function Section:AddSpace(h)
    frame(self._area, UDim2.new(1,0,0,h or 4), nil, C.Bg3, 1, 7)
end

-- ── ScrollList (for remote rows) ─────────────────────────────────
function Section:AddScrollList(height)
    local sf = Instance.new("ScrollingFrame")
    sf.Size               = UDim2.new(1,0,0,height or 200)
    sf.BackgroundColor3   = C.Bg1
    sf.BackgroundTransparency = 0.2
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = C.A1
    sf.ScrollBarImageTransparency = 0.5
    sf.CanvasSize         = UDim2.new(0,0,0,0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ZIndex             = 7
    sf.Parent             = self._area
    rnd(sf, R.SM)
    str(sf, C.B0, 1, 0.3)
    pad(sf, 4,4,4,4)
    ll(sf, Enum.FillDirection.Vertical, 3)
    return sf
end

-- ── Exports ───────────────────────────────────────────────────────
Linox.C      = C
Linox.Icons  = Icons
Linox.TS     = TS
Linox.F      = F
Linox.R      = R
Linox._tw    = tw
Linox._frame = frame
Linox._lbl   = lbl
Linox._rnd   = rnd
Linox._str   = str
Linox._grad  = grad
Linox._pad   = pad
Linox._ll    = ll
Linox._img   = imgLbl

return Linox
