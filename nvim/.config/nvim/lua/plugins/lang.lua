return {
  --cmake
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          cmd = { "qmlls6" },
        },
      },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_executor = { -- executor to use
        name = "overseer", -- name of the executor
        default_opts = {
          overseer = {
            new_task_opts = {
              strategy = {
                "toggleterm",
                direction = "horizontal",
                autos_croll = true,
                quit_on_exit = "success",
              },
              components = { { "on_output_quickfix", open = false }, "default" },
            }, -- options to pass into the `overseer.new_task` command
            on_new_task = function(task)
              -- require("overseer").open({ enter = false, direction = "right" })
            end, -- a function that gets overseer.Task when it is created, before calling `task:start`
          },
        },
      },
      cmake_runner = { -- runner to use
        name = "overseer", -- name of the runner
        default_opts = {
          overseer = {
            new_task_opts = {
              strategy = {
                "toggleterm",
                direction = "horizontal",
                autos_croll = true,
                quit_on_exit = "success",
              },
              components = { { "on_output_quickfix", open = false }, "default" },
            }, -- options to pass into the `overseer.new_task` command
            on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
          },
        },
      },
    },
  },

  -- markdown
  {
    "iamcco/markdown-preview.nvim",
    opts = function()
      vim.g.mkdp_auto_close = true
      vim.g.mkdp_open_to_the_world = false
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = "8888"
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = true
      vim.g.mkdp_page_title = "${name}"
    end,
  },

  -- leetcode
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
      cn = { -- leetcode.cn
        enabled = true, ---@type boolean
        translator = true, ---@type boolean
        translate_problems = true, ---@type boolean
      },
      injector = {
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", "using namespace std;" },
          after = "int main() {}",
        },
        ["java"] = {
          before = "import java.util.*;",
        },
      },
    },
  },

  -- Rest
  {
    "mistweaverco/kulala.nvim",
    opts = function()
      vim.filetype.add({
        extension = {
          ["http"] = "http",
        },
      })
      return {
        -- default_view, body or headers
        default_view = "body",
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = "dev",
        -- enable/disable debug mode
        debug = false,
        -- default formatters for different content types
        formatters = {
          json = { "jq", "." },
          xml = { "xmllint", "--format", "-" },
          html = { "xmllint", "--format", "--html", "-" },
        },
        -- default icons
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅",
            error = "❌",
          },
          lualine = "🐼",
        },
        -- additional cURL options
        -- see: https://curl.se/docs/manpage.html
        additional_curl_options = {},
      }
    end,
  },

  -- html,css
  {
    "mattn/emmet-vim",
    ft = {
      "html",
      "css",
      "EmmetInstall",
    },
  },
  {
    "Jezda1337/nvim-html-css",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("html-css"):setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, {
        name = "html-css",
        option = {
          max_count = {}, -- not ready yet
          enable_on = {
            "html",
          }, -- set the file types you want the plugin to work on
          file_extensions = { "css", "sass", "less" }, -- set the local filetypes from which you want to derive classes
          style_sheets = {
            -- example of remote styles, only css no js for now
            -- "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
            -- "https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css",
          },
        },
      })
    end,
  },

  -- mason,treesitter
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "bash-debug-adapter",
        "shellcheck",
        "clang-format",
        "css-lsp",
        "html-lsp",
        "markuplint",
        "lemminx",
        "stylelint",
        "xmlformatter",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "java", "qmldir", "qmljs" } },
  },
}
