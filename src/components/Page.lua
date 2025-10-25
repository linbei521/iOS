--[[
    页面组件
]]

local Page = {}
Page.__index = Page

function Page.new(parent, config)
    local self = setmetatable({}, Page)
    
    config = config or {}
    self.Name = config.Name or "Page"
    self.Title = config.Title or "Page"
    self.Theme = config.Theme or _G.LoadUIModule("src/themes/iOS.lua")
    
    -- 页面容器
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Name = self.Name
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Theme:GetColor("TertiaryText")
    self.Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Container.Visible = false
    self.Container.Parent = parent
    
    -- 内容容器
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.Size = UDim2.new(1, 0, 1, 0)
    self.Content.AutomaticSize = Enum.AutomaticSize.Y
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Container
    
    -- 布局
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, self.Theme.Spacing.Medium)
    layout.Parent = self.Content
    
    -- 内边距
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, self.Theme.Spacing.Large)
    padding.PaddingBottom = UDim.new(0, self.Theme.Spacing.Large)
    padding.PaddingLeft = UDim.new(0, self.Theme.Spacing.Large)
    padding.PaddingRight = UDim.new(0, self.Theme.Spacing.Large)
    padding.Parent = self.Content
    
    return self
end

function Page:UpdateTheme()
    self.Container.ScrollBarImageColor3 = self.Theme:GetColor("TertiaryText")
end

return Page