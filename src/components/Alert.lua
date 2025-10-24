-- iOS-style Alert
local View = require(script.Parent.Parent.core.View)
local Button = require(script.Parent.Button)
local Label = require(script.Parent.Label)
local Colors = require(script.Parent.Parent.theme.Colors)
local Typography = require(script.Parent.Parent.theme.Typography)
local Spring = require(script.Parent.Parent.animation.Spring)

local Alert = {}
Alert.__index = Alert
setmetatable(Alert, {__index = View})

Alert.Style = {
    Alert = "alert",
    ActionSheet = "actionSheet"
}

Alert.ActionStyle = {
    Default = "default",
    Cancel = "cancel",
    Destructive = "destructive"
}

function Alert.new(title, message, preferredStyle)
    local self = setmetatable(View.new(), Alert)
    
    -- Properties
    self.title = title
    self.message = message
    self.preferredStyle = preferredStyle or Alert.Style.Alert
    self.actions = {}
    
    -- Appearance
    self.backgroundColor = Colors.systemBackground
    self.cornerRadius = 14
    self.alpha = 0
    
    -- Size
    self.frame = {
        x = 0,
        y = 0,
        width = 270,
        height = 0 -- Will be calculated
    }
    
    -- Internal
    self._overlayView = nil
    self._contentView = nil
    self._titleLabel = nil
    self._messageLabel = nil
    self._actionButtons = {}
    
    self:setupAlert()
    
    return self
end

function Alert:setupAlert()
    -- Overlay
    self._overlayView = View.new()
    self._overlayView.backgroundColor = {r = 0, g = 0, b = 0, a = 0.4}
    self._overlayView.alpha = 0
    self._overlayView.userInteractionEnabled = true
    
    -- Content container
    self._contentView = View.new()
    self._contentView.backgroundColor = Colors.systemBackground
    self._contentView.cornerRadius = 14
    self:addSubview(self._contentView)
    
    -- Title
    if self.title then
        self._titleLabel = Label.new(self.title)
        self._titleLabel.font = Typography.headline
        self._titleLabel.textAlignment = "center"
        self._titleLabel.frame = {
            x = 16,
            y = 19,
            width = self.frame.width - 32,
            height = 20
        }
        self._contentView:addSubview(self._titleLabel)
    end
    
    -- Message
    if self.message then
        self._messageLabel = Label.new(self.message)
        self._messageLabel.font = Typography.footnote
        self._messageLabel.textAlignment = "center"
        self._messageLabel.numberOfLines = 0
        local messageY = self._titleLabel and 44 or 19
        self._messageLabel.frame = {
            x = 16,
            y = messageY,
            width = self.frame.width - 32,
            height = 40 -- Will be calculated
        }
        self._contentView:addSubview(self._messageLabel)
    end
end

function Alert:addAction(title, style, handler)
    local action = {
        title = title,
        style = style or Alert.ActionStyle.Default,
        handler = handler
    }
    table.insert(self.actions, action)
    return action
end

function Alert:present(parentView)
    if not parentView then return end
    
    -- Add overlay
    parentView:addSubview(self._overlayView)
    self._overlayView.frame = {
        x = 0,
        y = 0,
        width = parentView.frame.width,
        height = parentView.frame.height
    }
    
    -- Layout actions
    self:layoutActions()
    
    -- Calculate alert size
    local contentHeight = 0
    if self._titleLabel then
        contentHeight = contentHeight + 39
    end
    if self._messageLabel then
        contentHeight = contentHeight + self._messageLabel.frame.height + 20
    end
    contentHeight = contentHeight + (#self.actions * 44)
    
    self.frame.height = contentHeight
    self._contentView.frame = {
        x = 0,
        y = 0,
        width = self.frame.width,
        height = contentHeight
    }
    
    -- Center alert
    self.frame.x = (parentView.frame.width - self.frame.width) / 2
    self.frame.y = (parentView.frame.height - self.frame.height) / 2
    
    -- Add alert to parent
    parentView:addSubview(self)
    
    -- Animate in
    self:animateIn()
end

function Alert:layoutActions()
    local startY = 0
    
    if self._titleLabel then
        startY = startY + 39
    end
    if self._messageLabel then
        startY = startY + self._messageLabel.frame.height + 20
    end
    
    -- Add separator
    local separator = View.new()
    separator.backgroundColor = Colors.systemGray5
    separator.frame = {
        x = 0,
        y = startY,
        width = self.frame.width,
        height = 0.5
    }
    self._contentView:addSubview(separator)
    
    -- Add action buttons
    for i, action in ipairs(self.actions) do
        local button = self:createActionButton(action)
        button.frame = {
            x = 0,
            y = startY + (i - 1) * 44,
            width = self.frame.width,
            height = 44
        }
        self._contentView:addSubview(button)
        table.insert(self._actionButtons, button)
        
        -- Add separator between buttons
        if i < #self.actions then
            local btnSeparator = View.new()
            btnSeparator.backgroundColor = Colors.systemGray5
            btnSeparator.frame = {
                x = 0,
                y = startY + i * 44 - 0.5,
                width = self.frame.width,
                height = 0.5
            }
            self._contentView:addSubview(btnSeparator)
        end
    end
end

function Alert:createActionButton(action)
    local button = Button.new(action.title, Button.ButtonType.Plain)
    
    -- Style based on action style
    if action.style == Alert.ActionStyle.Cancel then
        button.font = Typography.bodyBold
    elseif action.style == Alert.ActionStyle.Destructive then
        button.titleColor = Colors.systemRed
    else
        button.titleColor = Colors.systemBlue
    end
    
    button.onTouchUpInside = function()
        self:dismiss()
        if action.handler then
            action.handler()
        end
    end
    
    return button
end

function Alert:animateIn()
    -- Fade in overlay
    Spring.animate(self._overlayView, {
        alpha = 1
    }, {duration = 0.3})
    
    -- Scale and fade in alert
    self.transform = {scaleX = 1.1, scaleY = 1.1}
    self.alpha = 0
    
    Spring.animate(self, {
        transform = {scaleX = 1, scaleY = 1},
        alpha = 1
    }, {duration = 0.3, damping = 0.8})
end

function Alert:dismiss()
    -- Animate out
    Spring.animate(self._overlayView, {
        alpha = 0
    }, {duration = 0.2})
    
    Spring.animate(self, {
        transform = {scaleX = 0.9, scaleY = 0.9},
        alpha = 0
    }, {
        duration = 0.2,
        completion = function()
            self._overlayView:removeFromSuperview()
            self:removeFromSuperview()
        end
    })
end

return Alert