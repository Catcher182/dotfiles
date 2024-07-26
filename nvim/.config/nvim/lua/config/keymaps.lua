-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "<leader>rdd", "ggdG")
vim.keymap.set("n", "<leader>rdc", "ggcG")
vim.keymap.set("n", "<leader>yy", "ggyG")
vim.keymap.set("n", "<leader>vv", "ggVG")
vim.keymap.set("n", "<leader>uz", "<Cmd>ZenMode<CR>", { desc = "ZenMode" })
vim.keymap.set("n", "<leader>ua", "<Cmd>TransparentToggle<CR>", { desc = "TransparentToggle" })
vim.keymap.set("n", "<leader>ub", function()
  local background_value = vim.o.background
  if background_value == "dark" then
    os.execute("/home/dawn/.config/rofi/scripts/rofi-colorscheme.sh Light > /dev/null 2>&1")
    vim.opt.background = "light"
  else
    os.execute("/home/dawn/.config/rofi/scripts/rofi-colorscheme.sh Dark > /dev/null 2>&1")
    vim.opt.background = "dark"
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

vim.keymap.set("n", "<F29>", "<cmd>OverseerRun<cr>")
vim.keymap.set("n", "<leader>run", "<cmd>OverseerRun<cr>")
vim.keymap.set("n", "<leader>rut", "<cmd>OverseerToggle<cr>")
vim.keymap.set("n", "<F41>", "<cmd>OverseerToggle<cr>")
vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F6>", function()
  require("dap").pause()
end)
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F23>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F17>", function()
  require("dap").terminate()
end)

vim.keymap.set("n", "zk", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek folded lines under cursor" })

-- return the max fold level of the buffer (for now doing the opposite and folding incrementally is unbounded)
-- Also jarring if you start folding incrementally after opening all folds
local function max_level()
  -- return vim.wo.foldlevel -- find a way for this to return max fold level
  return 0
end

---Set the fold level to the provided value and store it locally to the buffer
---@param num integer the fold level to set
local function set_fold(num)
  -- vim.w.ufo_foldlevel = math.min(math.max(0, num), max_level()) -- when max_level is implemneted properly
  vim.b.ufo_foldlevel = math.max(0, num)
  require("ufo").closeFoldsWith(vim.b.ufo_foldlevel)
end

---Shift the current fold level by the provided amount
---@param dir number positive or negative number to add to the current fold level to shift it
local shift_fold = function(dir)
  set_fold((vim.b.ufo_foldlevel or max_level()) + dir)
end

-- when max_level is implemented properly
-- vim.keymap.set("n", "zR", function() set_win_fold(max_level()) end, { desc = "Open all folds" })
vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })

vim.keymap.set("n", "zM", function()
  set_fold(0)
end, { desc = "Close all folds" })

vim.keymap.set("n", "zr", function()
  shift_fold(vim.v.count == 0 and 1 or vim.v.count)
end, { desc = "Fold less" })

vim.keymap.set("n", "zm", function()
  shift_fold(-(vim.v.count == 0 and 1 or vim.v.count))
end, { desc = "Fold more" })

vim.keymap.set("n", "<C-W><C-M>", "<Cmd>WinShift<CR>", { desc = "WinShift" })
vim.keymap.set("n", "<C-W>X", "<Cmd>WinShift swap<CR>", { desc = "WinShift swap" })

vim.keymap.set("n", "<leader>ws", function()
  local window = require("window-picker").pick_window()
  if window then
    vim.api.nvim_set_current_win(window)
  end
end, { desc = "Pick window" })

vim.keymap.set("v", "<leader><leader>s", 'y/\\V<C-r>"<CR>', { desc = "Search visual text" })
vim.keymap.set("v", "<leader><leader>r", 'y:%s/\\V<C-r>"//g<Left><Left>', { desc = "Replace visual text" })

vim.keymap.set("n", "<C-S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<C-S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

vim.keymap.set("n", "<leader>df", function()
  local dap = require("dap")
  if dap.defaults.fallback.force_external_terminal then
    dap.defaults.fallback.force_external_terminal = false
  else
    dap.defaults.fallback.force_external_terminal = true
  end
end, { desc = "Toggle Dap Fallback External Terminal" })
