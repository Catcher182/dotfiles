return {
  {
    "folke/noice.nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    opts = {
      win = {
        backdrop = false,
      },

      dashboard = {
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          -- { section = "startup" },
        },
      },

      statuscolumn = {
        left = { "sign", "mark" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = true, -- show open fold icons
          git_hl = true, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = { "", "" },
        -- separator_style = "slope",
        buffer_close_icon = "✘",
        -- numbers = function(opts)
        --   return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
        -- end,
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          --   style = "icon" | "underline" | "none",
          style = "icon",
        },
        offsets = {
          -- {
          --   filetype = "neo-tree",
          --   text = "Neo-tree",
          --   highlight = "BufferLineBackground",
          --   text_align = "center",
          --   padding = 1,
          -- },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local icons = LazyVim.config.icons
      local opts = {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = "",
          section_separators = { left = "", right = "" },
          -- section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            "mode",
          },
          lualine_b = {
            {
              function()
                return vim.g.remote_neovim_host and ("Remote: %s"):format(vim.uv.os_gethostname()) or ""
              end,
            },
            "branch",
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_c = { "filename" },
          lualine_x = {
            "overseer",
            "encoding",
            {
              "fileformat",
              symbols = {
                unix = "unix", -- e712
                dos = "Dos", -- e70f
                mac = "Mac", -- e711
              },
            },
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          "neo-tree",
          "lazy",
          "fzf",
          "mason",
          "nvim-dap-ui",
          "overseer",
          "quickfix",
          -- "toggleterm",
          "trouble",
        },
      }
      return opts
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    opts = function()
      return {}
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    opts = function()
      -- require("transparent").clear_prefix("lualine_c")
      -- require("transparent").clear_prefix("lualine_x")
      -- require("transparent").clear_prefix("NeoTree")
      return { -- Optional, you don't have to run setup.
        groups = { -- table: default groups
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          -- "CursorLine",
          "CursorLineNr",
          "StatusLine",
          "StatusLineNC",
          "EndOfBuffer",
          "FloatBorder",
        },
        extra_groups = {
          -- "NormalFloat",
          -- "NeoTreeNormal",
          -- "NeoTreeFloatBorder",
          -- "NeoTreeNormalNC",
          -- "NeoTreeIndentMarker",
          -- "NeoTreeExpander",
          "WinBar",
          "FoldColumn",
          "SagaTitle",
          "SagaActionTitle",
        }, -- table: additional groups that should be cleared
        exclude_groups = {
          "TreesitterContext",
          -- "NormalFloat",
          "Folded",
        }, -- table: groups you don't want to clear
      }
    end,
  },
  {
    "typicode/bg.nvim",
    lazy = false,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      vim.g.rainbow_delimiters = { highlight = highlight }
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      return {
        indent = {
          char = "▏",
          tab_char = "│",
          -- highlight = highlight,
        },
        scope = { show_start = true, show_end = true, highlight = highlight },
      }
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    opts = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      return {
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      }
    end,
  },
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        width = 1, -- width of the Zen window
        height = 1, -- height of the Zen window
        options = {
          -- signcolumn = "no", -- disable signcolumn
          -- number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- disable some global vim options (vim.o...)
        -- comment the lines to not apply the options
        options = {
          enabled = true,
          -- ruler = false, -- disables the ruler text in the cmd line area
          -- showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          -- laststatus = 0, -- turn off the statusline in zen mode
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false }, -- disables the tmux statusline
      },
      -- callback where you can add custom code when the Zen window opens
      on_open = function(win) end,
      -- callback where you can add custom code when the Zen window closes
      on_close = function() end,
    },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = function(_, opts)
  --     local bordered = require("cmp.config.window").bordered
  --     return vim.tbl_deep_extend("force", opts, {
  --       window = {
  --         completion = bordered(BORDER_STYLE),
  --         documentation = bordered(BORDER_STYLE),
  --       },
  --     })
  --   end,
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      popup_border_style = "rounded",
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.api.nvim_set_hl(0, "NeoTreeNormal", { link = "Normal" })
            vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { link = "Normal" })
            vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { link = "Normal" })
          end,
        },
      },
    },
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    opts = {
      refresh_delay = 75,
      alpha = 0.75,
      blend_color = "#eeeeee",
      hide = {
        underline = true,
        virtual_text = true,
        signs = true,
      },
      regex = {
        "[uU]nused",
        "[nN]ever [rR]ead",
        "[nN]ot [rR]ead",
      },
      priority = 128,
      disable = {},
    },
  },
  {
    "dnlhc/glance.nvim",
    keys = {
      { "<leader>vd", "<CMD>Glance definitions<CR>", desc = "Glance definitions", mode = { "n" } },
      { "<leader>vr", "<CMD>Glance references<CR>", desc = "Glance references", mode = { "n" } },
      { "<leader>vy", "<CMD>Glance type_definitions<CR>", desc = "Glance type_definitions", mode = { "n" } },
      { "<leader>vm", "<CMD>Glance implementations<CR>", desc = "Glance implementations", mode = { "n" } },
    },
    opts = function()
      -- Lua configuration
      local glance = require("glance")
      local actions = glance.actions
      vim.api.nvim_set_hl(0, "GlanceListNormal", { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "GlancePreviewNormal", { link = "NormalFloat" })

      return {
        height = 18, -- Height of the window
        zindex = 45,

        detached = function(winid)
          return vim.api.nvim_win_get_width(winid) < 100
        end,

        preview_win_opts = { -- Configure preview window options
          cursorline = true,
          number = true,
          wrap = true,
        },
        border = {
          enable = true, -- Show window borders. Only horizontal borders allowed
          top_char = "―",
          bottom_char = "―",
        },
        list = {
          position = "right", -- Position of the list window 'left'|'right'
          width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
        },
        theme = { -- This feature might not work properly in nvim-0.7.2
          enable = true, -- Will generate colors for the plugin based on your current colorscheme
          mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
        },
        mappings = {
          list = {
            ["j"] = actions.next, -- Bring the cursor to the next item in the list
            ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
            ["<Down>"] = actions.next,
            ["<Up>"] = actions.previous,
            ["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
            ["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["v"] = actions.jump_vsplit,
            ["s"] = actions.jump_split,
            ["t"] = actions.jump_tab,
            ["<CR>"] = actions.jump,
            ["o"] = actions.jump,
            ["l"] = actions.open_fold,
            ["h"] = actions.close_fold,
            ["<leader>l"] = actions.enter_win("preview"), -- Focus preview window
            ["q"] = actions.close,
            ["Q"] = actions.close,
            ["<Esc>"] = actions.close,
            ["<C-q>"] = actions.quickfix,
            -- ['<Esc>'] = false -- disable a mapping
          },
          preview = {
            ["Q"] = actions.close,
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,
            ["<leader>l"] = actions.enter_win("list"), -- Focus list window
          },
        },
        hooks = {},
        folds = {
          fold_closed = "",
          fold_open = "",
          folded = true, -- Automatically fold list on startup
        },
        indent_lines = {
          enable = true,
          icon = "│",
        },
        winbar = {
          enable = true, -- Available strating from nvim-0.8+
        },
        use_trouble_qf = false, -- Quickfix action will open trouble.nvim instead of built-in quickfix list window
      }
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    opts = {},
  },
}
