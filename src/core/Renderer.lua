-- Rendering engine for iOS UI
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(window, screenGui)
    local self = setmetatable({}, Renderer)
    
    self.window = window
    self.screenGui = screenGui
    self.renderConnection = nil
    self.guiCache = {}
    
    return self
end

function Renderer:createGui(view)
    local gui
    
    if view._gui then
        gui = view._gui
    else
        gui = Instance.new("Frame")
        view._gui = gui
        self.guiCache[view] = gui
    end
    
    -- Position and size
    gui.Position = UDim2.new(0, view.frame.x, 0, view.frame.y)
    gui.Size = UDim2.new(0, view.frame.width, 0, view.frame.height)
    
    -- Appearance
    local bgColor = view.backgroundColor
    gui.BackgroundColor3 = Color3.new(bgColor.r, bgColor.g, bgColor.b)
    gui.BackgroundTransparency = 1 - (bgColor.a * view.alpha)
    
    -- Border
    if view.borderWidth > 0 then
        gui.BorderSizePixel = view.borderWidth
        gui.BorderColor3 = Color3.new(view.borderColor.r, view.borderColor.g, view.borderColor.b)
    else
        gui.BorderSizePixel = 0
    end
    
    -- Corner radius
    if view.cornerRadius > 0 then
        local corner = gui:FindFirstChild("UICorner")
        if not corner then
            corner = Instance.new("UICorner")
            corner.Parent = gui
        end
        corner.CornerRadius = UDim.new(0, view.cornerRadius)
    end
    
    -- Shadow
    if view.shadowOpacity > 0 then
        local shadow = gui:FindFirstChild("Shadow")
        if not shadow then
            shadow = Instance.new("ImageLabel")
            shadow.Name = "Shadow"
            shadow.BackgroundTransparency = 1
            shadow.Image = "rbxasset://textures/ui/Shadow.png"
            shadow.ImageColor3 = Color3.new(view.shadowColor.r, view.shadowColor.g, view.shadowColor.b)
            shadow.ImageTransparency = 1 - view.shadowOpacity
            shadow.Position = UDim2.new(0, view.shadowOffset.width - view.shadowRadius, 0, view.shadowOffset.height - view.shadowRadius)
            shadow.Size = UDim2.new(1, view.shadowRadius * 2, 1, view.shadowRadius * 2)
            shadow.ZIndex = gui.ZIndex - 1
            shadow.Parent = gui.Parent
        end
    end
    
    -- Visibility
    gui.Visible = not view.hidden
    
    -- Clipping
    gui.ClipsDescendants = view.clipsToBounds
    
    return gui
end

function Renderer:renderView(view, parentGui)
    if view.hidden then
        if view._gui then
            view._gui.Visible = false
        end
        return
    end
    
    local gui = self:createGui(view)
    gui.Parent = parentGui
    
    -- Render subviews
    for _, subview in ipairs(view.subviews) do
        self:renderView(subview, gui)
    end
    
    view._needsDisplay = false
end

function Renderer:render()
    -- Start render loop
    if self.renderConnection then
        self.renderConnection:Disconnect()
    end
    
    self.renderConnection = RunService.Heartbeat:Connect(function()
        if self.window._needsDisplay or self.window._needsLayout then
            self.window:layoutIfNeeded()
            self:renderView(self.window, self.screenGui)
        end
    end)
    
    -- Initial render
    self:renderView(self.window, self.screenGui)
end

function Renderer:stop()
    if self.renderConnection then
        self.renderConnection:Disconnect()
        self.renderConnection = nil
    end
end

return Renderer