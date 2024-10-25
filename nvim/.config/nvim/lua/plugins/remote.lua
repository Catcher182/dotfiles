return {
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    opts = {
      progress_view = {
        type = "popup",
      },

      -- Offline mode configuration. For more details, see the "Offline mode" section below.
      offline_mode = {
        -- Should offline mode be enabled?
        enabled = false,
        -- Do not connect to GitHub at all. Not even to get release information.
        no_github = false,
        -- What path should be looked at to find locally available releases
      },

      -- Remote configuration
      remote = {
        app_name = "nvim", -- This directly maps to the value NVIM_APPNAME. If you use any other paths for configuration, also make sure to set this.
        -- List of directories that should be copied over
        copy_dirs = {
          -- What to copy to remote's Neovim config directory
          config = {
            base = vim.fn.stdpath("config"), -- Path from where data has to be copied
            dirs = "*", -- Directories that should be copied over. "*" means all directories. To specify a subset, use a list like {"lazy", "mason"} where "lazy", "mason" are subdirectories
            -- under path specified in `base`.
            compression = {
              enabled = false, -- Should compression be enabled or not
              additional_opts = {}, -- Any additional options that should be used for compression. Any argument that is passed to `tar` (for compression) can be passed here as separate elements.
            },
          },
          -- What to copy to remote's Neovim data directory
          data = {
            base = vim.fn.stdpath("data"),
            dirs = { "lazy" },
            compression = {
              enabled = true,
            },
          },
          -- What to copy to remote's Neovim cache directory
          cache = {
            base = vim.fn.stdpath("cache"),
            dirs = {},
            compression = {
              enabled = true,
            },
          },
          -- What to copy to remote's Neovim state directory
          state = {
            base = vim.fn.stdpath("state"),
            dirs = {},
            compression = {
              enabled = true,
            },
          },
        },
      },

      -- You can supply your own callback that should be called to create the local client.
      -- Two arguments are passed to the callback:
      -- port: Local port at which the remote server is available
      -- workspace_config: Workspace configuration for the host. For all the properties available, see https://github.com/amitds1997/remote-nvim.nvim/blob/main/lua/remote-nvim/providers/provider.lua#L4
      -- A sample implementation using WezTerm tab is at: https://github.com/amitds1997/remote-nvim.nvim/wiki/Configuration-recipes
      client_callback = function(port, workspace_config)
        local cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s"):format(
          port,
          ("'Remote: %s'"):format(workspace_config.host)
        )
        if vim.env.TERM == "xterm-kitty" then
          cmd = ("kitty -e nvim --server localhost:%s --remote-ui"):format(port)
        end
        vim.fn.jobstart(cmd, {
          detach = true,
          on_exit = function(job_id, exit_code, event_type)
            -- This function will be called when the job exits
            print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
          end,
        })
      end,
    },
  },
}
