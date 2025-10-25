--[[
    动画工具类
]]

local TweenService = game:GetService("TweenService")

local Animations = {}

function Animations.Create(instance, duration, properties, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quart
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    return tween
end

function Animations.FadeIn(instance, duration)
    instance.Visible = true
    instance.GroupTransparency = 1
    
    local tween = Animations.Create(instance, duration or 0.3, {
        GroupTransparency = 0
    })
    tween:Play()
    return tween
end

function Animations.FadeOut(instance, duration, callback)
    local tween = Animations.Create(instance, duration or 0.3, {
        GroupTransparency = 1
    })
    
    if callback then
        tween.Completed:Connect(function()
            instance.Visible = false
            callback()
        end)
    else
        tween.Completed:Connect(function()
            instance.Visible = false
        end)
    end
    
    tween:Play()
    return tween
end

function Animations.SlideIn(instance, direction, duration)
    direction = direction or "Bottom"
    duration = duration or 0.4
    
    local originalPosition = instance.Position
    local startPosition
    
    if direction == "Bottom" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 1, 0)
    elseif direction == "Top" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, -1, 0)
    elseif direction == "Left" then
        startPosition = UDim2.new(-1, 0, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif direction == "Right" then
        startPosition = UDim2.new(1, 0, originalPosition.Y.Scale, originalPosition.Y.Offset)
    end
    
    instance.Position = startPosition
    
    local tween = Animations.Create(instance, duration, {
        Position = originalPosition
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    tween:Play()
    return tween
end

function Animations.SlideOut(instance, direction, duration, callback)
    direction = direction or "Bottom"
    duration = duration or 0.3
    
    local targetPosition
    local currentPosition = instance.Position
    
    if direction == "Bottom" then
        targetPosition = UDim2.new(currentPosition.X.Scale, currentPosition.X.Offset, 1, 0)
    elseif direction == "Top" then
        targetPosition = UDim2.new(currentPosition.X.Scale, currentPosition.X.Offset, -1, 0)
    elseif direction == "Left" then
        targetPosition = UDim2.new(-1, 0, currentPosition.Y.Scale, currentPosition.Y.Offset)
    elseif direction == "Right" then
        targetPosition = UDim2.new(1, 0, currentPosition.Y.Scale, currentPosition.Y.Offset)
    end
    
    local tween = Animations.Create(instance, duration, {
        Position = targetPosition
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    tween:Play()
    return tween
end

function Animations.Spring(instance, property, targetValue, duration)
    duration = duration or 0.5
    
    local tween = Animations.Create(instance, duration, {
        [property] = targetValue
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    tween:Play()
    return tween
end

function Animations.Scale(instance, targetScale, duration)
    duration = duration or 0.2
    
    local tween = Animations.Create(instance, duration, {
        Size = targetScale
    })
    
    tween:Play()
    return tween
end

function Animations.ButtonPress(button, callback)
    local originalSize = button.Size
    
    -- 按下动画
    local pressDown = Animations.Create(button, 0.1, {
        Size = UDim2.new(originalSize.X.Scale * 0.95, 0, originalSize.Y.Scale * 0.95, 0)
    })
    
    pressDown.Completed:Connect(function()
        -- 弹起动画
        local pressUp = Animations.Create(button, 0.15, {
            Size = originalSize
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        
        pressUp:Play()
        
        if callback then
            callback()
        end
    end)
    
    pressDown:Play()
end

return Animations