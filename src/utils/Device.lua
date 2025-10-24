-- Device Information
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Device = {}

function Device.getType()
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return "phone"
    elseif UserInputService.TouchEnabled and UserInputService.MouseEnabled then
        return "tablet"
    else
        return "computer"
    end
end

function Device.getScreenSize()
    local camera = workspace.CurrentCamera
    return camera.ViewportSize
end

function Device.getOrientation()
    local size = Device.getScreenSize()
    return size.X > size.Y and "landscape" or "portrait"
end

function Device.hasNotch()
    -- Check for iPhone X-style notch
    local insets = GuiService:GetGuiInset()
    return insets.Y > 20
end

function Device.getStatusBarHeight()
    local insets = GuiService:GetGuiInset()
    return insets.Y
end

function Device.supportsHaptic()
    -- Check if device supports haptic feedback
    return UserInputService.TouchEnabled
end

return Device