-- iOS UI 简化版 - 单文件加载器
local iOSUI = {}

-- ============ Colors ============
iOSUI.Colors = {
    -- System Colors
    systemBlue = {r = 0, g = 0.478, b = 1, a = 1},
    systemGreen = {r = 0.204, g = 0.78, b = 0.349, a = 1},
    systemRed = {r = 1, g = 0.231, b = 0.188, a = 1},
    systemGray = {r = 0.557, g = 0.557, b = 0.576, a = 1},
    systemGray5 = {r = 0.898, g = 0.898, b = 0.918, a = 1},
    systemGray6 = {r = 0.949, g = 0.949, b = 0.969, a = 1},
    label = {r = 0, g = 0, b = 0, a = 1},
    systemBackground = {r = 1, g = 1, b = 1, a = 1},
    white = {r = 1, g = 1, b = 1, a = 1},
    clear = {r = 0, g = 0, b = 0, a = 0}
}

-- ============ View ============
local View = {}
View.__index = View

function View.new(frame)
    local self = setmetatable({}, View)
    self.frame = frame or {x = 0, y = 0, width = 100, height = 50}
    self.backgroundColor = iOSUI.Colors.white
    self.cornerRadius = 0
    self.alpha = 1
    self.hidden = false
    self.subviews = {}
    self.superview = nil
    self._gui = nil
    return self
end

function View:addSubview(view)
    table.insert(self.subviews, view)
    view.superview = self
end

iOSUI.View = View

-- ============ Window ============
local Window = {}
Window.__index = Window
setmetatable(Window, {__index = View})

function Window.new()
    local self = setmetatable(View.new(), Window)
    
    -- Create ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "iOSUI_" .. tostring(math.random(1000, 9999))
    self.screenGui.ResetOnSpawn = false
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Get screen size
    local viewport = workspace.CurrentCamera.ViewportSize
    self.frame = {
        x = 0,
        y = 0,
        width = viewport.X,
        height = viewport.Y
    }
    
    return self
end

function Window:present()
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    self.screenGui.Parent = playerGui
    self:render()
end

function Window:render()
    for _, subview in ipairs(self.subviews) do
        self:renderView(subview, self.screenGui)
    end
end

function Window:renderView(view, parent)
    if view.hidden then return end
    
    local gui = Instance.new("Frame")
    gui.Name = "View"
    gui.Position = UDim2.new(0, view.frame.x, 0, view.frame.y)
    gui.Size = UDim2.new(0, view.frame.width, 0, view.frame.height)
    gui.BackgroundColor3 = Color3.new(
        view.backgroundColor.r,
        view.backgroundColor.g,
        view.backgroundColor.b
    )
    gui.BackgroundTransparency = 1 - (view.backgroundColor.a * view.alpha)
    gui.BorderSizePixel = 0
    gui.Parent = parent
    
    if view.cornerRadius > 0 then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, view.cornerRadius)
        corner.Parent = gui
    end
    
    view._gui = gui
    
    for _, subview in ipairs(view.subviews) do
        self:renderView(subview, gui)
    end
end

iOSUI.Window = Window

-- ============ Button ============
local Button = {}
Button.__index = Button
setmetatable(Button, {__index = View})

function Button.new(title)
    local self = setmetatable(View.new(), Button)
    
    self.title = title or "Button"
    self.titleColor = iOSUI.Colors.systemBlue
    self.backgroundColor = iOSUI.Colors.systemGray6
    self.cornerRadius = 8
    self.enabled = true
    self.onTap = nil
    
    self.frame = {x = 0, y = 0, width = 200, height = 44}
    
    return self
end

function Button:render(parent)
    -- Create button GUI
    local gui = Instance.new("TextButton")
    gui.Name = "Button"
    gui.Position = UDim2.new(0, self.frame.x, 0, self.frame.y)
    gui.Size = UDim2.new(0, self.frame.width, 0, self.frame.height)
    gui.BackgroundColor3 = Color3.new(
        self.backgroundColor.r,
        self.backgroundColor.g,
        self.backgroundColor.b
    )
    gui.Text = self.title
    gui.TextColor3 = Color3.new(
        self.titleColor.r,
        self.titleColor.g,
        self.titleColor.b
    )
    gui.Font = Enum.Font.GothamMedium
    gui.TextSize = 17
    gui.BorderSizePixel = 0
    gui.Parent = parent
    
    if self.cornerRadius > 0 then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, self.cornerRadius)
        corner.Parent = gui
    end
    
    -- Click handler
    gui.MouseButton1Click:Connect(function()
        if self.enabled and self.onTap then
            self.onTap()
        end
    end)
    
    -- Hover effect
    gui.MouseEnter:Connect(function()
        if self.enabled then
            gui.BackgroundColor3 = Color3.new(0.8, 0.8, 0.82)
        end
    end)
    
    gui.MouseLeave:Connect(function()
        gui.BackgroundColor3 = Color3.new(
            self.backgroundColor.r,
            self.backgroundColor.g,
            self.backgroundColor.b
        )
    end)
    
    self._gui = gui
end

iOSUI.Button = Button

print("✅ iOS UI Library (Simple) loaded!")
return iOSUI