--[[
    iOS风格开关组件
]]

local TweenService = game:GetService("TweenService")

local Toggle = {}

function Toggle.new(parent, config)
    config = config or {}
    
    local text = config.Text or "Toggle"
    local defaultValue = config.Default or false
    local callback = config.Callback or function() end
    local theme = config.Theme or _G.LoadUIModule("src/themes/iOS.lua")
    
    -- 容器
    local container = Instance.new("Frame")
    container.Name = "ToggleContainer"
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = theme:GetColor("CardBackground")
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.CornerRadius.Medium)
    corner.Parent = container
    
    -- 文字标签
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, theme.Spacing.Large, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme:GetColor("PrimaryText")
    label.Font = Enum.Font.Gotham
    label.TextSize = theme.FontSize.Body
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- 开关背景
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 51, 0, 31)
    switchBg.Position = UDim2.new(1, -theme.Spacing.Large - 51, 0.5, -15.5)
    switchBg.BackgroundColor3 = defaultValue and theme:GetColor("ToggleOn") or theme:GetColor("ToggleOff")
    switchBg.BorderSizePixel = 0
    switchBg.Parent = container
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg
    
    -- 开关按钮
    local switchButton = Instance.new("Frame")
    switchButton.Size = UDim2.new(0, 27, 0, 27)
    switchButton.Position = defaultValue and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
    switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchButton.BorderSizePixel = 0
    switchButton.Parent = switchBg
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = switchButton
    
    -- 阴影效果
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = switchButton
    
    -- 状态
    local isOn = defaultValue
    
    -- 点击事件
    local clickButton = Instance.new("TextButton")
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = container
    
    clickButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        
        local bgColor = isOn and theme:GetColor("ToggleOn") or theme:GetColor("ToggleOff")
        local buttonPos = isOn and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
        
        TweenService:Create(switchBg, TweenInfo.new(0.2), {
            BackgroundColor3 = bgColor
        }):Play()
        
        TweenService:Create(switchButton, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = buttonPos
        }):Play()
        
        callback(isOn)
    end)
    
    return container
end

return Toggle