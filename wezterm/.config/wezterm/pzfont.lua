-- I am helpers.lua and I should live in ~/.config/wezterm/helpers.lua

local wezterm = require("wezterm")

-- This is the module table that we will export
local module = {}

function module.apply_to_config(config)
	config.font = wezterm.font_with_fallback({
		-- { family = "MonaspaceRadonVar", weight = 600 },
		{ family = "JetBrains Mono", weight = 500 },
		-- { family = "Source Code Pro", weight = 500 },
		-- { family = "LXGWWenKai-Regular", weight = 500 },
		{ family = "Noto Sans CJK SC", weight = 500 },
		-- { family = "Yozai", weight = 600 },
		-- { family = "XiaolaiMonoSC", weight = 500 },
	})

	config.font_size = 11
	config.harfbuzz_features =
		{ "calt", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "ss09", "liga" }
end

return module
