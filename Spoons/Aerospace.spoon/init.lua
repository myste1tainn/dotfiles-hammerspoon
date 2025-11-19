---- This script manages keyboard layouts and monitors in a macOS environment using Hammerspoon
--- to allow the aeruspace shortcut to reflect the current keyboard layout, since aerospace maps the key
--- literals to the current keyboard layout, and it is not possible to change the layout in aerospace, dynamically
--- without having to edit the config file manually.
local function rebuildAeroConfig(layout)
	local basePath = os.getenv("HOME") .. "/aerospace-configs/"
	local layoutFile = basePath .. "layouts/" .. layout .. ".toml"
	local baseFile = basePath .. "base.toml"
	local targetFile = os.getenv("HOME") .. "/.aerospace.toml"

	local cmd = string.format('cat "%s" "%s" > "%s"', baseFile, layoutFile, targetFile)

	hs.execute(cmd)
	hs.execute("/opt/homebrew/bin/aerospace reload-config")
end

local function onLayoutChanged()
	local layoutId = hs.keycodes.currentSourceID()
	if layoutId:find("Dvorak") then
		rebuildAeroConfig("dvorak")
	else
		rebuildAeroConfig("qwerty")
	end
end

local M = {}
function M:init()
	-- Attach to input source change event
	hs.keycodes.inputSourceChanged(onLayoutChanged)

	hs.hotkey.bind({ "cmd", "alt" }, "C", function()
		local win = hs.window.focusedWindow()
		if win then
			win:centerOnScreen()
		end
	end)
end
return M
