
-- Keymaps

local map = vim.keymap.set
local allModes = { "n", "i", "v" }
map("n", "<leader>qq", "<cmd>wqa!<cr>", { desc = "Save and quit" })
map(allModes, "<c-h>", "<c-w>h", { desc = "Focus on left window" })
map(allModes, "<c-j>", "<c-w>j", { desc = "Focus on down window" })
map(allModes, "<c-k>", "<c-w>k", { desc = "Focus on up window" })
map(allModes, "<c-l>", "<c-w>l", { desc = "Focus on right window" })
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
map(allModes, "<c-z>", "<cmd>u<cr>", { desc = "Undo" })
map(allModes, "<c-f>", "<esc>:%s/", { desc = "Find and replace" })

-- Keymaps for telescope
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Search all text" })
map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
map("n", "<leader>fo", builtin.oldfiles, { desc = "Find recent files" })

