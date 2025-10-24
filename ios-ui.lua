--[[
    iOS UI Library for Roblox
    单文件完整版 - 无需额外依赖
    使用方法：
    local iOSUI = loadstring(game:HttpGet("你的URL"))()
]]--

local iOSUI = {
    VERSION = "1.0.0"
}

-- ==================== 颜色系统 ====================
iOSUI.Colors = {
    -- 系统颜色
    systemBlue = Color3.fromRGB(0, 122, 255),
    systemGreen = Color3.fromRGB(52, 199, 89),
    systemIndigo = Color3.fromRGB(88, 86, 214),
    systemOrange = Color3.fromRGB(255, 149, 0),
    systemPink = Color3.fromRGB(255, 45, 85),
    systemPurple = Color3.fromRGB(175, 82, 222),
    systemRed = Color3.fromRGB(255, 59, 48),
    systemTeal = Color3.fromRGB(90, 200, 250),
    systemYellow = Color3.fromRGB(255, 204, 0),
    
    -- 灰度颜色
    systemGray = Color3.fromRGB(142, 142, 147),
    systemGray2 = Color3.fromRGB(174, 174, 178),
    systemGray3 = Color3.fromRGB(199, 199, 204),
    systemGray4 = Color3.fromRGB(209, 209, 214),
    systemGray5 = Color3.fromRGB(229, 229, 234),
    systemGray6 = Color3.fromRGB(242, 242, 247),
    
    -- 标签颜色
    label = Color3.fromRGB(0, 0, 0),
    secondaryLabel = Color3.fromRGB(60, 60, 67),
    tertiaryLabel = Color3.fromRGB(72, 72, 74),
    
    -- 背景颜色
    systemBackground = Color3.fromRGB(255, 255, 255),
    secondarySystemBackground = Color3.fromRGB(242, 242, 247),
    tertiarySystemBackground = Color3.fromRGB(255, 255, 255),
    
    -- 特殊颜色
    white = Color3.fromRGB(255, 255, 255),
    black = Color3.fromRGB(0, 0, 0),
    clear = Color3.fromRGB(0, 0, 0)
}

-- ==================== 工具函数 ====================
local function createCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

local function createStroke(color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    return stroke
end

-- ==================== 窗口类 ====================
iOSUI.Window = {}
iOSUI.Window.__index = iOSUI.Window

function iOSUI.Window.new()
    local self = setmetatable({}, iOSUI.Window)
    
    -- 创建 ScreenGui
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "iOSUI_" .. tostring(math.random(100000, 999999))
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.DisplayOrder = 999
    
    -- 获取屏幕大小
    local camera = workspace.CurrentCamera
    self.screenSize = camera.ViewportSize
    
    -- 存储子元素
    self.elements = {}
    
    return self
end

function iOSUI.Window:Show()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    self.gui.Parent = playerGui
    print("✅ iOS UI 窗口已显示")
    return self
end

function iOSUI.Window:Hide()
    self.gui.Parent = nil
    return self
end

function iOSUI.Window:Destroy()
    self.gui:Destroy()
end

function iOSUI.Window:AddElement(element)
    table.insert(self.elements, element)
    element.Parent = self.gui
    return self
end

-- ==================== 容器类 ====================
iOSUI.Container = {}
iOSUI.Container.__index = iOSUI.Container

function iOSUI.Container.new(options)
    local self = setmetatable({}, iOSUI.Container)
    options = options or {}
    
    -- 创建主容器
    self.frame = Instance.new("Frame")
    self.frame.Name = options.name or "Container"
    self.frame.Size = options.size or UDim2.new(0, 350, 0, 500)
    self.frame.Position = options.position or UDim2.new(0.5, -175, 0.5, -250)
    self.frame.BackgroundColor3 = options.backgroundColor or iOSUI.Colors.systemBackground
    self.frame.BorderSizePixel = 0
    self.frame.BackgroundTransparency = options.transparency or 0
    
    -- 圆角
    if options.cornerRadius then
        createCorner(options.cornerRadius).Parent = self.frame
    end
    
    -- 阴影效果
    if options.shadow then
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.ImageTransparency = 0.7
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.new(0, -10, 0, -10)
        shadow.ZIndex = self.frame.ZIndex - 1
        shadow.Parent = self.frame
    end
    
    -- 使容器可拖动
    if options.draggable then
        self:MakeDraggable()
    end
    
    return self
end

function iOSUI.Container:MakeDraggable()
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput, mousePos, framePos
    
    self.frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = self.frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            self.frame.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

function iOSUI.Container:AddChild(element)
    element.Parent = self.frame
    return self
end

-- ==================== 按钮类 ====================
iOSUI.Button = {}
iOSUI.Button.__index = iOSUI.Button

function iOSUI.Button.new(options)
    local self = setmetatable({}, iOSUI.Button)
    options = options or {}
    
    -- 创建按钮
    self.button = Instance.new("TextButton")
    self.button.Name = options.name or "Button"
    self.button.Size = options.size or UDim2.new(0, 200, 0, 44)
    self.button.Position = options.position or UDim2.new(0, 0, 0, 0)
    self.button.BackgroundColor3 = options.backgroundColor or iOSUI.Colors.systemBlue
    self.button.BorderSizePixel = 0
    self.button.Text = options.text or "Button"
    self.button.TextColor3 = options.textColor or iOSUI.Colors.white
    self.button.Font = Enum.Font.GothamMedium
    self.button.TextSize = options.textSize or 17
    self.button.AutoButtonColor = false
    
    -- 圆角
    createCorner(options.cornerRadius or 8).Parent = self.button
    
    -- 回调函数
    self.callback = options.callback
    
    -- 点击效果
    self.button.MouseButton1Click:Connect(function()
        self:Click()
    end)
    
    -- 悬停效果
    self.button.MouseEnter:Connect(function()
        self:Hover(true)
    end)
    
    self.button.MouseLeave:Connect(function()
        self:Hover(false)
    end)
    
    return self
end

function iOSUI.Button:Click()
    -- 点击动画
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- 缩小
    local shrink = TweenService:Create(self.button, tweenInfo, {
        Size = UDim2.new(
            self.button.Size.X.Scale, self.button.Size.X.Offset - 4,
            self.button.Size.Y.Scale, self.button.Size.Y.Offset - 4
        )
    })
    
    shrink:Play()
    shrink.Completed:Wait()
    
    -- 恢复
    local grow = TweenService:Create(self.button, tweenInfo, {
        Size = UDim2.new(
            self.button.Size.X.Scale, self.button.Size.X.Offset + 4,
            self.button.Size.Y.Scale, self.button.Size.Y.Offset + 4
        )
    })
    
    grow:Play()
    
    -- 执行回调
    if self.callback then
        self.callback()
    end
end

function iOSUI.Button:Hover(isHovering)
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    
    if isHovering then
        local tween = TweenService:Create(self.button, tweenInfo, {
            BackgroundTransparency = 0.2
        })
        tween:Play()
    else
        local tween = TweenService:Create(self.button, tweenInfo, {
            BackgroundTransparency = 0
        })
        tween:Play()
    end
end

-- ==================== 文本标签类 ====================
iOSUI.Label = {}
iOSUI.Label.__index = iOSUI.Label

function iOSUI.Label.new(options)
    local self = setmetatable({}, iOSUI.Label)
    options = options or {}
    
    self.label = Instance.new("TextLabel")
    self.label.Name = options.name or "Label"
    self.label.Size = options.size or UDim2.new(0, 200, 0, 30)
    self.label.Position = options.position or UDim2.new(0, 0, 0, 0)
    self.label.BackgroundTransparency = options.transparency or 1
    self.label.Text = options.text or "Label"
    self.label.TextColor3 = options.textColor or iOSUI.Colors.label
    self.label.Font = options.font or Enum.Font.GothamMedium
    self.label.TextSize = options.textSize or 17
    self.label.TextXAlignment = options.alignment or Enum.TextXAlignment.Center
    
    return self
end

-- ==================== 文本框类 ====================
iOSUI.TextField = {}
iOSUI.TextField.__index = iOSUI.TextField

function iOSUI.TextField.new(options)
    local self = setmetatable({}, iOSUI.TextField)
    options = options or {}
    
    self.textBox = Instance.new("TextBox")
    self.textBox.Name = options.name or "TextField"
    self.textBox.Size = options.size or UDim2.new(0, 200, 0, 44)
    self.textBox.Position = options.position or UDim2.new(0, 0, 0, 0)
    self.textBox.BackgroundColor3 = options.backgroundColor or iOSUI.Colors.secondarySystemBackground
    self.textBox.BorderSizePixel = 0
    self.textBox.Text = options.text or ""
    self.textBox.PlaceholderText = options.placeholder or "Enter text..."
    self.textBox.TextColor3 = options.textColor or iOSUI.Colors.label
    self.textBox.PlaceholderColor3 = iOSUI.Colors.tertiaryLabel
    self.textBox.Font = Enum.Font.Gotham
    self.textBox.TextSize = options.textSize or 17
    self.textBox.ClearTextOnFocus = false
    
    -- 圆角
    createCorner(options.cornerRadius or 8).Parent = self.textBox
    
    -- 内边距
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = self.textBox
    
    return self
end

function iOSUI.TextField:GetText()
    return self.textBox.Text
end

function iOSUI.TextField:SetText(text)
    self.textBox.Text = text
end

-- ==================== 开关类 ====================
iOSUI.Switch = {}
iOSUI.Switch.__index = iOSUI.Switch

function iOSUI.Switch.new(options)
    local self = setmetatable({}, iOSUI.Switch)
    options = options or {}
    
    self.enabled = options.enabled or false
    self.callback = options.callback
    
    -- 背景
    self.background = Instance.new("TextButton")
    self.background.Name = options.name or "Switch"
    self.background.Size = UDim2.new(0, 51, 0, 31)
    self.background.Position = options.position or UDim2.new(0, 0, 0, 0)
    self.background.BackgroundColor3 = self.enabled and iOSUI.Colors.systemGreen or iOSUI.Colors.systemGray5
    self.background.BorderSizePixel = 0
    self.background.Text = ""
    self.background.AutoButtonColor = false
    
    createCorner(15.5).Parent = self.background
    
    -- 滑块
    self.thumb = Instance.new("Frame")
    self.thumb.Size = UDim2.new(0, 27, 0, 27)
    self.thumb.Position = self.enabled and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
    self.thumb.BackgroundColor3 = iOSUI.Colors.white
    self.thumb.BorderSizePixel = 0
    self.thumb.Parent = self.background
    
    createCorner(13.5).Parent = self.thumb
    
    -- 阴影
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Transparency = 0.9
    shadow.Thickness = 1
    shadow.Parent = self.thumb
    
    -- 点击事件
    self.background.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    return self
end

function iOSUI.Switch:Toggle()
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    self.enabled = not self.enabled
    
    -- 动画切换
    if self.enabled then
        TweenService:Create(self.thumb, tweenInfo, {
            Position = UDim2.new(0, 22, 0, 2)
        }):Play()
        
        TweenService:Create(self.background, tweenInfo, {
            BackgroundColor3 = iOSUI.Colors.systemGreen
        }):Play()
    else
        TweenService:Create(self.thumb, tweenInfo, {
            Position = UDim2.new(0, 2, 0, 2)
        }):Play()
        
        TweenService:Create(self.background, tweenInfo, {
            BackgroundColor3 = iOSUI.Colors.systemGray5
        }):Play()
    end
    
    -- 触觉反馈
    local HapticService = game:GetService("HapticService")
    pcall(function()
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0.5)
        wait(0.05)
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
    end)
    
    -- 回调
    if self.callback then
        self.callback(self.enabled)
    end
end

-- ==================== 导航栏类 ====================
iOSUI.NavigationBar = {}
iOSUI.NavigationBar.__index = iOSUI.NavigationBar

function iOSUI.NavigationBar.new(options)
    local self = setmetatable({}, iOSUI.NavigationBar)
    options = options or {}
    
    -- 导航栏容器
    self.frame = Instance.new("Frame")
    self.frame.Name = "NavigationBar"
    self.frame.Size = UDim2.new(1, 0, 0, 60)
    self.frame.Position = UDim2.new(0, 0, 0, 0)
    self.frame.BackgroundColor3 = options.backgroundColor or iOSUI.Colors.systemBackground
    self.frame.BorderSizePixel = 0
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 200, 0, 30)
    title.Position = UDim2.new(0.5, -100, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = options.title or "Title"
    title.TextColor3 = iOSUI.Colors.label
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = self.frame
    
    -- 底部分隔线
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 1, -1)
    separator.BackgroundColor3 = iOSUI.Colors.systemGray5
    separator.BorderSizePixel = 0
    separator.Parent = self.frame
    
    return self
end

-- ==================== 提示框类 ====================
iOSUI.Alert = {}
iOSUI.Alert.__index = iOSUI.Alert

function iOSUI.Alert.new(options)
    local self = setmetatable({}, iOSUI.Alert)
    options = options or {}
    
    -- 背景遮罩
    self.overlay = Instance.new("Frame")
    self.overlay.Name = "AlertOverlay"
    self.overlay.Size = UDim2.new(1, 0, 1, 0)
    self.overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.overlay.BackgroundTransparency = 0.5
    self.overlay.BorderSizePixel = 0
    self.overlay.ZIndex = 10
    
    -- 提示框容器
    self.container = Instance.new("Frame")
    self.container.Size = UDim2.new(0, 270, 0, 150)
    self.container.Position = UDim2.new(0.5, -135, 0.5, -75)
    self.container.BackgroundColor3 = iOSUI.Colors.systemBackground
    self.container.BorderSizePixel = 0
    self.container.ZIndex = 11
    self.container.Parent = self.overlay
    
    createCorner(14).Parent = self.container
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -32, 0, 25)
    title.Position = UDim2.new(0, 16, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = options.title or "Alert"
    title.TextColor3 = iOSUI.Colors.label
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.ZIndex = 12
    title.Parent = self.container
    
    -- 消息
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -32, 0, 40)
    message.Position = UDim2.new(0, 16, 0, 50)
    message.BackgroundTransparency = 1
    message.Text = options.message or "Message"
    message.TextColor3 = iOSUI.Colors.secondaryLabel
    message.Font = Enum.Font.Gotham
    message.TextSize = 14
    message.TextWrapped = true
    message.ZIndex = 12
    message.Parent = self.container
    
    -- 确定按钮
    local okButton = Instance.new("TextButton")
    okButton.Size = UDim2.new(1, 0, 0, 44)
    okButton.Position = UDim2.new(0, 0, 1, -44)
    okButton.BackgroundTransparency = 1
    okButton.Text = options.buttonText or "OK"
    okButton.TextColor3 = iOSUI.Colors.systemBlue
    okButton.Font = Enum.Font.GothamMedium
    okButton.TextSize = 17
    okButton.ZIndex = 12
    okButton.Parent = self.container
    
    -- 按钮顶部分隔线
    local buttonSeparator = Instance.new("Frame")
    buttonSeparator.Size = UDim2.new(1, 0, 0, 1)
    buttonSeparator.Position = UDim2.new(0, 0, 0, 0)
    buttonSeparator.BackgroundColor3 = iOSUI.Colors.systemGray5
    buttonSeparator.BorderSizePixel = 0
    buttonSeparator.ZIndex = 12
    buttonSeparator.Parent = okButton
    
    -- 点击关闭
    okButton.MouseButton1Click:Connect(function()
        self:Dismiss()
        if options.callback then
            options.callback()
        end
    end)
    
    return self
end

function iOSUI.Alert:Show(parent)
    self.overlay.Parent = parent
    
    -- 进入动画
    local TweenService = game:GetService("TweenService")
    self.container.Size = UDim2.new(0, 250, 0, 130)
    
    local tween = TweenService:Create(self.container, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 270, 0, 150)}
    )
    tween:Play()
end

function iOSUI.Alert:Dismiss()
    local TweenService = game:GetService("TweenService")
    
    local tween = TweenService:Create(self.container, 
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 250, 0, 130)}
    )
    tween:Play()
    tween.Completed:Wait()
    
    self.overlay:Destroy()
end

-- ==================== 初始化完成 ====================
print("✅ iOS UI Library v" .. iOSUI.VERSION .. " 加载成功！")

return iOSUI