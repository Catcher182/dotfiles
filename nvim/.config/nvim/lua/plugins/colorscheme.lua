return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = function()
      return {
        flavour = "auto", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
      }
    end,
  },
  {
    "gbprod/nord.nvim",
    opts = function()
      return {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        diff = { mode = "bg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
        borders = true, -- Enable the border between verticaly split windows visible
        errors = { mode = "bg" }, -- Display mode for errors and diagnostics
        -- values : [bg|fg|none]
        search = { theme = "vim" }, -- theme for highlighting search results
        -- values : [vim|vscode]
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = {},
          functions = {},
          variables = {},

          -- To customize lualine/bufferline
          bufferline = {
            current = {},
            modified = { italic = true },
          },
        },
      }
    end,
  },
  {
    "sainnhe/edge",
    opts = function()
      vim.g.edge_style = "aura"
      vim.g.edge_enable_italic = 1
      vim.g.edge_transparent_background = 0
      vim.g.edge_disable_terminal_colors = 1
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    opts = function()
      local c = require("vscode.colors").get_colors()
      return {
        -- style = "light",
        transparent = false,
        italic_comments = true,
        underline_links = true,
        disable_nvimtree_bg = true,
        color_overrides = {
          vscTabCurrent = "#2196F3",
          vscPopupHighlightBlue = "#039BE5",
        },
        group_overrides = {
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
          NeoTreeDimText = { bg = c.vscNone },
          NeoTreeExpander = { fg = c.vscLineNumber, bg = c.vscNone },
          NeoTreeIndentMarker = { fg = c.vscLineNumber, bg = c.vscNone },
          LineNr = { bg = c.vscNone },
          Conceal = { bg = c.vscNone },
          Directory = { bg = c.vscNone },
          FloatBorder = { bg = c.vscNone },
          FloatTitle = { bg = c.vscPopupBack },
          NoiceSplit = { bg = c.vscBack },
        },
      }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
