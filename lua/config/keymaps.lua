local keymap = vim.keymap
local buffer_manager = require("config.buffer_manager")

-- Increment/Decrement
keymap.set("n", "+", "<C-a>", { desc = "Increment" })
keymap.set("n", "+", "<C-a>", { desc = "Decrement" })

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all the page" })

-- Escape insert mode
keymap.set("i", "jj", "<Esc>", { desc = "Return to normal mode" })

-- Split window
keymap.set("n", "ss", function()
  buffer_manager.smart_split(false)
end, { desc = "Smart horizontal split" })
keymap.set("n", "sv", function()
  buffer_manager.smart_split(true)
end, { desc = "Smart vertical split" })

-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-l>", "<C-w>>")
keymap.set("n", "<C-S-k>", "<C-w>+")
keymap.set("n", "<C-S-j>", "<C-w>-")

-- Buffer management per window
keymap.set("n", "<Tab>", function()
  buffer_manager.switch_buffer_in_window("next")
end, { desc = "Next buffer in current window" })
keymap.set("n", "<S-Tab>", function()
  buffer_manager.switch_buffer_in_window("prev")
end, { desc = "Previous buffer in current window" })
keymap.set("n", "<F13>", "<cmd>Telescope buffers<CR>", { desc = "Open buffers list" })
keymap.set("n", "<F13><F13>", function()
  buffer_manager.close_buffer_smart()
end, { desc = "Close buffer intelligently" })

-- Move buffer to specific direction
keymap.set("n", "<leader>bh", function()
  buffer_manager.move_buffer_direction("h")
end, { desc = "Move buffer to left window" })
keymap.set("n", "<leader>bj", function()
  buffer_manager.move_buffer_direction("j")
end, { desc = "Move buffer to bottom window" })
keymap.set("n", "<leader>bk", function()
  buffer_manager.move_buffer_direction("k")
end, { desc = "Move buffer to top window" })
keymap.set("n", "<leader>bl", function()
  buffer_manager.move_buffer_direction("l")
end, { desc = "Move buffer to right window" })

-- Grep
keymap.set("n", "<F12>", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })

-- Inc-rename
keymap.set("n", "<leader>rn", ":IncRename ")

-- Format all
keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format all" })

-- moves
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
