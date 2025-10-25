--[[
    iOS风格UI框架加载器
    使用方法: 
    local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/loader.lua"))()
]]

local GITHUB_BASE = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/"

-- 模块缓存
local LoadedModules = {}

-- 模块加载器
local function LoadModule(path)
    if LoadedModules[path] then
        return LoadedModules[path]
    end
    
    local success, result = pcall(function()
        local url = GITHUB_BASE .. path
        local source = game:HttpGet(url)
        local func = loadstring(source)
        if not func then
            error("Failed to compile module: " .. path)
        end
        return func()
    end)
    
    if not success then
        error("Failed to load module '" .. path .. "': " .. tostring(result))
    end
    
    LoadedModules[path] = result
    return result
end

-- 全局模块加载函数
_G.LoadUIModule = LoadModule

-- 加载核心框架
local UIFramework = LoadModule("src/UIFramework.lua")

return UIFramework
