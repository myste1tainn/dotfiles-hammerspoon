return {
	name = "Emacs Keybindings",
	shared_conditions = {
		{
			bundle_identifiers = {
				"^dev\\.zed\\.Zed$",
				"^com\\.apple\\.Terminal$",
				"^com\\.googlecode\\.iterm2$",
				"^com\\.github\\.wez\\.wezterm$",
				"^org\\.alacritty$",
				"^net\\.kovidgoyal\\.kitty$",
				"^org\\.gnu\\.Emacs$",
			},
			type = "frontmost_application_unless",
		},
	},
	bindings = {
		{
			kind = "movement",
			from = { "b", { "control" } },
			to = { { "left_arrow" } },
		},
		{
			kind = "movement",
			from = { "b", { "option" } },
			to = { { "left_arrow", { "option" } } },
		},
		{
			kind = "movement",
			from = { "f", { "control" } },
			to = { { "right_arrow" } },
		},
		{
			kind = "movement",
			from = { "f", { "option" } },
			to = { { "right_arrow", { "option" } } },
		},
		{
			kind = "movement",
			from = { "p", { "control" } },
			to = { { "up_arrow" } },
		},
		{
			kind = "movement",
			from = { "n", { "control" } },
			to = { { "down_arrow" } },
		},
		{
			kind = "movement",
			from = { "a", { "control" } },
			to = { { "home" } },
		},
		{
			kind = "movement",
			from = { "e", { "control" } },
			to = { { "end" } },
		},
		{
			kind = "movement",
			from = { "v", { "control" } },
			to = { { "page_up" } },
		},
		{
			kind = "movement",
			from = { "v", { "option" } },
			to = { { "page_down" } },
		},
		{
			kind = "movement",
			from = { "period", { "option" } },
			to = { { "down_arrow", { "command" } } },
		},
		{
			kind = "movement",
			from = { "comma", { "option" } },
			to = { { "up_arrow", { "command" } } },
		},
		{
			kind = "editing",
			from = { "w", { "control" } },
			to = { { "delete_or_backspace", { "option" } } },
		},
		{
			kind = "editing",
			from = { "d", { "control" } },
			to = { { "delete_forward" } },
		},
		{
			kind = "editing",
			from = { "h", { "control" } },
			to = { { "delete_or_backspace" } },
		},
		{
			kind = "editing",
			from = { "k", { "control" } },
			to = { { "right_arrow", { "shift", "command" } }, { "delete_or_backspace" } },
		},
		{
			kind = "editing",
			from = { "u", { "control" } },
			to = { { "left_arrow", { "shift", "command" } }, { "delete_or_backspace" } },
		},
	},
}
