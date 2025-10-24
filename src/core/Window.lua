-- iOS Window implementation
local View = require(script.Parent.View)
local Renderer = require(script.Parent.Renderer)
local SafeArea = require(script.Parent.Parent.layout.SafeArea)

local Window = {}
Window.__index = Window
setmetatable(Window, {__index = View})

function Window.new()
    local self = setmetatable(View.new(), Window)
    
    -- Get screen size
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "iOSUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Set window to full screen
    self.frame = {
        x = 0,
        y = 0,
        width = screenGui.AbsoluteSize.X,
        height = screenGui.AbsoluteSize.Y
    }
    
    -- iOS window properties
    self.rootViewController = nil
    self.windowLevel = 0
    self.screen = screenGui
    self.keyWindow = true
    
    -- Safe area
    self.safeAreaInsets = SafeArea.getInsets()
    
    -- Renderer
    self.renderer = Renderer.new(self, screenGui)
    
    -- Handle screen size changes
    screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self.frame.width = screenGui.AbsoluteSize.X
        self.frame.height = screenGui.AbsoluteSize.Y
        self:setNeedsLayout()
        self:layoutIfNeeded()
    end)
    
    return self
end

function Window:makeKeyAndVisible()
    self.hidden = false
    self.keyWindow = true
    if self.screen.Parent == nil then
        self.screen.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    self.renderer:render()
end

function Window:present()
    self:makeKeyAndVisible()
end

function Window:dismiss()
    self.hidden = true
    if self.screen then
        self.screen.Parent = nil
    end
end

function Window:setRootViewController(viewController)
    self.rootViewController = viewController
    if viewController and viewController.view then
        self:addSubview(viewController.view)
        viewController.view.frame = {
            x = 0,
            y = 0,
            width = self.frame.width,
            height = self.frame.height
        }
    end
end

return Window