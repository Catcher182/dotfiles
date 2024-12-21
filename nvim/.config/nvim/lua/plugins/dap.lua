return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = {
      {
        "<leader>dc",
        function()
          vim.fn.sign_define(
            "DapStopped",
            { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" }
          )
          require("dap").continue()
        end,
        desc = "Continue",
      },
    },
    opts = function()
      local dap = require("dap")

      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/wezterm",
        args = { "-e" },
      }
      -- dap.defaults.fallback.force_external_terminal = true
      -- dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
      if not dap.adapters["local-lua"] then
        require("dap").adapters["local-lua"] = {
          type = "executable",
          command = "node",
          args = {
            "/usr/lib/node_modules/local-lua-debugger-vscode/extension/debugAdapter.js",
          },
          enrich_config = function(config, on_config)
            if not config["extensionPath"] then
              local c = vim.deepcopy(config)
              -- 💀 If this is missing or wrong you'll see
              -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
              c.extensionPath = "/usr/lib/node_modules/local-lua-debugger-vscode/"
              on_config(c)
            else
              on_config(config)
            end
          end,
        }
      end
      dap.configurations.lua = {
        {
          name = "Current file (local-lua-dbg, lua)",
          type = "local-lua",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = {
            lua = "lua",
            file = "${file}",
          },
          args = {},
        },
      }
    end,
  },
}
