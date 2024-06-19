-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "<leader>rd", "ggdG")
vim.keymap.set("n", "<leader>rc", "ggcG")
vim.keymap.set("n", "<leader>yy", "ggyG")
vim.keymap.set("n", "<leader>vv", "ggVG")
vim.keymap.set("n", "<leader>ua", "<Cmd>TransparentToggle<CR>", { desc = "TransparentToggle" })
vim.keymap.set("n", "<leader>ub", function()
  local background_value = vim.o.background
  if background_value == "dark" then
    vim.opt.background = "light"
    os.execute("/home/dawn/.config/rofi/scripts/rofi-colorscheme.sh Light")
  else
    vim.opt.background = "dark"
    os.execute("/home/dawn/.config/rofi/scripts/rofi-colorscheme.sh Dark")
  end
end, { desc = "BackgroundToggle" })
vim.keymap.set(
  "n",
  "<leader>th",
  "<cmd>1ToggleTerm size=10 direction=horizontal name=horizontal<cr>",
  { desc = "ToggleTerm horizontal split" }
)
vim.keymap.set(
  "n",
  "<leader>tv",
  "<cmd>2ToggleTerm size=38 direction=vertical name=vertical<cr>",
  { desc = "ToggleTerm vertical split" }
)
vim.keymap.set("n", "<leader>tf", "<cmd>3ToggleTerm direction=float name=float<cr>", { desc = "ToggleTerm float" })
-- vim.keymap.del("n", "<C-/>")
vim.keymap.set("n", "<C-/>", "<cmd>ToggleTermToggleAll<cr>", { desc = "ToggleTerm" })
