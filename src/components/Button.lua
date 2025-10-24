-- iOS-style Button
local View = require(script.Parent.Parent.core.View)
local Theme = require(script.Parent.Parent.theme.Theme)
local Colors = require(script.Parent.Parent.theme.Colors)
local Typography = require(script.Parent.Parent.theme.Typography)
local Haptic = require(script.Parent.Parent.utils.Haptic)
local Spring = require(script.Parent.Parent.animation.Spring)

local Button = {}
Button.__index = Button
setmetatable(Button, {__index = View})

Button.ButtonType = {
    System = "system",
    DetailDisclosure = "detailDisclosure", 
    InfoLight = "infoLight",
    InfoDark = "infoDark",
    ContactAdd = "contactAdd",
    Plain = "plain",
    RoundedRect = "roundedRect"
}

function Button.new(title, type)
    local self = setmetatable(View.new(), Button)
    
    -- Button type
    self.buttonType = type or Button.ButtonType.System
    
    -- Title
    self.title = title or ""
    self.attributedTitle = nil
    
    -- Colors based on type
    if self.buttonType == Button.ButtonType.System then
        self.titleColor = Colors.systemBlue
        self.highlightedTitleColor = Colors.systemBlue
        self.backgroundColor = Colors.clear
    elseif self.buttonType == Button.ButtonType.RoundedRect then
        self.titleColor = Colors.systemBlue
        self.backgroundColor = Colors.systemGray6
        self.cornerRadius = 8
    else
        self.titleColor = Colors.label
        self.backgroundColor = Colors.clear
    end
    
    -- States
    self.enabled = true
    self.highlighted = false
    self.selected = false
    
    -- Typography
    self.font = Typography.body
    self.adjustsFontSizeToFitWidth = false
    
    -- Layout
    self.contentEdgeInsets = {top = 6, left = 12, bottom = 6, right = 12}
    self.titleEdgeInsets = {top = 0, left = 0, bottom = 0, right = 0}
    self.imageEdgeInsets = {top = 0, left = 0, bottom = 0, right = 0}
    
    -- Image
    self.image = nil
    self.highlightedImage = nil
    
    -- Callbacks
    self.onTouchDown = nil
    self.onTouchUpInside = nil
    self.onTouchUpOutside = nil
    self.onTouchCancel = nil
    
    -- Internal
    self._titleLabel = nil
    self._imageView = nil
    self._isTracking = false
    self._touchStartPoint = nil
    
    self:setupButton()
    
    return self
end

function Button:setupButton()
    -- Create title label
    local Label = require(script.Parent.Label)
    self._titleLabel = Label.new(self.title)
    self._titleLabel.textColor = self.titleColor
    self._titleLabel.font = self.font
    self._titleLabel.textAlignment = "center"
    self:addSubview(self._titleLabel)
    
    -- Setup default size
    self:sizeToFit()
end

function Button:setTitle(title, state)
    self.title = title
    if self._titleLabel then
        self._titleLabel.text = title
    end
    self:setNeedsLayout()
end

function Button:setTitleColor(color, state)
    if state == "normal" or not state then
        self.titleColor = color
        if self._titleLabel and not self.highlighted then
            self._titleLabel.textColor = color
        end
    elseif state == "highlighted" then
        self.highlightedTitleColor = color
    end
end

function Button:setImage(image, state)
    if state == "normal" or not state then
        self.image = image
    elseif state == "highlighted" then
        self.highlightedImage = image
    end
    self:setNeedsLayout()
end

function Button:layoutSubviews()
    View.layoutSubviews(self)
    
    -- Layout title label
    if self._titleLabel then
        local insets = self.contentEdgeInsets
        self._titleLabel.frame = {
            x = insets.left + self.titleEdgeInsets.left,
            y = insets.top + self.titleEdgeInsets.top,
            width = self.frame.width - insets.left - insets.right - self.titleEdgeInsets.left - self.titleEdgeInsets.right,
            height = self.frame.height - insets.top - insets.bottom - self.titleEdgeInsets.top - self.titleEdgeInsets.bottom
        }
    end
    
    -- Layout image if present
    if self._imageView and self.image then
        -- Position image to the left of title
        -- Implementation depends on button style
    end
end

function Button:sizeThatFits(size)
    local titleSize = self._titleLabel:sizeThatFits(size)
    local insets = self.contentEdgeInsets
    
    return {
        width = titleSize.width + insets.left + insets.right,
        height = math.max(titleSize.height + insets.top + insets.bottom, 44) -- iOS minimum touch target
    }
end

-- Touch handling
function Button:touchesBegan(touches, event)
    if not self.enabled then return end
    
    self._isTracking = true
    self._touchStartPoint = touches[1]
    self.highlighted = true
    
    -- Haptic feedback
    Haptic.impact("light")
    
    -- Visual feedback
    Spring.animate(self, {
        transform = {scaleX = 0.95, scaleY = 0.95}
    }, {duration = 0.1})
    
    -- Update colors
    if self._titleLabel then
        self._titleLabel.textColor = self.highlightedTitleColor or self.titleColor
    end
    
    if self.onTouchDown then
        self.onTouchDown(self)
    end
end

function Button:touchesMoved(touches, event)
    if not self._isTracking then return end
    
    local point = touches[1]
    local inside = self:pointInside(point)
    
    if inside ~= self.highlighted then
        self.highlighted = inside
        if inside then
            Spring.animate(self, {
                transform = {scaleX = 0.95, scaleY = 0.95}
            }, {duration = 0.1})
        else
            Spring.animate(self, {
                transform = {scaleX = 1, scaleY = 1}
            }, {duration = 0.1})
        end
    end
end

function Button:touchesEnded(touches, event)
    if not self._isTracking then return end
    
    self._isTracking = false
    self.highlighted = false
    
    -- Reset visual state
    Spring.animate(self, {
        transform = {scaleX = 1, scaleY = 1}
    }, {duration = 0.2, damping = 0.8})
    
    -- Reset colors
    if self._titleLabel then
        self._titleLabel.textColor = self.titleColor
    end
    
    local point = touches[1]
    if self:pointInside(point) then
        if self.onTouchUpInside then
            self.onTouchUpInside(self)
        end
    else
        if self.onTouchUpOutside then
            self.onTouchUpOutside(self)
        end
    end
end

function Button:touchesCancelled(touches, event)
    if not self._isTracking then return end
    
    self._isTracking = false
    self.highlighted = false
    
    Spring.animate(self, {
        transform = {scaleX = 1, scaleY = 1}
    }, {duration = 0.2})
    
    if self._titleLabel then
        self._titleLabel.textColor = self.titleColor
    end
    
    if self.onTouchCancel then
        self.onTouchCancel(self)
    end
end

return Button