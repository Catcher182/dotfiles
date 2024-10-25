return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
      table.insert(opts.sources, { name = "nvim_lsp_signature_help" })
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          -- elseif has_words_before() then
          --   cmp.complete()
          elseif require("fittencode").has_suggestions() then
            require("fittencode").accept_all_suggestions()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-g>"] = function()
          if cmp.visible_docs() then
            cmp.close_docs()
          else
            cmp.open_docs()
          end
        end,
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-cr>"] = {
            c = cmp.mapping.confirm({ select = false }),
          },
        }),
        sources = {
          { name = "buffer" },
        },
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-cr>"] = {
            c = cmp.mapping.confirm({ select = false }),
          },
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    keys = {
      { "<leader>va", "<Cmd>Lspsaga code_action<CR>", desc = "Code Action" },
      { "<leader>vf", "<Cmd>Lspsaga finder<CR>", desc = "Lspsaga finder" },
      { "<leader>vc", "<Cmd>Lspsaga incoming_calls<CR>", desc = "Lspsaga incoming_calls" },
      { "<leader>vC", "<Cmd>Lspsaga outgoing_calls<CR>", desc = "Lspsaga outgoing_calls" },
    },
    opts = {
      ui = {
        border = "rounded",
        devicon = true,
        title = false,
        button = { "", "" },
        -- expand = "⊞",
        expand = "⊠",
        collapse = "⊟",
      },
      code_action = {
        num_shortcut = true,
        show_server_name = true,
        extend_gitsigns = true,
      },
      diagnostic = {
        show_code_action = true,
      },
      lightbulb = {
        enable = true,
        sign = true,
        virtual_text = false,
        enable_in_insert = true,
      },
      finder = {
        default = "def+ref+imp",
        left_width = 0.3,
        right_width = 0.4,
        keys = {
          shuttle = "[w",
          toggle_or_open = "o",
          vsplit = "s",
          split = "i",
          tabe = "t",
          tabnew = "r",
          quit = "q",
          close = "<C-c>k",
        },
      },
      symbol_in_winbar = {
        enable = false,
      },
      implement = {
        enable = false,
        sign = true,
        virtual_text = false,
        priority = 100,
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {
      ring = {
        storage = "sqlite",
      },
    },
  },
  {
    "simnalamburt/vim-mundo",
    keys = {
      { "<leader>vu", "<cmd>MundoToggle<cr>", desc = "undotree" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        html = { "prettier" },
        css = { "prettier" },
        js = { "prettier" },
        vue = { "prettier" },
        ts = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        cpp = { "clang-format" },
        c = { "clang-format" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        html = { "markuplint" },
      },
    },
  },
}
