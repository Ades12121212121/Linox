local ok, montserrat = pcall(function()
    return Enum.Font.Montserrat
end)

local Themes = {
    Default = {
        BackgroundColor = Color3.fromRGB(18, 18, 18),
        MainColor = Color3.fromRGB(27, 27, 27),
        SecondaryColor = Color3.fromRGB(33, 33, 33),
        SurfaceColor = Color3.fromRGB(21, 21, 21),
        AccentColor = Color3.fromRGB(0, 162, 255),
        AccentColor2 = Color3.fromRGB(0, 112, 210),
        OutlineColor = Color3.fromRGB(55, 55, 55),
        SoftOutlineColor = Color3.fromRGB(42, 42, 42),
        TextColor = Color3.fromRGB(245, 245, 245),
        DisabledTextColor = Color3.fromRGB(145, 145, 145),
        Font = Enum.Font.Code,
        CornerRadius = UDim.new(0, 0),
        ElementRadius = UDim.new(0, 0),
        StrokeThickness = 1,
        Transparency = 0,
        GradientRotation = 90,
    },

    NextGen = {
        BackgroundColor = Color3.fromRGB(13, 15, 21),
        MainColor = Color3.fromRGB(22, 25, 34),
        SecondaryColor = Color3.fromRGB(29, 33, 45),
        SurfaceColor = Color3.fromRGB(17, 20, 28),
        AccentColor = Color3.fromRGB(114, 137, 255),
        AccentColor2 = Color3.fromRGB(0, 214, 201),
        OutlineColor = Color3.fromRGB(61, 68, 92),
        SoftOutlineColor = Color3.fromRGB(38, 43, 58),
        TextColor = Color3.fromRGB(244, 247, 255),
        DisabledTextColor = Color3.fromRGB(143, 151, 171),
        Font = ok and montserrat or Enum.Font.GothamMedium,
        CornerRadius = UDim.new(0, 8),
        ElementRadius = UDim.new(0, 6),
        StrokeThickness = 1,
        Transparency = 0.03,
        GradientRotation = 35,
    },

    Light = {
        BackgroundColor = Color3.fromRGB(242, 245, 250),
        MainColor = Color3.fromRGB(255, 255, 255),
        SecondaryColor = Color3.fromRGB(232, 237, 246),
        SurfaceColor = Color3.fromRGB(248, 250, 253),
        AccentColor = Color3.fromRGB(44, 103, 255),
        AccentColor2 = Color3.fromRGB(0, 166, 154),
        OutlineColor = Color3.fromRGB(190, 200, 216),
        SoftOutlineColor = Color3.fromRGB(218, 225, 235),
        TextColor = Color3.fromRGB(24, 31, 43),
        DisabledTextColor = Color3.fromRGB(97, 108, 128),
        Font = ok and montserrat or Enum.Font.GothamMedium,
        CornerRadius = UDim.new(0, 8),
        ElementRadius = UDim.new(0, 6),
        StrokeThickness = 1,
        Transparency = 0,
        GradientRotation = 35,
    },
}

Themes.Linoria = Themes.Default

return Themes
