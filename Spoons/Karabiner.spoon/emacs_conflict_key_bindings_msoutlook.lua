return {
	name = "Emacs Conflict Keybindings for MS Outlook",
	shared_conditions = {
		{
			bundle_identifiers = { "^com\\.microsoft\\.Outlook$" },
			type = "frontmost_application_if",
		},
	},
	bindings = {
		{
			from = { "semicolon", { "control" } },
			to = { { "e", { "control" } } },
		},
	},
}
