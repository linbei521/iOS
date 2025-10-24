-- iOS UI Library Loader for Roblox Executors
-- 将 YOUR_GITHUB_USERNAME 和 YOUR_REPO_NAME 替换为你的实际值

local iOSUI = {
    VERSION = "1.0.0",
    _modules = {}
}

-- ========== 配置 ==========
local CONFIG = {
    GITHUB_USER = "YOUR_GITHUB_USERNAME",  -- 替换为你的GitHub用户名
    GITHUB_REPO = "YOUR_REPO_NAME",         -- 替换为你的仓库名
    GITHUB_BRANCH = "main"                  -- 或 "master"
}

local BASE_URL = string.format(
    "https://raw.githubusercontent.com/%s/%s/%s/src/",
    CONFIG.GITHUB_USER,
    CONFIG.GITHUB_REPO,
    CONFIG.GITHUB_BRANCH
)

-- ========== 模块缓存系统 ==========
local moduleCache = {}

local function httpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if not success then
        warn("❌ HTTP GET failed:", url)
        warn("Error:", result)
        return nil
    end
    
    return result
end

local function loadModule(path)
    -- 检查缓存
    if moduleCache[path] then
        return moduleCache[path]
    end
    
    local url = BASE_URL .. path .. ".lua"
    print("📦 Loading module:", path)
    
    local code = httpGet(url)
    if not code then
        warn("❌ Failed to load module:", path)
        return nil
    end
    
    -- 执行模块代码
    local success, module = pcall(function()
        return loadstring(code)()
    end)
    
    if not success then
        warn("❌ Failed to execute module:", path)
        warn("Error:", module)
        return nil
    end
    
    -- 缓存模块
    moduleCache[path] = module
    print("✅ Loaded:", path)
    
    return module
end

-- ========== 加载所有模块 ==========
print("🚀 Loading iOS UI Library...")

-- Core
iOSUI.View = loadModule("core/View")
iOSUI.Window = loadModule("core/Window")
iOSUI.Renderer = loadModule("core/Renderer")

-- Theme (需要先加载，其他模块依赖)
iOSUI.Colors = loadModule("theme/Colors")
iOSUI.Typography = loadModule("theme/Typography")
iOSUI.Theme = loadModule("theme/Theme")

-- Utils
iOSUI.Device = loadModule("utils/Device")
iOSUI.Haptic = loadModule("utils/Haptic")

-- Layout
iOSUI.SafeArea = loadModule("layout/SafeArea")

-- Animation
iOSUI.Spring = loadModule("animation/Spring")

-- Components
iOSUI.Label = loadModule("components/Label")
iOSUI.Button = loadModule("components/Button")
iOSUI.TextField = loadModule("components/TextField")
iOSUI.Switch = loadModule("components/Switch")
iOSUI.Alert = loadModule("components/Alert")
iOSUI.NavigationBar = loadModule("components/NavigationBar")
iOSUI.TabBar = loadModule("components/TabBar")

print("✅ iOS UI Library loaded successfully!")
print("📱 Version:", iOSUI.VERSION)

return iOSUI