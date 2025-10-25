--[[
    iOS风格UI框架 - 完整示例
    展示所有组件的使用方法
]]

-- 加载框架
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/loader.lua"))()

-- 创建UI实例
local MyUI = UI.new({
    Name = "DemoUI",
    Title = "演示脚本"
})

-- ========== 主页 ==========
local homePage = MyUI:CreatePage("Home", "主页", "rbxassetid://7733955511")

-- 欢迎卡片
local welcomeCard = MyUI.Components.Card.new(homePage, {
    Theme = MyUI.Theme,
    Size = UDim2.new(1, 0, 0, 120)
})

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, 0, 0, 30)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "欢迎使用iOS UI框架"
welcomeTitle.TextColor3 = MyUI.Theme:GetColor("PrimaryText")
welcomeTitle.Font = Enum.Font.GothamBold
welcomeTitle.TextSize = MyUI.Theme.FontSize.Title
welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
welcomeTitle.Parent = welcomeCard

local welcomeDesc = Instance.new("TextLabel")
welcomeDesc.Size = UDim2.new(1, 0, 0, 60)
welcomeDesc.Position = UDim2.new(0, 0, 0, 35)
welcomeDesc.BackgroundTransparency = 1
welcomeDesc.Text = "这是一个现代化的iOS 15+风格UI库\n支持深色模式、流畅动画和丰富组件"
welcomeDesc.TextColor3 = MyUI.Theme:GetColor("SecondaryText")
welcomeDesc.Font = Enum.Font.Gotham
welcomeDesc.TextSize = MyUI.Theme.FontSize.Body
welcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
welcomeDesc.TextYAlignment = Enum.TextYAlignment.Top
welcomeDesc.TextWrapped = true
welcomeDesc.Parent = welcomeCard

-- 主要按钮
MyUI.Components.Button.new(homePage, {
    Text = "开始使用",
    Theme = MyUI.Theme,
    Style = "Primary",
    Callback = function()
        print("主要按钮被点击")
    end
})

-- 次要按钮
MyUI.Components.Button.new(homePage, {
    Text = "查看文档",
    Theme = MyUI.Theme,
    Style = "Secondary",
    Callback = function()
        print("次要按钮被点击")
    end
})

-- ========== 设置页 ==========
local settingsPage = MyUI:CreatePage("Settings", "设置", "rbxassetid://7734053495")

-- 分段控制器
MyUI.Components.SegmentedControl.new(settingsPage, {
    Segments = {"常规", "外观", "高级"},
    Default = 1,
    Theme = MyUI.Theme,
    Callback = function(index, text)
        print("选中分段:", text)
    end
})

-- 开关示例
MyUI.Components.Toggle.new(settingsPage, {
    Text = "启用通知",
    Default = true,
    Theme = MyUI.Theme,
    Callback = function(state)
        print("通知状态:", state)
    end
})

MyUI.Components.Toggle.new(settingsPage, {
    Text = "自动保存",
    Default = false,
    Theme = MyUI.Theme,
    Callback = function(state)
        print("自动保存:", state)
    end
})

-- 滑块示例
MyUI.Components.Slider.new(settingsPage, {
    Text = "音量",
    Min = 0,
    Max = 100,
    Default = 50,
    Theme = MyUI.Theme,
    Callback = function(value)
        print("音量:", value)
    end
})

MyUI.Components.Slider.new(settingsPage, {
    Text = "速度",
    Min = 1,
    Max = 10,
    Default = 5,
    Theme = MyUI.Theme,
    Callback = function(value)
        print("速度:", value)
    end
})

-- 主题切换
MyUI.Components.Button.new(settingsPage, {
    Text = "切换深色/浅色模式",
    Theme = MyUI.Theme,
    Callback = function()
        MyUI.Theme:Toggle()
        MyUI:SetTheme(MyUI.Theme.CurrentMode)
        print("当前主题:", MyUI.Theme.CurrentMode)
    end
})

-- ========== 功能页 ==========
local featuresPage = MyUI:CreatePage("Features", "功能", "rbxassetid://7733920644")

-- 列表示例
local featureList = MyUI.Components.List.new(featuresPage, {
    Theme = MyUI.Theme,
    Size = UDim2.new(1, 0, 0, 400)
})

-- 添加功能项
for i = 1, 10 do
    MyUI.Components.Toggle.new(featureList, {
        Text = "功能 " .. i,
        Default = i % 2 == 0,
        Theme = MyUI.Theme,
        Callback = function(state)
            print("功能 " .. i .. ":", state)
        end
    })
end

-- ========== 关于页 ==========
local aboutPage = MyUI:CreatePage("About", "关于", "rbxassetid://7733911816")

local aboutCard = MyUI.Components.Card.new(aboutPage, {
    Theme = MyUI.Theme,
    Size = UDim2.new(1, 0, 0, 200)
})

local aboutTitle = Instance.new("TextLabel")
aboutTitle.Size = UDim2.new(1, 0, 0, 30)
aboutTitle.BackgroundTransparency = 1
aboutTitle.Text = "iOS UI Framework"
aboutTitle.TextColor3 = MyUI.Theme:GetColor("PrimaryText")
aboutTitle.Font = Enum.Font.GothamBold
aboutTitle.TextSize = MyUI.Theme.FontSize.LargeTitle
aboutTitle.Parent = aboutCard

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, 0, 0, 20)
versionLabel.Position = UDim2.new(0, 0, 0, 35)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "版本 1.0.0"
versionLabel.TextColor3 = MyUI.Theme:GetColor("SecondaryText")
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = MyUI.Theme.FontSize.Body
versionLabel.Parent = aboutCard

local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(1, 0, 1, -60)
descLabel.Position = UDim2.new(0, 0, 0, 60)
descLabel.BackgroundTransparency = 1
descLabel.Text = "一个现代化、模块化的iOS风格UI框架\n\n特性:\n• iOS 15+设计语言\n• 深色/浅色主题\n• 流畅动画\n• 移动端优化"
descLabel.TextColor3 = MyUI.Theme:GetColor("TertiaryText")
descLabel.Font = Enum.Font.Gotham
descLabel.TextSize = MyUI.Theme.FontSize.Body
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.TextYAlignment = Enum.TextYAlignment.Top
descLabel.TextWrapped = true
descLabel.Parent = aboutCard

-- 显示UI
MyUI:Show()

-- 返回UI实例（可选）
return MyUI