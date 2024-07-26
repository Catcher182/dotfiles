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

      -- local luasnip = require("luasnip")
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
          -- elseif require("fittencode").has_suggestions() then
          --   require("fittencode").accept_all_suggestions()
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
    "luozhiya/fittencode.nvim",
    lazy = false,
    opts = {},
    keys = {
      {
        "<a-down>",
        function()
          if require("fittencode").has_suggestions() then
            return require("fittencode").accept_all_suggestions()
          end
        end,
        mode = { "i" },
      },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        "<cmd>Fitten toggle_chat<cr>",
        desc = "Toggle (Fitten Chat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        "<cmd>Fitten start_chat<cr>",
        desc = "Start Chat (Fitten)",
        mode = { "n", "v" },
      },
      {
        "<leader>ae",
        "<cmd>Fitten explain_code<cr>",
        desc = "Explain Code (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>af",
        "<cmd>Fitten find_bugs<cr>",
        desc = "Find Bugs (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>am",
        "<cmd>Fitten document_code<cr>",
        desc = "Document Code (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>ai",
        "<cmd>Fitten implement_features<cr>",
        desc = "Implement Features (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>ao",
        "<cmd>Fitten optimize_code<cr>",
        desc = "Optimize Code (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>ar",
        "<cmd>Fitten refactor_code<cr>",
        desc = "Refactor Code (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>ad",
        "<cmd>Fitten analyze_data<cr>",
        desc = "Analyze Data (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>agc",
        "<cmd>Fitten generate_code<CR>",
        desc = "Generate Code (Fitten)",
        mode = { "n", "v" },
      },
      {
        "<leader>agt",
        ":Fitten generate_unit_test",
        desc = "Generate Unit Test (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>atc",
        "<cmd>Fitten translate_text_into_chinese<cr>",
        desc = "Translate Text into Chinese (Fitten)",
        mode = { "v" },
      },
      {
        "<leader>ate",
        "<cmd>Fitten translate_text_into_english<cr>",
        desc = "Translate Text into English (Fitten)",
        mode = { "v" },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
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
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>un", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree" },
    },
    opts = {
      float_diff = true, -- using float window previews diff, set this `true` will disable layout option
      layout = "left_bottom", -- "left_bottom", "left_left_bottom"
      position = "left", -- "right", "bottom"
      ignore_filetype = { "undotree", "undotreeDiff", "qf", "TelescopePrompt", "spectre_panel", "tsplayground" },
      window = {
        winblend = 30,
      },
      keymaps = {
        ["j"] = "move_next",
        ["k"] = "move_prev",
        ["gj"] = "move2parent",
        ["J"] = "move_change_next",
        ["K"] = "move_change_prev",
        ["<cr>"] = "action_enter",
        ["p"] = "enter_diffbuf",
        ["q"] = "quit",
      },
    },
  },
}
