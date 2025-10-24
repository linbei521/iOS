-- Roblox iOS UI Library
-- Main entry point

local iOSUI = {}

-- Core
iOSUI.View = require(script.core.View)
iOSUI.Window = require(script.core.Window)
iOSUI.Renderer = require(script.core.Renderer)

-- Components
iOSUI.Button = require(script.components.Button)
iOSUI.TextField = require(script.components.TextField)
iOSUI.Switch = require(script.components.Switch)
iOSUI.NavigationBar = require(script.components.NavigationBar)
iOSUI.TabBar = require(script.components.TabBar)
iOSUI.Alert = require(script.components.Alert)
iOSUI.ScrollView = require(script.components.ScrollView)
iOSUI.TableView = require(script.components.TableView)
iOSUI.Label = require(script.components.Label)

-- Layout
iOSUI.Constraints = require(script.layout.Constraints)
iOSUI.SafeArea = require(script.layout.SafeArea)
iOSUI.StackView = require(script.layout.StackView)

-- Animation
iOSUI.Spring = require(script.animation.Spring)
iOSUI.Animator = require(script.animation.Animator)
iOSUI.Transitions = require(script.animation.Transitions)

-- Theme
iOSUI.Theme = require(script.theme.Theme)
iOSUI.Colors = require(script.theme.Colors)
iOSUI.Typography = require(script.theme.Typography)

-- Utils
iOSUI.Device = require(script.utils.Device)
iOSUI.Touch = require(script.utils.Touch)
iOSUI.Haptic = require(script.utils.Haptic)

-- Version
iOSUI.VERSION = "1.0.0"

return iOSUI
