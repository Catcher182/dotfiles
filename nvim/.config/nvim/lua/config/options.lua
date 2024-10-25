-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_picker = "fzf"
-- vim.g.lazyvim_picker = "telescope"
-- vim.opt.shiftwidth = 4 -- Size of an indent
-- vim.opt.tabstop = 4 -- Number of spaces tabs count for

vim.opt.spelllang = { "en", "cjk" }
vim.opt.spelloptions:append("camel")
vim.opt.mousemoveevent = true

vim.opt.dictionary:append("/usr/share/dict/words")
-- vim.opt.background = "light"

local file = io.open("/home/dawn/.cache/mycolorscheme", "r")
-- 读取文件内容并赋值给变量
local appearance = file and file:read("*a"):gsub("%s+", "") or "Light"
-- 关闭文件
if file then
  file:close()
end
if appearance == "Dark" then
  vim.opt.background = "dark"
else
  vim.opt.background = "light"
end
