-- iOS Spring Animations
local TweenService = game:GetService("TweenService")

local Spring = {}

function Spring.animate(target, properties, options)
    options = options or {}
    
    local duration = options.duration or 0.3
    local damping = options.damping or 1
    local initialVelocity = options.initialVelocity or 0
    local completion = options.completion
    
    -- Convert spring parameters to TweenInfo
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    -- Apply properties
    for key, value in pairs(properties) do
        if key == "transform" then
            -- Handle transform separately
            Spring.animateTransform(target, value, tweenInfo)
        elseif key == "backgroundColor" then
            -- Animate color
            Spring.animateColor(target, value, tweenInfo)
        else
            -- Direct property animation
            target[key] = value
        end
    end
    
    -- Call completion after duration
    if completion then
        task.wait(duration)
        completion()
    end
end

function Spring.animateTransform(target, transform, tweenInfo)
    -- Apply transform properties
    if transform.scaleX then
        target.transform.scaleX = transform.scaleX
    end
    if transform.scaleY then
        target.transform.scaleY = transform.scaleY
    end
    if transform.rotation then
        target.transform.rotation = transform.rotation
    end
    
    target:setNeedsDisplay()
end

function Spring.animateColor(target, color, tweenInfo)
    -- Animate color transition
    target.backgroundColor = color
    target:setNeedsDisplay()
end

return Spring