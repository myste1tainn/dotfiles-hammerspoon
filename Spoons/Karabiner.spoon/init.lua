local M = {}
function M:init() end

local function copy_list(t)
	local out = {}
	for i = 1, #t do
		out[i] = t[i]
	end
	return out
end
local function deep_copy(orig, seen)
	if type(orig) ~= "table" then
		return orig
	end

	seen = seen or {}
	if seen[orig] then
		return seen[orig]
	end

	local copy = {}
	seen[orig] = copy

	for k, v in pairs(orig) do
		copy[deep_copy(k, seen)] = deep_copy(v, seen)
	end

	return setmetatable(copy, getmetatable(orig))
end

function M:run()
	print("[Debug] Rebuliding Karabiner Config...")
	local layout = hs.keycodes.currentSourceID():find("Dvorak") and "dvorak" or "qwerty"

	-- Rebuild karabiner.json for both layouts
	local basePath = os.getenv("HOME") .. "/.config/karabiner/"

	-- Reads the taget file
	local targetFile = os.getenv("HOME") .. "/.config/karabiner/karabiner.json"
	local file = io.open(targetFile, "r")
	if not file then
		hs.alert.show("Failed to open karabiner.json")
		return
	end
	local config = hs.json.decode(file:read("*a")) or { profiles = {} }
	local find_result = {}
	for i, profile in ipairs(config.profiles) do
		profile.selected = false
		if profile.name == "DVORAK Generated Profile" then
			find_result["dvorak"] = i
		elseif profile.name == "QWERTY Generated Profile" then
			find_result["qwerty"] = i
		end
	end

	local prof = {
		complex_modifications = {
			rules = {},
		},
		virtual_hid_keyboard = {
			country_code = 0,
			keyboard_type_v2 = "ansi",
		},
		simple_modifications = {
			{
				from = { key_code = "caps_lock" },
				to = { { key_code = "delete_or_backspace" } },
			},
			{
				from = { key_code = "right_command" },
				to = { { key_code = "left_command" } },
			},
			{
				from = { key_code = "right_option" },
				to = { { key_code = "left_option" } },
			},
			{
				from = { key_code = "right_control" },
				to = { { key_code = "left_control" } },
			},
			{
				from = { key_code = "right_shift" },
				to = { { key_code = "left_shift" } },
			},
		},
	}
	local profile = { qwerty = prof, dvorak = deep_copy(prof) }
	profile.qwerty.name = "QWERTY Generated Profile"
	profile.dvorak.name = "DVORAK Generated Profile"
	local qwerty_to_dvorak_map = dofile(hs.spoons.resourcePath("helpers/dvorak_to_qwerty_map.lua"))
	local function create_key_binding(t, ks, l, mod)
		local result = {}
		for _, k in ipairs(ks) do
			local modifiers = copy_list(k[2] or {})
			if mod then
				for _, m in ipairs(mod) do
					table.insert(modifiers, m)
				end
			end
			table.insert(result, {
				key_code = l == "qwerty" and k[1] or qwerty_to_dvorak_map[k[1]] or k[1],
				modifiers = t == "from" and { mandatory = modifiers } or modifiers,
			})
		end
		return result
	end
	local mapping_rules = {
		dofile(hs.spoons.resourcePath("emacs_key_bindings.lua")),
		dofile(hs.spoons.resourcePath("emacs_conflict_key_bindings_msoutlook.lua")),
		dofile(hs.spoons.resourcePath("emacs_conflict_key_bindings_msexcel.lua")),
	}
	for _, l in ipairs({ "qwerty", "dvorak" }) do
		for _, mr in ipairs(mapping_rules) do
			local rule = { description = mr.name, manipulators = {} }
			for _, binding in ipairs(mr.bindings) do
				table.insert(rule.manipulators, {
					type = "basic",
					conditions = mr.shared_conditions,
					from = create_key_binding("from", { binding.from }, l)[1],
					to = create_key_binding("to", binding.to, l),
				})
				if binding.kind == "movement" then
					-- Add shift version for selection
					table.insert(rule.manipulators, {
						type = "basic",
						conditions = mr.shared_conditions,
						from = create_key_binding("from", { binding.from }, l, { "shift" })[1],
						to = create_key_binding("to", binding.to, l, { "shift" }),
					})
				end
			end
			table.insert(profile[l].complex_modifications.rules, rule)
		end
		profile[l].selected = layout == l
		if find_result[l] then
			config.profiles[find_result[l]] = profile[l]
		else
			table.insert(config.profiles, profile[l])
		end
	end

	-- Write back to karabiner.json
	local file_write = io.open(targetFile, "w")
	if not file_write then
		hs.alert.show("Failed to open karabiner.json for writing")
		return
	end
	file_write:write(hs.json.encode(config))
	file_write:flush()
	file_write:close()
end

return M
