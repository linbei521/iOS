-- iOS-style Navigation Bar
local View = require(script.Parent.Parent.core.View)
local Button = require(script.Parent.Button)
local Label = require(script.Parent.Label)
local Colors = require(script.Parent.Parent.theme.Colors)
local Typography = require(script.Parent.Parent.theme.Typography)
local SafeArea = require(script.Parent.Parent.layout.SafeArea)

local NavigationBar = {}
NavigationBar.__index = NavigationBar
setmetatable(NavigationBar, {__index = View})

function NavigationBar.new()
    local self = setmetatable(View.new(), NavigationBar)
    
    -- Properties
    self.title = ""
    self.translucent = true
    self.barTintColor = Colors.systemBackground
    self.tintColor = Colors.systemBlue
    self.titleTextAttributes = {
        font = Typography.headline,
        color = Colors.label
    }
    
    -- Items
    self.leftBarButtonItem = nil
    self.rightBarButtonItem = nil
    self.leftBarButtonItems = {}
    self.rightBarButtonItems = {}
    
    -- Size
    local safeArea = SafeArea.getInsets()
    self.frame = {
        x = 0,
        y = 0,
        width = 375, -- Will be updated
        height = 44 + safeArea.top
    }
    
    -- Background blur effect
    self.backgroundColor = self.barTintColor
    self.alpha = self.translucent and 0.97 or 1
    
    -- Internal
    self._titleLabel = nil
    self._leftItemsContainer = nil
    self._rightItemsContainer = nil
    self._separator = nil
    
    self:setupNavigationBar()
    
    return self
end

function NavigationBar:setupNavigationBar()
    -- Title label
    self._titleLabel = Label.new(self.title)
    self._titleLabel.font = self.titleTextAttributes.font
    self._titleLabel.textColor = self.titleTextAttributes.color
    self._titleLabel.textAlignment = "center"
    self:addSubview(self._titleLabel)
    
    -- Separator line
    self._separator = View.new()
    self._separator.backgroundColor = Colors.systemGray5
    self._separator.frame = {
        x = 0,
        y = self.frame.height - 0.5,
        width = self.frame.width,
        height = 0.5
    }
    self:addSubview(self._separator)
    
    -- Item containers
    self._leftItemsContainer = View.new()
    self:addSubview(self._leftItemsContainer)
    
    self._rightItemsContainer = View.new()
    self:addSubview(self._rightItemsContainer)
end

function NavigationBar:setTitle(title)
    self.title = title
    if self._titleLabel then
        self._titleLabel.text = title
    end
    self:setNeedsLayout()
end

function NavigationBar:setLeftBarButtonItem(item)
    self.leftBarButtonItem = item
    self.leftBarButtonItems = item and {item} or {}
    self:updateBarButtonItems()
end

function NavigationBar:setRightBarButtonItem(item)
    self.rightBarButtonItem = item
    self.rightBarButtonItems = item and {item} or {}
    self:updateBarButtonItems()
end

function NavigationBar:setLeftBarButtonItems(items, animated)
    self.leftBarButtonItems = items or {}
    self.leftBarButtonItem = items and items[1] or nil
    self:updateBarButtonItems(animated)
end

function NavigationBar:setRightBarButtonItems(items, animated)
    self.rightBarButtonItems = items or {}
    self.rightBarButtonItem = items and items[1] or nil
    self:updateBarButtonItems(animated)
end

function NavigationBar:updateBarButtonItems(animated)
    -- Clear existing items
    for _, view in ipairs(self._leftItemsContainer.subviews) do
        view:removeFromSuperview()
    end
    for _, view in ipairs(self._rightItemsContainer.subviews) do
        view:removeFromSuperview()
    end
    
    -- Add left items
    local leftX = 16
    for _, item in ipairs(self.leftBarButtonItems) do
        local button = self:createBarButton(item)
        button.frame.x = leftX
        self._leftItemsContainer:addSubview(button)
        leftX = leftX + button.frame.width + 8
    end
    
    -- Add right items
    local rightX = self.frame.width - 16
    for i = #self.rightBarButtonItems, 1, -1 do
        local item = self.rightBarButtonItems[i]
        local button = self:createBarButton(item)
        rightX = rightX - button.frame.width
        button.frame.x = rightX
        self._rightItemsContainer:addSubview(button)
        rightX = rightX - 8
    end
    
    self:setNeedsLayout()
end

function NavigationBar:createBarButton(item)
    local button = Button.new(item.title or "", Button.ButtonType.System)
    button.titleColor = self.tintColor
    
    if item.image then
        button:setImage(item.image)
    end
    
    if item.action then
        button.onTouchUpInside = item.action
    end
    
    button:sizeToFit()
    button.frame.y = (44 - button.frame.height) / 2
    
    return button
end

function NavigationBar:layoutSubviews()
    View.layoutSubviews(self)
    
    local safeArea = SafeArea.getInsets()
    
    -- Position title
    if self._titleLabel then
        self._titleLabel.frame = {
            x = 60,
            y = safeArea.top + (44 - 20) / 2,
            width = self.frame.width - 120,
            height = 20
        }
    end
    
    -- Position item containers
    if self._leftItemsContainer then
        self._leftItemsContainer.frame = {
            x = 0,
            y = safeArea.top,
            width = self.frame.width / 2,
            height = 44
        }
    end
    
    if self._rightItemsContainer then
        self._rightItemsContainer.frame = {
            x = self.frame.width / 2,
            y = safeArea.top,
            width = self.frame.width / 2,
            height = 44
        }
    end
    
    -- Update separator
    if self._separator then
        self._separator.frame = {
            x = 0,
            y = self.frame.height - 0.5,
            width = self.frame.width,
            height = 0.5
        }
    end
end

return NavigationBar