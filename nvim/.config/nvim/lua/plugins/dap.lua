return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/wezterm",
        args = { "-e" },
      }
      -- dap.defaults.fallback.force_external_terminal = true
      -- dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
      if not dap.adapters["lldb"] then
        require("dap").adapters["lldb"] = {
          type = "executable",
          command = "/usr/bin/lldb-dap", -- adjust as needed, must be absolute path
          name = "lldb",
        }
      end
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
            -- runInTerminal = false,
          },
        }
      end
      if not dap.adapters["bashdb"] then
        require("dap").adapters["bashdb"] = {
          type = "executable",
          command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
          name = "bashdb",
        }
      end
      for _, lang in ipairs({ "sh" }) do
        dap.configurations[lang] = {
          {
            type = "bashdb",
            request = "launch",
            name = "Launch file",
            showDebugOutput = true,
            pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
            pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
            trace = true,
            file = "${file}",
            program = "${file}",
            cwd = "${workspaceFolder}",
            pathCat = "cat",
            pathBash = "/bin/bash",
            pathMkfifo = "mkfifo",
            pathPkill = "pkill",
            args = {},
            env = {},
            terminalKind = "integrated",
          },
        }
      end
    end,
  },
}
