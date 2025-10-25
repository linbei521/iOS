--[[
    iOS风格UI框架 - 核心类（简化版）
    暂时移除TabBar，先让基础功能运行
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
    
    -- 加载组件
    print("[UIFramework] Loading components...")
    self.Components = {
        Button = _G.LoadUIModule("src/components/Button.lua"),
        Toggle = _G.LoadUIModule("src/components/Toggle.lua"),
        Slider = _G.LoadUIModule("src/components/Slider.lua"),
        Card = _G.LoadUIModule("src/components/Card.lua"),
        List = _G.LoadUIModule("src/components/List.lua"),
        SegmentedControl = _G.LoadUIModule("src/components/SegmentedControl.lua"),
    }
    print("[UIFramework] Components loaded!")
    
    -- 初始化UI
    self:_Initialize()
    
    print("[UIFramework] Initialized: " .. self.Name)
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
    self.ScreenGui.Enabled = true  -- 默认显示
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
    
    -- 页面容器（暂时不留TabBar空间）
    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Name = "PageContainer"
    self.PageContainer.Size = UDim2.new(1, 0, 1, 0)  -- 全屏
    self.PageContainer.Position = UDim2.new(0, 0, 0, 0)
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.Parent = self.Container
    
    self.IsVisible = true
end

-- 创建页面
function UIFramework:CreatePage(name, title, icon)
    if self.Pages[name] then
        warn("[UIFramework] Page already exists: " .. name)
        return self.Pages[name].Container
    end
    
    print("[UIFramework] Creating page: " .. name)
    
    local PageModule = _G.LoadUIModule("src/components/Page.lua")
    local page = PageModule.new(self.PageContainer, {
        Name = name,
        Title = title or name,
        Theme = self.Theme
    })
    
    self.Pages[name] = page
    
    -- 自动显示第一个页面
    if not self.CurrentPage then
        page.Container.Visible = true
        self.CurrentPage = page
        print("[UIFramework] Set as default page: " .. name)
    end
    
    return page.Container
end

-- 显示页面
function UIFramework:ShowPage(name)
    local targetPage = self.Pages[name]
    if not targetPage then
        warn("[UIFramework] Page not found: " .. name)
        return
    end
    
    print("[UIFramework] Showing page: " .. name)
    
    -- 隐藏所有页面
    for pageName, page in pairs(self.Pages) do
        if pageName ~= name then
            page.Container.Visible = false
        end
    end
    
    -- 显示目标页面
    targetPage.Container.Visible = true
    self.CurrentPage = targetPage
end

-- 显示UI
function UIFramework:Show()
    self.ScreenGui.Enabled = true
    self.IsVisible = true
    print("[UIFramework] UI Shown")
end

-- 隐藏UI
function UIFramework:Hide()
    self.ScreenGui.Enabled = false
    self.IsVisible = false
    print("[UIFramework] UI Hidden")
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
    print("[UIFramework] Setting theme to: " .. mode)
    self.Theme:SetMode(mode)
    self.Container.BackgroundColor3 = self.Theme:GetColor("Background")
    
    -- 通知所有页面更新主题
    for _, page in pairs(self.Pages) do
        if page.UpdateTheme then
            page:UpdateTheme()
        end
    end
end

-- 销毁UI
function UIFramework:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    print("[UIFramework] Destroyed")
end

return UIFramework