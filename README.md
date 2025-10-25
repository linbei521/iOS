# iOS Style UI Framework for Roblox

一个现代化的iOS 15+风格UI框架，专为Roblox脚本设计。

## 特性

- 🎨 完整的iOS 15+设计语言
- 🌓 浅色/深色主题支持
- 📱 移动端优化
- 🧩 模块化组件系统
- ⚡ 流畅的动画效果
- 🔧 易于扩展

## 快速开始

### 从GitHub加载

```lua
-- 加载框架
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/loader.lua"))()

-- 创建UI实例
local MyUI = UI.new({
    Name = "MyScript",
    Title = "我的脚本"
})

-- 创建主页
local homePage = MyUI:CreatePage("Home", "首页", "rbxassetid://7733955511")

-- 添加按钮
MyUI.Components.Button(homePage, {
    Text = "点击我",
    Callback = function()
        print("按钮被点击!")
    end
})

-- 显示UI
MyUI:Show()