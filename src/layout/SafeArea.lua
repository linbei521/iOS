-- iOS Safe Area
local GuiService = game:GetService("GuiService")

local SafeArea = {}

function SafeArea.getInsets()
    local insets = GuiService:GetGuiInset()
    
    return {
        top = insets.Y,
        bottom = 0, -- Roblox doesn't have bottom safe area
        left = 0,
        right = 0
    }
end

function SafeArea.getSafeFrame(fullFrame)
    local insets = SafeArea.getInsets()
    
    return {
        x = fullFrame.x + insets.left,
        y = fullFrame.y + insets.top,
        width = fullFrame.width - insets.left - insets.right,
        height = fullFrame.height - insets.top - insets.bottom
    }
end

return SafeArea