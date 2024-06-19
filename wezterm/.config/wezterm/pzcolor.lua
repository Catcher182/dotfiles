-- I am helpers.lua and I should live in ~/.config/wezterm/helpers.lua

local wezterm = require("wezterm")

-- This is the module table that we will export
local module = {}

local appearance

local success, colorscheme = pcall(require, "colorscheme")
if success and colorscheme.appearance then
	appearance = colorscheme.appearance
else
	appearance = "light"
end

function get_appearance()
	if appearance == "dark" then
		appearance = "Dark"
	elseif appearance == "light" then
		appearance = "Light"
	elseif wezterm.gui then
		appearance = wezterm.gui.get_appearance()
	else
		appearance = "Dark"
	end
end

function module.apply_to_config(config)
	get_appearance()
	if appearance == "Dark" then
		config.color_scheme = "Dracula (Official)"
		config.colors = {
			tab_bar = {
				background = "rgba(0,0,0,0)",
				-- background = "#0b0022",

				active_tab = {
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#8055BC",

					-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
					-- label shown for this tab.
					-- The default is "Normal"
					intensity = "Bold",

					-- Specify whether you want "None", "Single" or "Double" underline for
					-- label shown for this tab.
					-- The default is "None"
					underline = "None",

					-- Specify whether you want the text to be italic (true) or not (false)
					-- for this tab.  The default is false.
					italic = false,

					-- Specify whether you want the text to be rendered with strikethrough (true)
					-- or not for this tab.  The default is false.
					strikethrough = false,
				},

				-- Inactive tabs are the tabs that do not have focus
				inactive_tab = {
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#808080",
					intensity = "Bold",
				},

				-- You can configure some alternate styling when the mouse pointer
				-- moves over inactive tabs
				inactive_tab_hover = {
					-- bg_color = "#3b3052",
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#909090",
					italic = false,
					intensity = "Bold",
				},

				-- The new tab button that let you create new tabs
				new_tab = {
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#808080",
					intensity = "Bold",
				},

				-- You can configure some alternate styling when the mouse pointer
				-- moves over the new tab button
				new_tab_hover = {
					-- bg_color = "#3b3052",
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#909090",
					italic = false,
					intensity = "Bold",
				},
			},
		}
	else
		config.colors = {

			-- The default text color
			foreground = "#000000",
			-- The default background color
			background = "#FDFDFD",

			-- Overrides the cell background color when the current cell is occupied by the
			-- cursor and the cursor style is set to Block
			cursor_bg = "#ff6a00",
			-- Overrides the text color when the current cell is occupied by the cursor
			cursor_fg = "#5c6773",
			-- Specifies the border color of the cursor when the cursor style is set to Block,
			-- or the color of the vertical or horizontal bar when the cursor style is set to
			-- Bar or Underline.
			cursor_border = "#ff6a00",

			-- the foreground color of selected text
			selection_fg = "#000000",
			-- the background color of selected text
			selection_bg = "#94bbe2",

			-- The color of the scrollbar "thumb"; the portion that represents the current viewport
			scrollbar_thumb = "#222222",

			-- The color of the split lines between panes
			split = "rgba(68,68,68,0.5)",

			ansi = {
				"#f5f5f5",
				"#f692a1",
				"#bf360c",
				"#f29918",
				"#7e57c2",
				"#f07178",
				"#2daf99",
				"#3949ab",
			},
			brights = {
				"#323232",
				"#ef5350",
				"#7cb342",
				"#ffa94a",
				"#6a1b9a",
				"#c2185b",
				"#ff6f00",
				"#6a5b3a",
			},

			-- Arbitrary colors of the palette in the range from 16 to 255
			indexed = { [136] = "#af8700" },

			-- Since: 20220319-142410-0fcdea07
			-- When the IME, a dead key or a leader key are being processed and are effectively
			-- holding input pending the result of input composition, change the cursor
			-- to this color to give a visual cue about the compose state.
			compose_cursor = "orange",

			-- Colors for copy_mode and quick_select
			-- available since: 20220807-113146-c2fee766
			-- In copy_mode, the color of the active text is:
			-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
			-- 2. selection_* otherwise
			copy_mode_active_highlight_bg = { Color = "#000000" },
			-- use `AnsiColor` to specify one of the ansi color palette values
			-- (index 0-15) using one of the names "Black", "Maroon", "Green",
			--  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
			-- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
			copy_mode_active_highlight_fg = { AnsiColor = "Black" },
			copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
			copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

			quick_select_label_bg = { Color = "peru" },
			quick_select_label_fg = { Color = "#ffffff" },
			quick_select_match_bg = { AnsiColor = "Navy" },
			quick_select_match_fg = { Color = "#ffffff" },

			tab_bar = {
				background = "rgba(0,0,0,0)",
				-- background = "#0b0022",

				active_tab = {
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#8055BC",

					-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
					-- label shown for this tab.
					-- The default is "Normal"
					intensity = "Bold",

					-- Specify whether you want "None", "Single" or "Double" underline for
					-- label shown for this tab.
					-- The default is "None"
					underline = "None",

					-- Specify whether you want the text to be italic (true) or not (false)
					-- for this tab.  The default is false.
					italic = false,

					-- Specify whether you want the text to be rendered with strikethrough (true)
					-- or not for this tab.  The default is false.
					strikethrough = false,
				},

				-- Inactive tabs are the tabs that do not have focus
				inactive_tab = {
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#808080",
					intensity = "Bold",
				},

				-- You can configure some alternate styling when the mouse pointer
				-- moves over inactive tabs
				inactive_tab_hover = {
					-- bg_color = "#3b3052",
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#909090",
					italic = false,
					intensity = "Bold",
				},

				-- The new tab button that let you create new tabs
				new_tab = {
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#808080",
					intensity = "Bold",
				},

				-- You can configure some alternate styling when the mouse pointer
				-- moves over the new tab button
				new_tab_hover = {
					-- bg_color = "#3b3052",
					bg_color = "rgba(0,0,0,0)",
					fg_color = "#909090",
					italic = false,
					intensity = "Bold",
				},
			},
		}
	end
end

-- return our module table
return module
