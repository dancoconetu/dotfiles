local keymap = vim.keymap -- for conciseness

vim.g.mapleader = " "

--------------------  CMD enter command mode with ; -------------------

keymap.set("n", ";", ":", { desc = "CMD enter command mode" })
--------------------  File tree ; -------------------

--------------------  Move highlighted lines up and down ; -------------------
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--------------------  Move page down/up and keep it centered  -------------------
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("x", "<leader>p", [["_dP]])
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
--------------------  Move page down/up and keep it centered  -------------------
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("x", "<leader>p", [["_dP]])
keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "File tree" })
--------------------  Yanks to clipboard  -------------------
keymap.set({ "n", "v" }, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])

--------------------  ctrc+c mapped to ESC  -------------------
-- keymap.set("i", "<C-c>", "<Esc>")

keymap.set("v", "<C-c>", [["+Y]])

keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Smart LSP code action" })
------------------- easy dotnet stuff -----------------------
keymap.set("n", "<leader>dn", "<CMD>Dotnet<CR>", { desc = "Dotnet commands" })

vim.api.nvim_set_keymap("t", "<C-/>", "<C-\\><C-n>", { noremap = true, silent = true })

------------------- Overseer -----------------------
keymap.set("n", "<leader>ov", "<CMD>OverseerToggle<CR>", { desc = "Overseer Toggle" })
keymap.set("n", "<leader>or", "<CMD>OverseerRun<CR>", { desc = "Overseer Run" })
keymap.set("n", "<leader>ne", "<CMD>Neotree<CR>", { desc = "NeoTree" })

-- Resize splits
vim.keymap.set("n", "<C-A-l>", ":3winc ><CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-h>", ":3winc <<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-j>", ":res +3 <CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-k>", ":res -3 <CR>", { noremap = true, silent = true })

keymap.set(
	"n",
	"<leader>ap",
	"<CMD>OpenAvante<CR><CMD>Telescope find_files<CR>",
	{ desc = "avante: open avante and add files" }
)

keymap.set(
	"n",
	"<leader>ag",
	"<CMD>OpenAvante<CR><CMD>Telescope grep_string<CR>",
	{ desc = "avante: open avante and grep string" }
)
keymap.set("n", "Q", "<nop>")

-- greatest remap ever
keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<leader>bx", "<CMD>BufferLinePickClose<CR>", { desc = "BufferLine Pick Close" })
vim.keymap.set("n", "gl", "<CMD>BufferLineCycleNext<CR>")
vim.keymap.set("n", "gh", "<CMD>BufferLineCyclePrev<CR>", { desc = "BufferLine Cycle Prev" })
vim.keymap.set("n", "]b", "<CMD>BufferLineMoveNext<CR>", { desc = "BufferLine Move Next" })
vim.keymap.set("n", "[b", "<CMD>BufferLineMovePrev<CR>")
vim.keymap.set("n", "<leader>bc", "<CMD>BufferLinePick<CR>", { desc = "BufferLine Pick" })
keymap.set("n", "<leader>br", "<CMD>BufferLineCloseRight<CR>", { desc = "Close right buffer" })
keymap.set("n", "<leader>bl", "<CMD>BufferLineCloseLeft<CR>", { desc = "Close left buffer" })
