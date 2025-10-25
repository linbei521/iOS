--[[
    iOS风格卡片组件
]]

local Card = {}

function Card.new(parent, config)
    config = config or {}
    
    local theme = config.Theme or _G.LoadUIModule("src/themes/iOS.lua")
    local size = config.Size or UDim2.new(1, 0, 0, 100)
    local padding = config.Padding or theme.Spacing.Large
    
    -- 卡片容器
    local card = Instance.new("Frame")
    card.Name = "Card"
    card.Size = size
    card.BackgroundColor3 = theme:GetColor("CardBackground")
    card.BorderSizePixel = 0
    card.Parent = parent
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.CornerRadius.Large)
    corner.Parent = card
    
    -- 内边距
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, padding)
    uiPadding.PaddingBottom = UDim.new(0, padding)
    uiPadding.PaddingLeft = UDim.new(0, padding)
    uiPadding.PaddingRight = UDim.new(0, padding)
    uiPadding.Parent = card
    
    -- 内容容器
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Parent = card
    
    return content
end

return Card