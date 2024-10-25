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
