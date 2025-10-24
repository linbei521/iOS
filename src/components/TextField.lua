-- iOS-style TextField
local View = require(script.Parent.Parent.core.View)
local Theme = require(script.Parent.Parent.theme.Theme)
local Colors = require(script.Parent.Parent.theme.Colors)
local Typography = require(script.Parent.Parent.theme.Typography)

local TextField = {}
TextField.__index = TextField
setmetatable(TextField, {__index = View})

TextField.BorderStyle = {
    None = "none",
    Line = "line",
    Bezel = "bezel",
    RoundedRect = "roundedRect"
}

TextField.KeyboardType = {
    Default = "default",
    NumberPad = "numberPad",
    PhonePad = "phonePad",
    EmailAddress = "emailAddress",
    URL = "url",
    NumbersAndPunctuation = "numbersAndPunctuation"
}

function TextField.new()
    local self = setmetatable(View.new(), TextField)
    
    -- Text properties
    self.text = ""
    self.placeholder = ""
    self.textColor = Colors.label
    self.placeholderColor = Colors.tertiaryLabel
    self.font = Typography.body
    self.textAlignment = "left"
    
    -- Border style
    self.borderStyle = TextField.BorderStyle.RoundedRect
    self.cornerRadius = 8
    self.borderWidth = 1
    self.borderColor = Colors.systemGray4
    
    -- Background
    self.backgroundColor = Colors.systemBackground
    
    -- Keyboard
    self.keyboardType = TextField.KeyboardType.Default
    self.returnKeyType = "default"
    self.secureTextEntry = false
    self.autocorrectionType = "default"
    self.autocapitalizationType = "sentences"
    
    -- State
    self.editing = false
    self.enabled = true
    self.clearButtonMode = "whileEditing"
    
    -- Insets
    self.textInsets = {left = 12, right = 12, top = 8, bottom = 8}
    
    -- Callbacks
    self.onBeginEditing = nil
    self.onEndEditing = nil
    self.onTextChanged = nil
    self.onReturn = nil
    
    -- Internal
    self._textBox = nil
    self._placeholderLabel = nil
    self._clearButton = nil
    
    self:setupTextField()
    
    return self
end

function TextField:setupTextField()
    -- Create TextBox
    self._textBox = Instance.new("TextBox")
    self._textBox.Text = self.text
    self._textBox.TextColor3 = Color3.new(self.textColor.r, self.textColor.g, self.textColor.b)
    self._textBox.PlaceholderText = self.placeholder
    self._textBox.PlaceholderColor3 = Color3.new(self.placeholderColor.r, self.placeholderColor.g, self.placeholderColor.b)
    self._textBox.Font = Enum.Font[self.font.family] or Enum.Font.Gotham
    self._textBox.TextSize = self.font.size
    self._textBox.TextXAlignment = Enum.TextXAlignment[self.textAlignment:gsub("^%l", string.upper)]
    self._textBox.BackgroundTransparency = 1
    self._textBox.ClearTextOnFocus = false
    
    -- Handle text changes
    self._textBox:GetPropertyChangedSignal("Text"):Connect(function()
        self.text = self._textBox.Text
        if self.onTextChanged then
            self.onTextChanged(self, self.text)
        end
        self:updateClearButton()
    end)
    
    -- Handle focus
    self._textBox.Focused:Connect(function()
        self.editing = true
        self:animateFocus(true)
        if self.onBeginEditing then
            self.onBeginEditing(self)
        end
    end)
    
    self._textBox.FocusLost:Connect(function(enterPressed)
        self.editing = false
        self:animateFocus(false)
        if self.onEndEditing then
            self.onEndEditing(self)
        end
        if enterPressed and self.onReturn then
            self.onReturn(self)
        end
    end)
    
    -- Setup clear button
    if self.clearButtonMode ~= "never" then
        self:setupClearButton()
    end
    
    -- Default size
    self.frame = {x = 0, y = 0, width = 200, height = 44}
end

function TextField:setupClearButton()
    local Button = require(script.Parent.Button)
    self._clearButton = Button.new("×")
    self._clearButton.backgroundColor = Colors.systemGray5
    self._clearButton.titleColor = Colors.systemGray
    self._clearButton.cornerRadius = 8
    self._clearButton.frame = {x = 0, y = 0, width = 20, height = 20}
    self._clearButton.hidden = true
    
    self._clearButton.onTouchUpInside = function()
        self.text = ""
        self._textBox.Text = ""
        self:updateClearButton()
    end
    
    self:addSubview(self._clearButton)
end

function TextField:updateClearButton()
    if not self._clearButton then return end
    
    local shouldShow = false
    if self.clearButtonMode == "always" then
        shouldShow = self.text ~= ""
    elseif self.clearButtonMode == "whileEditing" then
        shouldShow = self.editing and self.text ~= ""
    elseif self.clearButtonMode == "unlessEditing" then
        shouldShow = not self.editing and self.text ~= ""
    end
    
    self._clearButton.hidden = not shouldShow
end

function TextField:animateFocus(focused)
    local Spring = require(script.Parent.Parent.animation.Spring)
    
    if focused then
        -- Highlight border
        Spring.animate(self, {
            borderColor = Colors.systemBlue,
            borderWidth = 2
        }, {duration = 0.2})
    else
        -- Normal border
        Spring.animate(self, {
            borderColor = Colors.systemGray4,
            borderWidth = 1
        }, {duration = 0.2})
    end
end

function TextField:layoutSubviews()
    View.layoutSubviews(self)
    
    if self._gui and self._textBox then
        -- Position TextBox with insets
        self._textBox.Position = UDim2.new(0, self.textInsets.left, 0, self.textInsets.top)
        
        local clearButtonWidth = 0
        if self._clearButton and not self._clearButton.hidden then
            clearButtonWidth = 30
            self._clearButton.frame = {
                x = self.frame.width - clearButtonWidth - 8,
                y = (self.frame.height - 20) / 2,
                width = 20,
                height = 20
            }
        end
        
        self._textBox.Size = UDim2.new(
            1, 
            -(self.textInsets.left + self.textInsets.right + clearButtonWidth),
            1,
            -(self.textInsets.top + self.textInsets.bottom)
        )
        
        self._textBox.Parent = self._gui
    end
end

function TextField:setText(text)
    self.text = text
    if self._textBox then
        self._textBox.Text = text
    end
    self:updateClearButton()
end

function TextField:setPlaceholder(placeholder)
    self.placeholder = placeholder
    if self._textBox then
        self._textBox.PlaceholderText = placeholder
    end
end

function TextField:becomeFirstResponder()
    if self._textBox then
        self._textBox:CaptureFocus()
    end
end

function TextField:resignFirstResponder()
    if self._textBox then
        self._textBox:ReleaseFocus()
    end
end

return TextField