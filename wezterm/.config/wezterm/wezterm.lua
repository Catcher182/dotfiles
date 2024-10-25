local wezterm = require("wezterm")
local pzfont = require("pzfont")
local pzcolor = require("pzcolor")
local config = wezterm.config_builder()

pzfont.apply_to_config(config)
pzcolor.apply_to_config(config)

-- config.window_background_opacity = 0.95
config.window_background_opacity = 1.0

config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
-- config.color_scheme = "Dracula"
-- config.color_scheme = "ayu_light"

config.keys = {
	-- This will create a new split and run your default program inside it
	{
		key = "Return",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = ">",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
	{
		key = "<",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Prev"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

config.pane_focus_follows_mouse = true

config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}

config.command_palette_font_size = 12
config.char_select_font_size = 10
config.warn_about_missing_glyphs = false

-- if os.getenv("XDG_CURRENT_DESKTOP") == "Hyprland" then
-- 	config.enable_wayland = false
-- else
-- 	config.enable_wayland = true
-- end

return config
