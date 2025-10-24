-- iOS-style Switch (Toggle)
local View = require(script.Parent.Parent.core.View)
local Colors = require(script.Parent.Parent.theme.Colors)
local Spring = require(script.Parent.Parent.animation.Spring)
local Haptic = require(script.Parent.Parent.utils.Haptic)

local Switch = {}
Switch.__index = Switch
setmetatable(Switch, {__index = View})

function Switch.new()
    local self = setmetatable(View.new(), Switch)
    
    -- Switch properties
    self.on = false
    self.enabled = true
    
    -- Colors
    self.onTintColor = Colors.systemGreen
    self.thumbTintColor = Colors.white
    self.offTintColor = Colors.systemGray5
    
    -- Size (iOS standard)
    self.frame = {x = 0, y = 0, width = 51, height = 31}
    self.cornerRadius = 15.5
    
    -- Callbacks
    self.onValueChanged = nil
    
    -- Internal
    self._thumb = nil
    self._background = nil
    self._isAnimating = false
    
    self:setupSwitch()
    
    return self
end

function Switch:setupSwitch()
    -- Background
    self._background = View.new()
    self._background.frame = {x = 0, y = 0, width = 51, height = 31}
    self._background.backgroundColor = self.offTintColor
    self._background.cornerRadius = 15.5
    self:addSubview(self._background)
    
    -- Thumb
    self._thumb = View.new()
    self._thumb.frame = {x = 2, y = 2, width = 27, height = 27}
    self._thumb.backgroundColor = self.thumbTintColor
    self._thumb.cornerRadius = 13.5
    self._thumb.shadowColor = {r = 0, g = 0, b = 0, a = 0.25}
    self._thumb.shadowOffset = {width = 0, height = 2}
    self._thumb.shadowRadius = 4
    self._thumb.shadowOpacity = 0.3
    self:addSubview(self._thumb)
    
    self:updateVisualState(false)
end

function Switch:setOn(on, animated)
    if self.on == on then return end
    
    self.on = on
    
    if animated then
        self:animateSwitch(on)
    else
        self:updateVisualState(false)
    end
    
    if self.onValueChanged then
        self.onValueChanged(self, on)
    end
end

function Switch:updateVisualState(animated)
    local thumbX = self.on and 22 or 2
    local bgColor = self.on and self.onTintColor or self.offTintColor
    
    if animated then
        Spring.animate(self._thumb, {
            frame = {x = thumbX, y = 2, width = 27, height = 27}
        }, {duration = 0.3, damping = 0.8})
        
        Spring.animate(self._background, {
            backgroundColor = bgColor
        }, {duration = 0.3})
    else
        self._thumb.frame.x = thumbX
        self._background.backgroundColor = bgColor
    end
end

function Switch:animateSwitch(on)
    if self._isAnimating then return end
    self._isAnimating = true
    
    -- Haptic feedback
    Haptic.impact("light")
    
    -- Animate thumb position and background color
    self:updateVisualState(true)
    
    -- Reset animation flag
    task.wait(0.3)
    self._isAnimating = false
end

function Switch:touchesEnded(touches, event)
    if not self.enabled or self._isAnimating then return end
    
    local point = touches[1]
    if self:pointInside(point) then
        self:setOn(not self.on, true)
    end
end

return Switch