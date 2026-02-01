return {
  {
    "akinsho/toggleterm.nvim",
    opts = function()
      return {
        shade_terminals = false,
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
      }
    end,
  },
  {
    "lmburns/lf.nvim",
    dependencies = { "toggleterm.nvim" },
    keys = {
      { "<leader>fl", "<Cmd>lua require('lf').start()<CR>", desc = "lf" },
    },
    opts = function()
      local fn = vim.fn
      return {
        default_action = "drop", -- default action when `Lf` opens a file
        default_actions = { -- default action keybindings
          ["<C-t>"] = "tabedit",
          ["<C-s>"] = "split",
          ["<C-v>"] = "vsplit",
          ["<C-o>"] = "tab drop",
        },
        winblend = 0, -- psuedotransparency level
        dir = nil, -- directory where `lf` starts ('gwd' is git-working-directory, ""/nil is CWD)
        direction = "float", -- window type: float horizontal vertical
        border = "rounded", -- border kind: single double shadow curved
        height = fn.float2nr(fn.round(0.75 * vim.o.lines)), -- height of the *floating* window
        width = fn.float2nr(fn.round(0.85 * vim.o.columns)), -- width of the *floating* window
        escape_quit = true, -- map escape to the quit command (so it doesn't go into a meta normal mode)
        focus_on_open = true, -- focus the current file when opening Lf (experimental)
        mappings = true, -- whether terminal buffer mapping is enabled
        tmux = false, -- tmux statusline can be disabled on opening of Lf
        highlights = {
          Normal = { guibg = none },
          NormalFloat = { guibg = none },
        },
      }
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = function()
      return {
        filetypes = { "*" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = false, -- CSS hsl() and hsla() functions
          css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = true, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■",
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = false,
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
      }
    end,
  },
  {
    "lambdalisue/suda.vim",
    event = "VeryLazy",
  },
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    event = "VeryLazy",
    keys = {
      { "<leader>fr", "<Plug>SnipRun", mode = { "v" }, { select = true }, desc = "SnipRun(visual mode)" },
    },
    opts = function()
      return {
        selected_interpreters = {}, --# use those instead of the default for the current filetype
        repl_enable = {}, --# enable REPL-like behavior for the given interpreters
        repl_disable = {}, --# disable REPL-like behavior for the given interpreters

        interpreter_options = { --# interpreter-specific options, see doc / :SnipInfo <name>

          --# use the interpreter name as key
          GFM_original = {
            use_on_filetypes = { "markdown.pandoc" }, --# the 'use_on_filetypes' configuration key is
            --# available for every interpreter
          },
          Python3_original = {
            error_truncate = "auto", --# Truncate runtime errors 'long', 'short' or 'auto'
            --# the hint is available for every interpreter
            --# but may not be always respected
          },
        },

        --# you can combo different display modes as desired and with the 'Ok' or 'Err' suffix
        --# to filter only sucessful runs (or errored-out runs respectively)
        display = {
          "Classic", --# display results in the command-line  area
          "VirtualTextOk", --# display ok results as virtual text (multiline is shortened)

          -- "VirtualText",             --# display results as virtual text
          -- "TempFloatingWindow",      --# display results in a floating window
          -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText[Ok/Err]
          -- "Terminal",                --# display results in a vertical split
          -- "TerminalWithCode",        --# display results and code history in a vertical split
          -- "NvimNotify",              --# display with the nvim-notify plugin
          -- "Api"                      --# return output to a programming interface
        },

        live_display = { "VirtualTextOk" }, --# display mode used in live_mode

        display_options = {
          terminal_scrollback = vim.o.scrollback, --# change terminal display scrollback lines
          terminal_line_number = false, --# whether show line number in terminal window
          terminal_signcolumn = false, --# whether show signcolumn in terminal window
          terminal_position = "vertical", --# or "horizontal", to open as horizontal split instead of vertical split
          terminal_width = 45, --# change the terminal display option width (if vertical)
          terminal_height = 20, --# change the terminal display option height (if horizontal)
          notification_timeout = 5, --# timeout for nvim_notify output
        },

        --# You can use the same keys to customize whether a sniprun producing
        --# no output should display nothing or '(no output)'
        show_no_output = {
          "Classic",
          "TempFloatingWindow", --# implies LongTempFloatingWindow, which has no effect on its own
        },

        --# customize highlight groups (setting this overrides colorscheme)
        --# any parameters of nvim_set_hl() can be passed as-is
        snipruncolors = {
          SniprunVirtualTextOk = { bg = "#66eeff", fg = "#000000", ctermbg = "Cyan", ctermfg = "Black" },
          SniprunFloatingWinOk = { fg = "#66eeff", ctermfg = "Cyan" },
          SniprunVirtualTextErr = { bg = "#881515", fg = "#000000", ctermbg = "DarkRed", ctermfg = "Black" },
          SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed", bold = true },
        },

        live_mode_toggle = "off", --# live mode toggle, see Usage - Running for more info

        --# miscellaneous compatibility/adjustement settings
        inline_messages = false, --# boolean toggle for a one-line way to display messages
        --# to workaround sniprun not being able to display anything

        borders = "single", --# display borders around floating windows
        --# possible values are 'none', 'single', 'double', or 'shadow'
      }
    end,
  },
  {
    "voldikss/vim-translator",
    keys = {
      { "mm", "<Plug>TranslateW", mode = { "n" }, desc = "Translate" },
      { "mm", "<Plug>TranslateWV", mode = { "v" }, desc = "Translate" },
      { "mr", "<Plug>TranslateR", mode = { "n" }, desc = "Translate and Replace" },
      { "mr", "<Plug>TranslateRV", mode = { "v" }, desc = "Translate and Replace" },
    },
    config = function()
      vim.g.translator_default_engines = { "bing", "google", "haici" }
    end,
  },
  {
    "sindrets/winshift.nvim",
    event = "VeryLazy",
    opts = {
      -- Lua
      highlight_moving_win = true, -- Highlight the window being moved
      focused_hl_group = "Visual", -- The highlight group used for the moving window
      moving_win_options = {
        -- These are local options applied to the moving window while it's
        -- being moved. They are unset when you leave Win-Move mode.
        wrap = false,
        cursorline = false,
        cursorcolumn = false,
        colorcolumn = "",
      },
      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        win_move_mode = {
          ["h"] = "left",
          ["j"] = "down",
          ["k"] = "up",
          ["l"] = "right",
          ["H"] = "far_left",
          ["J"] = "far_down",
          ["K"] = "far_up",
          ["L"] = "far_right",
          ["<left>"] = "left",
          ["<down>"] = "down",
          ["<up>"] = "up",
          ["<right>"] = "right",
          ["<S-left>"] = "far_left",
          ["<S-down>"] = "far_down",
          ["<S-up>"] = "far_up",
          ["<S-right>"] = "far_right",
        },
      },
      window_picker = function()
        return require("winshift.lib").pick_window({
          -- A string of chars used as identifiers by the window picker.
          picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          filter_rules = {
            -- This table allows you to indicate to the window picker that a window
            -- should be ignored if its buffer matches any of the following criteria.
            cur_win = true, -- Filter out the current window
            floats = true, -- Filter out floating windows
            filetype = {}, -- List of ignored file types
            buftype = {}, -- List of ignored buftypes
            bufname = {}, -- List of vim regex patterns matching ignored buffer names
          },
          ---A function used to filter the list of selectable windows.
          ---@param winids integer[] # The list of selectable window IDs.
          ---@return integer[] filtered # The filtered list of window IDs.
          filter_func = nil,
        })
      end,
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    opts = {
      -- 'statusline-winbar' | 'floating-big-letter'
      hint = "statusline-winbar",
      selection_chars = "FJDKSLA;CMRUEIWOQP",
    },
  },
  {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    keys = {
      { "<leader>cp", "<Cmd>Colortils<CR>", desc = "Colortils" },
    },
    opts = {
      register = "+",
      color_preview = "█ %s ",
      default_format = "hex",
      default_color = "#000000",
      border = "rounded",
      mappings = {
        increment = "l",
        decrement = "h",
        increment_big = "L",
        decrement_big = "H",
        min_value = "0",
        max_value = "$",
        set_register_default_format = "<cr>",
        set_register_choose_format = "g<cr>",
        replace_default_format = "<c-cr>",
        replace_choose_format = "g<c-cr>",
        export = "E",
        set_value = "c",
        transparency = "T",
        choose_background = "B",
      },
    },
  },
  {
    "kawre/neotab.nvim",
    event = "InsertEnter",
    opts = {
      tabkey = "<Tab>",
      act_as_tab = true,
      behavior = "nested",
      pairs = {
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "<", close = ">" },
      },
      exclude = {},
      smart_punctuators = {
        enabled = true,
        semicolon = {
          enabled = true,
          ft = { "cs", "c", "cpp", "java" },
        },
        escape = {
          enabled = false,
          triggers = {},
        },
      },
    },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },
  {
    "nvim-mini/mini.align",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        start = "",
        start_with_preview = "gA",
      },
    },
  },
  {
    "nvim-mini/mini.operators",
    version = false,
    event = "VeryLazy",
    opts = {
      -- Evaluate text and replace with output
      evaluate = {
        prefix = "<leader>v=",
        -- Function which does the evaluation
        func = nil,
      },
      -- Exchange text regions
      exchange = {
        prefix = "<leader>vx",
        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },
      -- Multiply (duplicate) text
      multiply = {
        prefix = "<leader>vt",
        -- Function which can modify text before multiplying
        func = nil,
      },
      -- Replace text with register
      replace = {
        prefix = "<leader>vp",
        reindent_linewise = true,
      },
      -- Sort text
      sort = {
        prefix = "<leader>vs",
        -- Function which does the sort
        func = nil,
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    -- event = "VeryLazy",
    ft = { "markdown", "vimwiki", "tex", "typst", "rst", "asciidoc", "org", "html", "css" },
    opts = {
      default = {
        use_absolute_path = false, ---@type boolean
        relative_to_current_file = true, ---@type boolean
        insert_mode_after_paste = true, ---@type boolean
        -- image options
        copy_images = true, ---@type boolean
        download_images = true, ---@type boolean
      },
      filetypes = {
        markdown = {
          url_encode_path = true, ---@type boolean
          template = "![$CURSOR]($FILE_PATH)", ---@type string
          download_images = true, ---@type boolean
        },
      },
    },
  },
  {
    "keaising/im-select.nvim",
    opts = {},
  },
  {
    "andrewradev/linediff.vim",
    event = "VeryLazy",
  },
  {
    "rhysd/conflict-marker.vim",
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "soulis-1256/eagle.nvim",
    opts = {},
  },
}
