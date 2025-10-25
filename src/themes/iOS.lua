--[[
    iOS 15+ 主题配置
]]

local Theme = {
    CurrentMode = "Dark",
    
    Colors = {
        Light = {
            Background = Color3.fromRGB(242, 242, 247),
            SecondaryBackground = Color3.fromRGB(255, 255, 255),
            TertiaryBackground = Color3.fromRGB(248, 248, 248),
            
            CardBackground = Color3.fromRGB(255, 255, 255),
            CardBackgroundAlpha = 0.95,
            
            PrimaryText = Color3.fromRGB(0, 0, 0),
            SecondaryText = Color3.fromRGB(60, 60, 67),
            TertiaryText = Color3.fromRGB(142, 142, 147),
            
            Accent = Color3.fromRGB(0, 122, 255),
            AccentPressed = Color3.fromRGB(0, 106, 220),
            
            Success = Color3.fromRGB(52, 199, 89),
            Warning = Color3.fromRGB(255, 149, 0),
            Error = Color3.fromRGB(255, 59, 48),
            
            Separator = Color3.fromRGB(198, 198, 200),
            
            ToggleOn = Color3.fromRGB(52, 199, 89),
            ToggleOff = Color3.fromRGB(120, 120, 128),
            
            TabBarBackground = Color3.fromRGB(248, 248, 248),
            TabBarBorder = Color3.fromRGB(216, 216, 216),
        },
        
        Dark = {
            Background = Color3.fromRGB(0, 0, 0),
            SecondaryBackground = Color3.fromRGB(28, 28, 30),
            TertiaryBackground = Color3.fromRGB(44, 44, 46),
            
            CardBackground = Color3.fromRGB(28, 28, 30),
            CardBackgroundAlpha = 0.95,
            
            PrimaryText = Color3.fromRGB(255, 255, 255),
            SecondaryText = Color3.fromRGB(235, 235, 245),
            TertiaryText = Color3.fromRGB(142, 142, 147),
            
            Accent = Color3.fromRGB(10, 132, 255),
            AccentPressed = Color3.fromRGB(8, 112, 220),
            
            Success = Color3.fromRGB(48, 209, 88),
            Warning = Color3.fromRGB(255, 159, 10),
            Error = Color3.fromRGB(255, 69, 58),
            
            Separator = Color3.fromRGB(56, 56, 58),
            
            ToggleOn = Color3.fromRGB(48, 209, 88),
            ToggleOff = Color3.fromRGB(99, 99, 102),
            
            TabBarBackground = Color3.fromRGB(20, 20, 20),
            TabBarBorder = Color3.fromRGB(40, 40, 40),
        }
    },
    
    Spacing = {
        XSmall = 4,
        Small = 8,
        Medium = 12,
        Large = 16,
        XLarge = 20,
        XXLarge = 24,
    },
    
    CornerRadius = {
        Small = 8,
        Medium = 12,
        Large = 16,
        XLarge = 20,
        Round = 999,
    },
    
    FontSize = {
        Caption = 12,
        Body = 14,
        Callout = 16,
        Headline = 18,
        Title = 22,
        LargeTitle = 28,
    },
    
    Animation = {
        Fast = 0.2,
        Standard = 0.3,
        Slow = 0.5,
        
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out,
        
        SpringEasingStyle = Enum.EasingStyle.Quint,
    },
}

function Theme:GetColor(colorName)
    local mode = self.Colors[self.CurrentMode]
    if not mode then
        return Color3.new(1, 0, 1)
    end
    
    return mode[colorName] or Color3.new(1, 0, 1)
end

function Theme:SetMode(mode)
    if mode ~= "Light" and mode ~= "Dark" then
        return
    end
    self.CurrentMode = mode
end

function Theme:Toggle()
    self.CurrentMode = self.CurrentMode == "Light" and "Dark" or "Light"
end

return Theme