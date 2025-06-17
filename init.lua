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

-- Attach to input source change event
hs.keycodes.inputSourceChanged(onLayoutChanged)

---- This script make sure that the VITURE monitor is not used by any windows when the Spacewalker app is activated.
local bannedMonitorName = "VITURE"
local triggerAppName = "Spacewalker"
local fallbackScreen = hs.screen.primaryScreen()

-- Move all windows off banned monitor
local function evacuateBannedMonitor()
	local bannedScreen = hs.screen.find(bannedMonitorName)
	if not bannedScreen then
		return
	end

	for _, win in ipairs(hs.window.allWindows()) do
		if win:screen() == bannedScreen then
			win:moveToScreen(fallbackScreen)
		end
	end
end

-- Enforce rule when trigger app becomes frontmost
local function appWatcher(appName, eventType, appObject)
	if appName == triggerAppName and eventType == hs.application.watcher.activated then
		evacuateBannedMonitor()
	end
end

-- Also enforce rule when screen config changes (i.e., VITURE plugged in)
hs.screen.watcher.new(evacuateBannedMonitor):start()

-- Watch for app events
local appwatcher = hs.application.watcher.new(appWatcher)
appwatcher:start()

-- Optional: Run once on startup
evacuateBannedMonitor()
