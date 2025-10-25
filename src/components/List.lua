--[[
    iOS风格列表组件
]]

local List = {}

function List.new(parent, config)
    config = config or {}
    
    local theme = config.Theme or _G.LoadUIModule("src/themes/iOS.lua")
    local size = config.Size or UDim2.new(1, 0, 1, 0)
    
    -- 滚动框架
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "List"
    scrollFrame.Size = size
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = theme:GetColor("TertiaryText")
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = parent
    
    -- 列表布局
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, theme.Spacing.Small)
    listLayout.Parent = scrollFrame
    
    -- 内边距
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, theme.Spacing.Medium)
    padding.PaddingBottom = UDim.new(0, theme.Spacing.Medium)
    padding.PaddingLeft = UDim.new(0, theme.Spacing.Large)
    padding.PaddingRight = UDim.new(0, theme.Spacing.Large)
    padding.Parent = scrollFrame
    
    return scrollFrame
end

return List