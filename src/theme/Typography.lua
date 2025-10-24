-- iOS Typography System
local Typography = {
    regular = {
        -- Title styles
        largeTitle = {family = "SF Pro Display", size = 34, weight = "regular"},
        title1 = {family = "SF Pro Display", size = 28, weight = "regular"},
        title2 = {family = "SF Pro Display", size = 22, weight = "regular"},
        title3 = {family = "SF Pro Display", size = 20, weight = "regular"},
        
        -- Body styles
        headline = {family = "SF Pro Text", size = 17, weight = "semibold"},
        body = {family = "SF Pro Text", size = 17, weight = "regular"},
        bodyBold = {family = "SF Pro Text", size = 17, weight = "semibold"},
        callout = {family = "SF Pro Text", size = 16, weight = "regular"},
        subheadline = {family = "SF Pro Text", size = 15, weight = "regular"},
        footnote = {family = "SF Pro Text", size = 13, weight = "regular"},
        caption1 = {family = "SF Pro Text", size = 12, weight = "regular"},
        caption2 = {family = "SF Pro Text", size = 11, weight = "regular"}
    }
}

-- Map to Roblox fonts
Typography.robloxFontMap = {
    ["SF Pro Display"] = "Gotham",
    ["SF Pro Text"] = "Gotham",
    ["SF Pro"] = "Gotham"
}

return Typography