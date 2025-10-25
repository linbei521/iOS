--[[
    iOS风格底部标签栏
]]

local TweenService = game:GetService("TweenService")

local TabBar = {}
TabBar.__index = TabBar

function TabBar.new(parent, theme)
    local self = setmetatable({}, TabBar)
    
    self.Theme = theme
    self.Tabs = {}
    self.CurrentTab = nil
    self.OnTabChanged = nil
    
    -- 标签栏容器
    self.Container = Instance.new("Frame")
    self.Container.Name = "TabBar"
    self.Container.Size = UDim2.new(1, 0, 0, 70)
    self.Container.Position = UDim2.new(0, 0, 1, -70)
    self.Container.BackgroundColor3 = theme:GetColor("TabBarBackground")
    self.Container.BorderSizePixel = 0
    self.Container.Parent = parent
    
    -- 顶部边框
    local topBorder = Instance.new("Frame")
    topBorder.Size = UDim2.new(1, 0, 0, 1)
    topBorder.BackgroundColor3 = theme:GetColor("TabBarBorder")
    topBorder.BorderSizePixel = 0
    topBorder.Parent = self.Container
    
    -- 标签容器
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, 0, 1, 0)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.Container
    
    -- 布局
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 0)
    layout.Parent = self.TabContainer
    
    return self
end

function TabBar:AddTab(name, title, icon)
    local tabCount = #self.Tabs
    
    -- 标签按钮
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.new(1 / 5, 0, 1, 0) -- 最多5个标签
    tab.BackgroundTransparency = 1
    tab.Text = ""
    tab.Parent = self.TabContainer
    
    -- 图标
    local iconImage = Instance.new("ImageLabel")
    iconImage.Size = UDim2.new(0, 24, 0, 24)
    iconImage.Position = UDim2.new(0.5, -12, 0, 12)
    iconImage.BackgroundTransparency = 1
    iconImage.Image = icon
    iconImage.ImageColor3 = self.Theme:GetColor("TertiaryText")
    iconImage.Parent = tab
    
    -- 标题
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 14)
    label.Position = UDim2.new(0, 0, 0, 42)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = self.Theme:GetColor("TertiaryText")
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.Parent = tab
    
    -- 点击事件
    tab.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    table.insert(self.Tabs, {
        Name = name,
        Button = tab,
        Icon = iconImage,
        Label = label
    })
    
    -- 默认选中第一个
    if tabCount == 0 then
        self:SelectTab(name)
    end
end

function TabBar:SelectTab(name)
    for _, tab in ipairs(self.Tabs) do
        local isSelected = tab.Name == name
        local color = isSelected and self.Theme:GetColor("Accent") or self.Theme:GetColor("TertiaryText")
        
        TweenService:Create(tab.Icon, TweenInfo.new(0.2), {
            ImageColor3 = color
        }):Play()
        
        TweenService:Create(tab.Label, TweenInfo.new(0.2), {
            TextColor3 = color
        }):Play()
        
        if isSelected then
            self.CurrentTab = name
        end
    end
    
    if self.OnTabChanged then
        self.OnTabChanged(name)
    end
end

function TabBar:UpdateTheme()
    self.Container.BackgroundColor3 = self.Theme:GetColor("TabBarBackground")
    
    for _, tab in ipairs(self.Tabs) do
        local isSelected = tab.Name == self.CurrentTab
        local color = isSelected and self.Theme:GetColor("Accent") or self.Theme:GetColor("TertiaryText")
        
        tab.Icon.ImageColor3 = color
        tab.Label.TextColor3 = color
    end
end

return TabBar