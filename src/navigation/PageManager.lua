--[[
    页面管理器
]]

local PageManager = {}
PageManager.__index = PageManager

function PageManager.new(container, theme)
    local self = setmetatable({}, PageManager)
    
    self.Container = container
    self.Theme = theme
    self.Pages = {}
    self.CurrentPage = nil
    
    return self
end

function PageManager:AddPage(page)
    table.insert(self.Pages, page)
end

function PageManager:ShowPage(pageName)
    local Animations = _G.LoadUIModule("src/utils/Animations.lua")
    
    for _, page in ipairs(self.Pages) do
        if page.Name == pageName then
            Animations.FadeIn(page.Container, 0.3)
            self.CurrentPage = page
        else
            if page.Container.Visible then
                Animations.FadeOut(page.Container, 0.2)
            end
        end
    end
end

return PageManager