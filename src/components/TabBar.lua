-- iOS-style Tab Bar
local View = require(script.Parent.Parent.core.View)
local Colors = require(script.Parent.Parent.theme.Colors)
local Typography = require(script.Parent.Parent.theme.Typography)
local SafeArea = require(script.Parent.Parent.layout.SafeArea)
local Haptic = require(script.Parent.Parent.utils.Haptic)

local TabBar = {}
TabBar.__index = TabBar
setmetatable(TabBar, {__index = View})

local TabBarItem = {}
TabBarItem.__index = TabBarItem

function TabBarItem.new(title, image, selectedImage)
    local self = setmetatable({}, TabBarItem)
    
    self.title = title
    self.image = image
    self.selectedImage = selectedImage or image
    self.badgeValue = nil
    self.badgeColor = Colors.systemRed
    self.enabled = true
    
    return self
end

function TabBar.new()
    local self = setmetatable(View.new(), TabBar)
    
    -- Properties
    self.items = {}
    self.selectedItem = nil
    self.selectedIndex = 0
    self.translucent = true
    self.barTintColor = Colors.systemBackground
    self.tintColor = Colors.systemBlue
    self.unselectedItemTintColor = Colors.systemGray
    
    -- Size
    local safeArea = SafeArea.getInsets()
    self.frame = {
        x = 0,
        y = 0, -- Will be positioned at bottom
        width = 375, -- Will be updated
        height = 49 + safeArea.bottom
    }
    
    -- Background
    self.backgroundColor = self.barTintColor
    self.alpha = self.translucent and 0.97 or 1
    
    -- Callbacks
    self.onItemSelected = nil
    
    -- Internal
    self._itemViews = {}
    self._separator = nil
    
    self:setupTabBar()
    
    return self
end

function TabBar:setupTabBar()
    -- Top separator
    self._separator = View.new()
    self._separator.backgroundColor = Colors.systemGray5
    self._separator.frame = {
        x = 0,
        y = 0,
        width = self.frame.width,
        height = 0.5
    }
    self:addSubview(self._separator)
end

function TabBar:setItems(items, animated)
    -- Clear existing item views
    for _, itemView in ipairs(self._itemViews) do
        itemView:removeFromSuperview()
    end
    self._itemViews = {}
    
    self.items = items or {}
    
    -- Create item views
    for i, item in ipairs(self.items) do
        local itemView = self:createItemView(item, i)
        self._itemViews[i] = itemView
        self:addSubview(itemView)
    end
    
    -- Select first item by default
    if #self.items > 0 and not self.selectedItem then
        self:setSelectedIndex(1)
    end
    
    self:setNeedsLayout()
end

function TabBar:createItemView(item, index)
    local itemView = View.new()
    itemView.userInteractionEnabled = true
    
    -- Icon
    local iconView = View.new()
    iconView.frame = {x = 0, y = 5, width = 30, height = 30}
    -- Set icon image here
    itemView:addSubview(iconView)
    
    -- Title
    local Label = require(script.Parent.Label)
    local titleLabel = Label.new(item.title)
    titleLabel.font = {family = "SF Pro", size = 10}
    titleLabel.textAlignment = "center"
    titleLabel.frame = {x = 0, y = 35, width = 60, height = 12}
    itemView:addSubview(titleLabel)
    
    -- Badge
    if item.badgeValue then
        local badgeView = self:createBadgeView(item.badgeValue)
        badgeView.frame = {x = 35, y = 2, width = 18, height = 18}
        itemView:addSubview(badgeView)
    end
    
    -- Store references
    itemView._item = item
    itemView._index = index
    itemView._iconView = iconView
    itemView._titleLabel = titleLabel
    
    -- Update colors based on selection
    self:updateItemAppearance(itemView, false)
    
    return itemView
end

function TabBar:createBadgeView(value)
    local badgeView = View.new()
    badgeView.backgroundColor = Colors.systemRed
    badgeView.cornerRadius = 9
    
    local Label = require(script.Parent.Label)
    local label = Label.new(tostring(value))
    label.textColor = Colors.white
    label.font = {family = "SF Pro", size = 11}
    label.textAlignment = "center"
    badgeView:addSubview(label)
    
    return badgeView
end

function TabBar:setSelectedIndex(index)
    if index < 1 or index > #self.items then return end
    
    self.selectedIndex = index
    self.selectedItem = self.items[index]
    
    -- Update appearance of all items
    for i, itemView in ipairs(self._itemViews) do
        self:updateItemAppearance(itemView, i == index)
    end
    
    -- Haptic feedback
    Haptic.selection()
    
    -- Callback
    if self.onItemSelected then
        self.onItemSelected(self, self.selectedItem, index)
    end
end

function TabBar:updateItemAppearance(itemView, selected)
    local color = selected and self.tintColor or self.unselectedItemTintColor
    
    if itemView._titleLabel then
        itemView._titleLabel.textColor = color
    end
    
    -- Update icon tint color
    -- Implementation depends on how icons are handled
end

function TabBar:layoutSubviews()
    View.layoutSubviews(self)
    
    local safeArea = SafeArea.getInsets()
    local itemCount = #self._itemViews
    if itemCount == 0 then return end
    
    local itemWidth = self.frame.width / itemCount
    
    for i, itemView in ipairs(self._itemViews) do
        itemView.frame = {
            x = (i - 1) * itemWidth,
            y = 0,
            width = itemWidth,
            height = 49
        }
        
        -- Center content in item
        for _, subview in ipairs(itemView.subviews) do
            subview.frame.x = (itemWidth - subview.frame.width) / 2
        end
    end
    
    -- Update separator
    if self._separator then
        self._separator.frame.width = self.frame.width
    end
end

function TabBar:touchesEnded(touches, event)
    local point = touches[1]
    
    for i, itemView in ipairs(self._itemViews) do
        if itemView:pointInside(self:convertPoint(point, itemView)) then
            if itemView._item.enabled and i ~= self.selectedIndex then
                self:setSelectedIndex(i)
            end
            break
        end
    end
end

return TabBar