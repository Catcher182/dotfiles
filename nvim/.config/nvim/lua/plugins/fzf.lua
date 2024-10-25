return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      local config = require("fzf-lua.config")
      local actions = require("fzf-lua.actions")

      local deltabg = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --"
        .. vim.o.background

      -- Toggle root dir / cwd
      config.defaults.actions.files["ctrl-r"] = function(_, ctx)
        local o = vim.deepcopy(ctx.__call_opts)
        o.root = o.root == false
        o.cwd = nil
        o.buf = ctx.__CTX.bufnr
        LazyVim.pick.open(ctx.__INFO.cmd, o)
      end
      config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
      config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

      -- use the same prompt for all
      local defaults = require("fzf-lua.profiles.default-title")
      local function fix(t)
        t.prompt = t.prompt ~= nil and " " or nil
        for _, v in pairs(t) do
          if type(v) == "table" then
            fix(v)
          end
        end
      end
      fix(defaults)

      local img_previewer ---@type string[]?
      for _, v in ipairs({
        -- { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return vim.tbl_deep_extend("force", defaults, {
        -- fzf_colors = true,
        fzf_colors = {
          ["fg"] = { "fg", "CursorLine" },
          ["bg"] = { "bg", "Normal" },
          ["hl"] = { "fg", "Comment" },
          ["fg+"] = { "fg", "Normal" },
          ["bg+"] = { "bg", "CursorLine" },
          ["hl+"] = { "fg", "Statement" },
          ["info"] = { "fg", "PreProc" },
          ["prompt"] = { "fg", "Conditional" },
          ["pointer"] = { "fg", "Exception" },
          ["marker"] = { "fg", "Keyword" },
          ["spinner"] = { "fg", "Label" },
          ["header"] = { "fg", "Comment" },
          ["gutter"] = "-1",
        },
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
          man = {
            cmd = "man %s | col -bx",
          },
        },
        -- Custom LazyVim option to configure vim.ui.select
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend("force", fzf_opts, {
            prompt = " ",
            winopts = {
              title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
              title_pos = "center",
              backdrop = 100,
            },
          }, fzf_opts.kind == "codeaction" and {
            winopts = {
              layout = "vertical",
              -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
              width = 0.8,
              preview = not vim.tbl_isempty(LazyVim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
                layout = "vertical",
                vertical = "down:15,border-top",
                hidden = "hidden",
              } or {
                layout = "vertical",
                vertical = "down:15,border-top",
              },
            },
          } or {
            winopts = {
              width = 0.8,
              -- height is number of items, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
            },
          })
        end,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
          backdrop = 100,
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
            previewer = "bat",
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
            preview_pager = deltabg,
          },
        },
      })
    end,
  },
}
