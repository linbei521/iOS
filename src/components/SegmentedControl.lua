--[[
    iOS风格分段控制器
]]

local TweenService = game:GetService("TweenService")

local SegmentedControl = {}

function SegmentedControl.new(parent, config)
    config = config or {}
    
    local segments = config.Segments or {"Option 1", "Option 2"}
    local default = config.Default or 1
    local callback = config.Callback or function() end
    local theme = config.Theme or _G.LoadUIModule("src/themes/iOS.lua")
    
    -- 容器
    local container = Instance.new("Frame")
    container.Name = "SegmentedControl"
    container.Size = UDim2.new(1, 0, 0, 32)
    container.BackgroundColor3 = theme:GetColor("TertiaryBackground")
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.CornerRadius.Small)
    corner.Parent = container
    
    -- 布局
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 2)
    layout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 2)
    padding.PaddingBottom = UDim.new(0, 2)
    padding.PaddingLeft = UDim.new(0, 2)
    padding.PaddingRight = UDim.new(0, 2)
    padding.Parent = container
    
    -- 选中指示器
    local selector = Instance.new("Frame")
    selector.Name = "Selector"
    selector.Size = UDim2.new(1 / #segments, -2, 1, -4)
    selector.BackgroundColor3 = theme:GetColor("CardBackground")
    selector.BorderSizePixel = 0
    selector.ZIndex = 1
    
    local selectorCorner = Instance.new("UICorner")
    selectorCorner.CornerRadius = UDim.new(0, theme.CornerRadius.Small - 2)
    selectorCorner.Parent = selector
    
    local currentIndex = default
    
    -- 创建分段
    for i, segmentText in ipairs(segments) do
        local segment = Instance.new("TextButton")
        segment.Name = "Segment" .. i
        segment.Size = UDim2.new(1 / #segments, -2, 1, -4)
        segment.BackgroundTransparency = 1
        segment.Text = segmentText
        segment.TextColor3 = i == default and theme:GetColor("PrimaryText") or theme:GetColor("TertiaryText")
        segment.Font = Enum.Font.GothamMedium
        segment.TextSize = theme.FontSize.Body
        segment.ZIndex = 2
        segment.Parent = container
        
        segment.MouseButton1Click:Connect(function()
            if currentIndex == i then return end
            
            currentIndex = i
            
            -- 移动选中指示器
            if not selector.Parent then
                selector.Parent = container
            end
            
            local targetPos = UDim2.new((i - 1) / #segments, 2, 0, 2)
            TweenService:Create(selector, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                Position = targetPos
            }):Play()
            
            -- 更新文字颜色
            for j, child in ipairs(container:GetChildren()) do
                if child:IsA("TextButton") then
                    local textColor = child == segment and theme:GetColor("PrimaryText") or theme:GetColor("TertiaryText")
                    TweenService:Create(child, TweenInfo.new(0.2), {
                        TextColor3 = textColor
                    }):Play()
                end
            end
            
            callback(i, segmentText)
        end)
    end
    
    -- 设置初始位置
    selector.Position = UDim2.new((default - 1) / #segments, 2, 0, 2)
    selector.Parent = container
    
    return container
end

return SegmentedControl