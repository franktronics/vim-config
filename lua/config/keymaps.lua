-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any a dditional keymaps here 0
--

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

local function smart_split(vertical)
  local cur_win = vim.api.nvim_get_current_win() -- fenêtre actuelle
  local cur_buf = vim.api.nvim_get_current_buf() -- buffer courant
  local prev_buf = vim.fn.bufnr("#") -- dernier buffer utilisé

  -- créer le split
  if vertical then
    vim.cmd("vsplit")
  else
    vim.cmd("split")
  end

  local split_win = vim.api.nvim_get_current_win() -- nouvelle fenêtre
  vim.api.nvim_win_set_buf(split_win, cur_buf) -- mettre le buffer courant dans le split

  -- revenir à la fenêtre originale
  vim.api.nvim_set_current_win(cur_win)

  -- afficher le buffer précédent (si existant) dans la fenêtre originale
  if prev_buf ~= -1 and prev_buf ~= cur_buf then
    vim.api.nvim_win_set_buf(cur_win, prev_buf)
  end
end

-- Increment/Decrement
keymap.set("n", "+", "<C-a>", { desc = "Increment" })
keymap.set("n", "+", "<C-a>", { desc = "Decrement" })

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all the page" })

-- Escape insert mode
keymap.set("i", "jj", "<Esc>", { desc = "Return to normal mode" })

-- Split window
vim.keymap.set("n", "ss", function()
  smart_split(false)
end, { desc = "Smart horizontal split" })
vim.keymap.set("n", "sv", function()
  smart_split(true)
end, { desc = "Smart vertical split" })

-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-l>", "<C-w>>")
keymap.set("n", "<C-S-k>", "<C-w>+")
keymap.set("n", "<C-S-j>", "<C-w>-")
keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Inc-rename
keymap.set("n", "<leader>rn", ":IncRename ")

-- Format all
keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- moves
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
