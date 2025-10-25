--[[
    iOS风格UI框架 - 核心类
    提供创建和管理UI的核心功能
]]

local UIFramework = {}
UIFramework.__index = UIFramework

-- 服务引用
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- 加载主题
local Theme = _G.LoadUIModule("src/themes/iOS.lua")
local Animations = _G.LoadUIModule("src/utils/Animations.lua")
local ScreenAdapter = _G.LoadUIModule("src/utils/ScreenAdapter.lua")

-- 创建新的UI实例
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
    
    -- ⚠️ 先加载组件和导航模块，再初始化UI
    self.Components = {
        Button = _G.LoadUIModule("src/components/Button.lua"),
        Toggle = _G.LoadUIModule("src/components/Toggle.lua"),
        Slider = _G.LoadUIModule("src/components/Slider.lua"),
        Card = _G.LoadUIModule("src/components/Card.lua"),
        List = _G.LoadUIModule("src/components/List.lua"),
        SegmentedControl = _G.LoadUIModule("src/components/SegmentedControl.lua"),
    }
    
    self.Navigation = {
        TabBar = _G.LoadUIModule("src/navigation/TabBar.lua"),
        PageManager = _G.LoadUIModule("src/navigation/PageManager.lua"),
    }
    
    -- 现在可以安全地初始化UI了
    self:_Initialize()
    
    return self
end

-- 初始化UI容器
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
    self.Container.Position = UDim2.new(0, 0, 0, 0)
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
    
    -- 初始化TabBar（现在 self.Navigation 已经存在了）
    self.TabBar = self.Navigation.TabBar.new(self.Container, self.Theme)
    self.TabBar.OnTabChanged = function(tabName)
        self:ShowPage(tabName)
    end
end

-- 创建页面
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

-- 显示页面
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

-- 显示UI
function UIFramework:Show()
    self.ScreenGui.Enabled = true
    self.IsVisible = true
    self.Animations.SlideIn(self.Container, "Bottom", 0.4)
end

-- 隐藏UI
function UIFramework:Hide()
    self.Animations.SlideOut(self.Container, "Bottom", 0.3, function()
        self.ScreenGui.Enabled = false
        self.IsVisible = false
    end)
end

-- 切换显示/隐藏
function UIFramework:Toggle()
    if self.IsVisible then
        self:Hide()
    else
        self:Show()
    end
end

-- 切换主题模式
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

-- 销毁UI
function UIFramework:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return UIFramework