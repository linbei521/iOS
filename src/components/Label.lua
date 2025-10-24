-- iOS-style Label
local View = require(script.Parent.Parent.core.View)
local Colors = require(script.Parent.Parent.theme.Colors)
local Typography = require(script.Parent.Parent.theme.Typography)

local Label = {}
Label.__index = Label
setmetatable(Label, {__index = View})

function Label.new(text)
    local self = setmetatable(View.new(), Label)
    
    -- Text properties
    self.text = text or ""
    self.textColor = Colors.label
    self.font = Typography.body
    self.textAlignment = "left"
    self.lineBreakMode = "wordWrap"
    self.numberOfLines = 1
    self.adjustsFontSizeToFitWidth = false
    self.minimumScaleFactor = 0
    self.preferredMaxLayoutWidth = 0
    
    -- Attributed text
    self.attributedText = nil
    
    -- Background
    self.backgroundColor = Colors.clear
    
    -- Internal
    self._textLabel = nil
    
    self:setupLabel()
    
    return self
end

function Label:setupLabel()
    -- Will be rendered as TextLabel in Roblox
    self.userInteractionEnabled = false
end

function Label:setText(text)
    self.text = text
    self:setNeedsDisplay()
end

function Label:setTextColor(color)
    self.textColor = color
    self:setNeedsDisplay()
end

function Label:setFont(font)
    self.font = font
    self:setNeedsDisplay()
end

function Label:sizeThatFits(size)
    -- Calculate text size
    -- This is simplified - in real implementation would use TextService
    local lines = self.numberOfLines == 0 and math.huge or self.numberOfLines
    local lineHeight = self.font.size * 1.2
    local height = math.min(lines * lineHeight, size.height)
    
    return {
        width = size.width,
        height = height
    }
end

function Label:createGui()
    if not self._textLabel then
        self._textLabel = Instance.new("TextLabel")
    end
    
    self._textLabel.Text = self.text
    self._textLabel.TextColor3 = Color3.new(self.textColor.r, self.textColor.g, self.textColor.b)
    self._textLabel.Font = Enum.Font[self.font.family] or Enum.Font.Gotham
    self._textLabel.TextSize = self.font.size
    self._textLabel.TextXAlignment = Enum.TextXAlignment[self.textAlignment:gsub("^%l", string.upper)]
    self._textLabel.TextWrapped = self.lineBreakMode == "wordWrap"
    self._textLabel.BackgroundTransparency = 1
    self._textLabel.TextScaled = self.adjustsFontSizeToFitWidth
    
    return self._textLabel
end

return Label