return {
	name = "Emacs Conflict Keybindings for MS Excel",
	shared_conditions = {
		{
			bundle_identifiers = { "^com\\.microsoft\\.Excel$" },
			type = "frontmost_application_if",
		},
	},
	bindings = {
		{
			from = { "semicolon", { "control" } },
			to = { { "u", { "control" } } },
		},
	},
}
