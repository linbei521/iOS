-- Haptic Feedback
local HapticService = game:GetService("HapticService")
local UserInputService = game:GetService("UserInputService")

local Haptic = {}

function Haptic.impact(style)
    if not UserInputService.TouchEnabled then return end
    
    -- Style: "light", "medium", "heavy"
    local motorValue = 0
    if style == "light" then
        motorValue = 0.3
    elseif style == "medium" then
        motorValue = 0.5
    elseif style == "heavy" then
        motorValue = 0.8
    end
    
    pcall(function()
        HapticService:SetMotor(Enum.UserInputType.Touch, Enum.VibrationMotor.Large, motorValue)
        task.wait(0.1)
        HapticService:SetMotor(Enum.UserInputType.Touch, Enum.VibrationMotor.Large, 0)
    end)
end

function Haptic.selection()
    Haptic.impact("light")
end

function Haptic.notification(type)
    -- Type: "success", "warning", "error"
    if type == "success" then
        Haptic.impact("medium")
    elseif type == "warning" then
        Haptic.impact("medium")
        task.wait(0.1)
        Haptic.impact("light")
    elseif type == "error" then
        Haptic.impact("heavy")
    end
end

return Haptic