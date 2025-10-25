
---

## 📁 src/

### `src/UIFramework.lua`

```lua
--[[
    iOS风格UI框架 - 核心类
]]

local UIFramework = {}
UIFramework.__index = UIFramework

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = _G.LoadUIModule("src/themes/iOS.lua")
local Animations = _G.LoadUIModule("src/utils/Animations.lua")
local ScreenAdapter = _G.LoadUIModule("src/utils/ScreenAdapter.lua")

function UIFramework.new(config)
    local self = setmetatable({}, UIFramework)
    
    config = config or {}
    self.Name = config.Name or "iOSUI"
    self.Title = config.Title or "iOS UI"
    self.Parent = config.Parent or Players.LocalPlayer:WaitForChild("PlayerGui")
    self.Theme = Theme
    self.Animations = Animations
    
    self.Pages = {}
    self.CurrentPage = nil
    self.IsVisible = false
    
    self:_Initialize()
    
    -- 加载组件
    self.Components = {
        Button = _G.LoadUIModule("src/components/Button.lua"),
        Toggle = _G.LoadUIModule("src/components/Toggle.lua"),
        Slider = _G.LoadUIModule("src/components/Slider.lua"),
        Card = _G.LoadUIModule("src/components/Card.lua"),
        List = _G.LoadUIModule("src/components/List.lua"),
        SegmentedControl = _G.LoadUIModule("src/components/SegmentedControl.lua"),
    }
    
    -- 加载导航
    self.Navigation = {
        TabBar = _G.LoadUIModule("src/navigation/TabBar.lua"),
        PageManager = _G.LoadUIModule("src/navigation/PageManager.lua"),
    }
    
    return self
end

function UIFramework:_Initialize()
    -- 创建ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = self.Name
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Enabled = false
    self.ScreenGui.Parent = self.Parent
    
    -- 主容器
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.BackgroundColor3 = self.Theme:GetColor("Background")
    self.Container.BorderSizePixel = 0
    self.Container.Parent = self.ScreenGui
    
    -- 安全区域适配
    ScreenAdapter.ApplySafeArea(self.Container)
    
    -- 页面容器
    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Name = "PageContainer"
    self.PageContainer.Size = UDim2.new(1, 0, 1, -70) -- 留出TabBar空间
    self.PageContainer.Position = UDim2.new(0, 0, 0, 0)
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.Parent = self.Container
    
    -- 初始化TabBar
    self.TabBar = self.Navigation.TabBar.new(self.Container, self.Theme)
    self.TabBar.OnTabChanged = function(tabName)
        self:ShowPage(tabName)
    end
end

function UIFramework:CreatePage(name, title, icon)
    if self.Pages[name] then
        return self.Pages[name]
    end
    
    local PageModule = _G.LoadUIModule("src/components/Page.lua")
    local page = PageModule.new(self.PageContainer, {
        Name = name,
        Title = title or name,
        Theme = self.Theme
    })
    
    self.Pages[name] = page
    
    -- 添加到TabBar
    self.TabBar:AddTab(name, title or name, icon or "rbxassetid://7733674079")
    
    return page.Container
end

function UIFramework:ShowPage(name)
    local targetPage = self.Pages[name]
    if not targetPage then
        warn("Page not found: " .. name)
        return
    end
    
    -- 隐藏当前页面
    if self.CurrentPage and self.CurrentPage ~= targetPage then
        self.Animations.FadeOut(self.CurrentPage.Container, 0.2)
    end
    
    -- 显示新页面
    self.Animations.FadeIn(targetPage.Container, 0.3)
    self.CurrentPage = targetPage
end

function UIFramework:Show()
    self.ScreenGui.Enabled = true
    self.IsVisible = true
    self.Animations.SlideIn(self.Container, "Bottom", 0.4)
end

function UIFramework:Hide()
    self.Animations.SlideOut(self.Container, "Bottom", 0.3, function()
        self.ScreenGui.Enabled = false
        self.IsVisible = false
    end)
end

function UIFramework:Toggle()
    if self.IsVisible then
        self:Hide()
    else
        self:Show()
    end
end

function UIFramework:SetTheme(mode)
    self.Theme:SetMode(mode)
    self.Container.BackgroundColor3 = self.Theme:GetColor("Background")
    
    -- 通知所有页面更新主题
    for _, page in pairs(self.Pages) do
        if page.UpdateTheme then
            page:UpdateTheme()
        end
    end
    
    self.TabBar:UpdateTheme()
end

function UIFramework:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return UIFramework