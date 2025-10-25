--[[
    iOS风格按钮组件
]]

local TweenService = game:GetService("TweenService")

local Button = {}

function Button.new(parent, config)
    config = config or {}
    
    local text = config.Text or "Button"
    local callback = config.Callback or function() end
    local theme = config.Theme or _G.LoadUIModule("src/themes/iOS.lua")
    local style = config.Style or "Primary" -- Primary, Secondary, Destructive
    local size = config.Size or UDim2.new(0, 280, 0, 50)
    
    -- 按钮容器
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = size
    button.BackgroundColor3 = style == "Destructive" and theme:GetColor("Error") or theme:GetColor("Accent")
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Text = ""
    button.Parent = parent
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.CornerRadius.Medium)
    corner.Parent = button
    
    -- 文字
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = theme.FontSize.Callout
    label.Parent = button
    
    -- 按下效果
    local originalColor = button.BackgroundColor3
    local pressedColor = style == "Destructive" and theme:GetColor("Error") or theme:GetColor("AccentPressed")
    
    button.MouseButton1Down:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = pressedColor,
            Size = UDim2.new(size.X.Scale * 0.97, size.X.Offset * 0.97, size.Y.Scale * 0.97, size.Y.Offset * 0.97)
        })
        tween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
            BackgroundColor3 = originalColor,
            Size = size
        })
        tween:Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

return Button