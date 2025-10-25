--[[
    屏幕适配工具
]]

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local ScreenAdapter = {}

function ScreenAdapter.GetScreenSize()
    local camera = workspace.CurrentCamera
    return camera.ViewportSize
end

function ScreenAdapter.IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function ScreenAdapter.IsTablet()
    if not ScreenAdapter.IsMobile() then
        return false
    end
    
    local screenSize = ScreenAdapter.GetScreenSize()
    local minDimension = math.min(screenSize.X, screenSize.Y)
    
    -- 平板通常有更大的屏幕
    return minDimension >= 600
end

function ScreenAdapter.ApplySafeArea(container)
    -- 获取安全区域插入
    local safeInsets = GuiService:GetGuiInset()
    
    -- 应用UIPadding
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, safeInsets.Y)
    padding.PaddingBottom = UDim.new(0, 0)
    padding.Parent = container
    
    return padding
end

function ScreenAdapter.GetScaleFactor()
    local screenSize = ScreenAdapter.GetScreenSize()
    local baseWidth = 375 -- iPhone标准宽度
    
    return screenSize.X / baseWidth
end

function ScreenAdapter.ScaleSize(baseSize)
    local scale = ScreenAdapter.GetScaleFactor()
    return baseSize * scale
end

return ScreenAdapter