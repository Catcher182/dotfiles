-- I am helpers.lua and I should live in ~/.config/wezterm/helpers.lua

local wezterm = require("wezterm")

-- This is the module table that we will export
local module = {}

function module.apply_to_config(config)
	-- config.font = wezterm.font 'Fira Code'
	-- You can specify some parameters to influence the font selection;
	-- for example, this selects a Bold, Italic font variant.
	-- config.font = wezterm.font("SauceCodeProNerdFont", { weight = "Medium", italic = false })
	-- config.font = wezterm.font("JetBrains Mono", { weight = "Bold", italic = true })
	-- config.font = wezterm.font("FiraCode Nerd Font", { weight = "Regular", italic = false })
	config.font = wezterm.font_with_fallback({
		-- { family = "SauceCodeProNerdFont", weight = "Medium", italic = false },
		-- { family = "Source Code Pro", weight = "Regular", italic = false },
		-- "Source Code Pro",
		"JetBrains Mono",
		-- "Input Mono",
		-- { family = "Input Mono", weight = "Regular", italic = false },
		-- "FiraCode Nerd Font",
		-- "FiraCode Nerd Font",
		-- "CascadiaCode",
		"Noto Sans CJK SC",
		-- { family = "Noto Sans CJK SC", weight = "Medium", italic = false },
		-- { family = "Consolas", weight = "Regular", italic = false },
	})

	config.font_rules = {

		{
			intensity = "Normal",
			italic = true,
			font = wezterm.font_with_fallback({
				{ family = "JetBrains Mono", weight = "Medium", italic = true },
				{ family = "Noto Sans CJK SC", weight = "Medium", italic = true },
			}),
		},
		{
			intensity = "Normal",
			italic = false,
			font = wezterm.font_with_fallback({
				{ family = "JetBrains Mono", weight = "Medium", italic = false },
				{ family = "Noto Sans CJK SC", weight = "Medium", italic = false },
			}),
		},

		{
			intensity = "Half",
			italic = false,
			font = wezterm.font_with_fallback({
				{ family = "JetBrains Mono", weight = "Regular", italic = false },
				{ family = "Noto Sans CJK SC", weight = "Regular", italic = false },
			}),
		},
		{
			intensity = "Half",
			italic = true,
			font = wezterm.font_with_fallback({
				{ family = "JetBrains Mono", weight = "Regular", italic = true },
				{ family = "Noto Sans CJK SC", weight = "Regular", italic = true },
			}),
		},

		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font_with_fallback({
				{ family = "JetBrains Mono", weight = "Medium", italic = true },
				{ family = "Noto Sans CJK SC", weight = "Medium", italic = true },
			}),
		},

		{
			intensity = "Bold",
			italic = false,
			font = wezterm.font_with_fallback({
				{ family = "JetBrains Mono", weight = "Medium", italic = false },
				{ family = "Noto Sans CJK SC", weight = "Medium", italic = false },
			}),
		},
	}

	config.font_size = 11
	-- config.freetype_load_target = "Light"
	-- config.freetype_render_target = "HorizontalLcd"
	-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
	-- config.harfbuzz_features = { "zero", "ss05", "ss03" }
	config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", "zero", "ss05", "ss03", "cv02" }
end

-- return our module table
return module
