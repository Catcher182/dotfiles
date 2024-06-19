-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("User", {
  pattern = "LfTermEnter",
  callback = function(a)
    vim.api.nvim_buf_set_keymap(a.buf, "t", "q", "q", { nowait = true })
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local file = io.open("/home/dawn/.cache/mycolorscheme", "r")
    -- 读取文件内容并赋值给变量
    local appearance = file and file:read("*a"):gsub("%s+", "") or "light"
    -- 关闭文件
    if file then
      file:close()
    end
    if appearance == "dark" then
      vim.opt.background = "dark"
    elseif appearance == "light" then
      vim.opt.background = "light"
    end
  end,
  nested = true,
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
