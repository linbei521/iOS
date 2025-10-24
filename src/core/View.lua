-- iOS-style base view class
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local View = {}
View.__index = View

function View.new(frame)
    local self = setmetatable({}, View)
    
    -- iOS-style properties
    self.frame = frame or {x = 0, y = 0, width = 100, height = 50}
    self.bounds = {x = 0, y = 0, width = self.frame.width, height = self.frame.height}
    self.center = {x = self.frame.x + self.frame.width/2, y = self.frame.y + self.frame.height/2}
    
    -- Appearance
    self.backgroundColor = {r = 1, g = 1, b = 1, a = 1}
    self.borderColor = {r = 0.8, g = 0.8, b = 0.8, a = 1}
    self.borderWidth = 0
    self.cornerRadius = 0
    self.clipsToBounds = false
    
    -- Visual effects
    self.alpha = 1
    self.hidden = false
    self.shadowColor = {r = 0, g = 0, b = 0, a = 0.2}
    self.shadowOffset = {width = 0, height = 2}
    self.shadowRadius = 4
    self.shadowOpacity = 0
    
    -- Interaction
    self.userInteractionEnabled = true
    self.multipleTouchEnabled = false
    
    -- Transform
    self.transform = {
        scaleX = 1,
        scaleY = 1,
        rotation = 0,
        translationX = 0,
        translationY = 0
    }
    
    -- Hierarchy
    self.superview = nil
    self.subviews = {}
    self.tag = 0
    
    -- Auto Layout
    self.translatesAutoresizingMaskIntoConstraints = true
    self.constraints = {}
    self.contentMode = "scaleToFill"
    
    -- Internal
    self._gui = nil
    self._needsLayout = true
    self._needsDisplay = true
    self._gestureRecognizers = {}
    self._animations = {}
    
    return self
end

function View:addSubview(view)
    if view.superview then
        view:removeFromSuperview()
    end
    table.insert(self.subviews, view)
    view.superview = self
    self:setNeedsLayout()
    self:setNeedsDisplay()
end

function View:removeFromSuperview()
    if self.superview then
        for i, v in ipairs(self.superview.subviews) do
            if v == self then
                table.remove(self.superview.subviews, i)
                break
            end
        end
        self.superview = nil
        if self._gui then
            self._gui:Destroy()
            self._gui = nil
        end
    end
end

function View:insertSubview(view, index)
    if view.superview then
        view:removeFromSuperview()
    end
    table.insert(self.subviews, index, view)
    view.superview = self
    self:setNeedsLayout()
end

function View:bringSubviewToFront(view)
    for i, v in ipairs(self.subviews) do
        if v == view then
            table.remove(self.subviews, i)
            table.insert(self.subviews, view)
            self:setNeedsDisplay()
            break
        end
    end
end

function View:sendSubviewToBack(view)
    for i, v in ipairs(self.subviews) do
        if v == view then
            table.remove(self.subviews, i)
            table.insert(self.subviews, 1, view)
            self:setNeedsDisplay()
            break
        end
    end
end

function View:setNeedsLayout()
    self._needsLayout = true
end

function View:setNeedsDisplay()
    self._needsDisplay = true
end

function View:layoutSubviews()
    -- Override in subclasses
end

function View:layoutIfNeeded()
    if self._needsLayout then
        self:layoutSubviews()
        self._needsLayout = false
        for _, subview in ipairs(self.subviews) do
            subview:layoutIfNeeded()
        end
    end
end

function View:sizeThatFits(size)
    return {width = self.frame.width, height = self.frame.height}
end

function View:sizeToFit()
    local size = self:sizeThatFits({width = math.huge, height = math.huge})
    self.frame.width = size.width
    self.frame.height = size.height
    self:setNeedsLayout()
end

-- Touch handling
function View:hitTest(point)
    if self.hidden or not self.userInteractionEnabled or self.alpha < 0.01 then
        return nil
    end
    
    if not self:pointInside(point) then
        return nil
    end
    
    -- Check subviews from front to back
    for i = #self.subviews, 1, -1 do
        local subview = self.subviews[i]
        local convertedPoint = self:convertPoint(point, subview)
        local hitView = subview:hitTest(convertedPoint)
        if hitView then
            return hitView
        end
    end
    
    return self
end

function View:pointInside(point)
    return point.x >= 0 and point.x <= self.frame.width and
           point.y >= 0 and point.y <= self.frame.height
end

function View:convertPoint(point, toView)
    -- Convert point from self's coordinate system to toView's
    local x = point.x + self.frame.x
    local y = point.y + self.frame.y
    
    if toView then
        x = x - toView.frame.x
        y = y - toView.frame.y
    end
    
    return {x = x, y = y}
end

-- Animation support
function View:animateWithDuration(duration, animations, completion)
    local Animator = require(script.Parent.Parent.animation.Animator)
    return Animator.animate(self, duration, animations, completion)
end

-- Gesture recognizers
function View:addGestureRecognizer(recognizer)
    table.insert(self._gestureRecognizers, recognizer)
    recognizer.view = self
end

function View:removeGestureRecognizer(recognizer)
    for i, gr in ipairs(self._gestureRecognizers) do
        if gr == recognizer then
            table.remove(self._gestureRecognizers, i)
            recognizer.view = nil
            break
        end
    end
end

return View