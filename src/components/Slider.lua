--[[
    iOS风格滑块组件
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Slider = {}

function Slider.new(parent, config)
    config = config or {}
    
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback or function() end
    local theme = config.Theme or _G.LoadUIModule("src/themes/iOS.lua")
    
    -- 容器
    local container = Instance.new("Frame")
    container.Name = "SliderContainer"
    container.Size = UDim2.new(1, 0, 0, 70)
    container.BackgroundColor3 = theme:GetColor("CardBackground")
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.CornerRadius.Medium)
    corner.Parent = container
    
    -- 标签
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 25)
    label.Position = UDim2.new(0, theme.Spacing.Large, 0, theme.Spacing.Small)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme:GetColor("PrimaryText")
    label.Font = Enum.Font.Gotham
    label.TextSize = theme.FontSize.Body
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- 数值显示
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -theme.Spacing.Large, 0, 25)
    valueLabel.Position = UDim2.new(0.7, 0, 0, theme.Spacing.Small)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = theme:GetColor("Accent")
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.TextSize = theme.FontSize.Body
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    -- 滑块轨道
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -theme.Spacing.Large * 2, 0, 4)
    track.Position = UDim2.new(0, theme.Spacing.Large, 0, 45)
    track.BackgroundColor3 = theme:GetColor("Separator")
    track.BorderSizePixel = 0
    track.Parent = container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    -- 填充进度
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = theme:GetColor("Accent")
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    -- 滑块按钮
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.Parent = track
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    -- 阴影
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Transparency = 0.8
    shadow.Thickness = 2
    shadow.Parent = thumb
    
    -- 拖动逻辑
    local dragging = false
    local currentValue = default
    
    local function updateSlider(input)
        local trackPos = track.AbsolutePosition.X
        local trackSize = track.AbsoluteSize.X
        local mousePos = input.Position.X
        
        local relativePos = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
        currentValue = math.floor(min + (max - min) * relativePos)
        
        fill.Size = UDim2.new(relativePos, 0, 1, 0)
        thumb.Position = UDim2.new(relativePos, -10, 0.5, -10)
        valueLabel.Text = tostring(currentValue)
        
        callback(currentValue)
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            TweenService:Create(thumb, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 24, 0, 24)
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(thumb, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 20, 0, 20)
            }):Play()
        end
    end)
    
    return container
end

return Slider