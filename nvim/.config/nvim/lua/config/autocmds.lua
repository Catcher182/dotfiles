-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("User", {
  pattern = "LfTermEnter",
  callback = function(a)
    vim.api.nvim_buf_set_keymap(a.buf, "t", "q", "q", { nowait = true })
  end,
})

vim.api.nvim_create_autocmd("User", {
  callback = function()
    vim.api.nvim_set_hl(0, "ConflictMarkerBegin", { link = "DiffAdd" })
    vim.api.nvim_set_hl(0, "ConflictMarkerOurs", { link = "DiffAdd" })
    vim.api.nvim_set_hl(0, "ConflictMarkerTheirs", { link = "DiffText" })
    vim.api.nvim_set_hl(0, "ConflictMarkerEnd", { link = "DiffText" })
    vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestorsHunk", { link = "DiffChange" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "markdown",
  },
  callback = function(event)
    vim.keymap.set("i", ",f", '<Esc>/<++><CR>:nohlsearch<CR>"_c4l', { buffer = event.buf, silent = true })
    vim.keymap.set("i", "<c-e>", '<Esc>/<++><CR>:nohlsearch<CR>"_c4l', { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",w", '<Esc>/ <++><CR>:nohlsearch<CR>"_c5l<CR>', { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",n", "---<Enter><Enter>", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",b", "**** <++><Esc>F*hi", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",s", "~~~~ <++><Esc>F~hi", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",i", "** <++><Esc>F*i", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",d", "`` <++><Esc>F`i", { buffer = event.buf, silent = true })
    vim.keymap.set(
      "i",
      ",c",
      "```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA",
      { buffer = event.buf, silent = true }
    )
    vim.keymap.set("i", ",m", "- [ ] ", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",p", "![](<++>) <++><Esc>F[a", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",a", "[](<++>) <++><Esc>F[a", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",1", "#<Space><Enter><++><Esc>kA", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",2", "##<Space><Enter><++><Esc>kA", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",3", "###<Space><Enter><++><Esc>kA", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",4", "####<Space><Enter><++><Esc>kA", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",5", "#####<Space><Enter><++><Esc>kA", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",6", "######<Space><Enter><++><Esc>kA", { buffer = event.buf, silent = true })
    vim.keymap.set("i", ",l", "--------<Enter>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "man",
    "help",
    "neo-tree",
    "TelescopePrompt",
    "Trouble",
    "dapui_watches",
    "dap-repl",
    "dapui_console",
    "dapui_stacks",
    "dapui_breakpoints",
    "dapui_scopes",
    "Overseer*",
    "Outline",
    "undotree",
    "Mundo",
    "MundoDiff",
    "leetcode.nvim",
    "toggleterm",
  },
  callback = function()
    require("ufo").detach()
    vim.opt_local.foldenable = false
    vim.opt_local.foldcolumn = "0"
  end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
