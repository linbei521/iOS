-- Basic iOS App Example
local iOSUI = require(game.ReplicatedStorage.iOSUI)

-- Create window
local window = iOSUI.Window.new()

-- Create navigation bar
local navBar = iOSUI.NavigationBar.new()
navBar:setTitle("My App")

-- Add back button
navBar:setLeftBarButtonItem({
    title = "Back",
    action = function()
        print("Back pressed")
    end
})

-- Add settings button
navBar:setRightBarButtonItem({
    title = "Settings",
    action = function()
        print("Settings pressed")
    end
})

window:addSubview(navBar)

-- Create content
local scrollView = iOSUI.ScrollView.new()
scrollView.frame = {
    x = 0,
    y = navBar.frame.height,
    width = window.frame.width,
    height = window.frame.height - navBar.frame.height
}

-- Add button
local button = iOSUI.Button.new("Tap Me", iOSUI.Button.ButtonType.RoundedRect)
button.frame = {x = 20, y = 20, width = 335, height = 44}
button.onTouchUpInside = function()
    -- Show alert
    local alert = iOSUI.Alert.new(
        "Success",
        "Button was tapped!",
        iOSUI.Alert.Style.Alert
    )
    alert:addAction("OK", iOSUI.Alert.ActionStyle.Default)
    alert:present(window)
end
scrollView:addSubview(button)

-- Add text field
local textField = iOSUI.TextField.new()
textField.placeholder = "Enter your name"
textField.frame = {x = 20, y = 84, width = 335, height = 44}
scrollView:addSubview(textField)

-- Add switch
local switch = iOSUI.Switch.new()
switch.frame = {x = 20, y = 148, width = 51, height = 31}
switch.onValueChanged = function(sw, value)
    print("Switch is now:", value and "ON" or "OFF")
end
scrollView:addSubview(switch)

-- Add label next to switch
local label = iOSUI.Label.new("Enable notifications")
label.frame = {x = 81, y = 153, width = 200, height = 21}
scrollView:addSubview(label)

window:addSubview(scrollView)

-- Present window
window:present()

return window