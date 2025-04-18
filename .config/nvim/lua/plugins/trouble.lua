-- return {
-- 	"folke/trouble.nvim",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	keys = {
-- 		{
-- 			"<leader>tx",
-- 			"<cmd>Trouble diagnostics toggle<cr>",
-- 			desc = "Diagnostics (Trouble)",
-- 		},
-- 		{
-- 			"<leader>tX",
-- 			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
-- 			desc = "Buffer Diagnostics (Trouble)",
-- 		},
-- 		{
-- 			"<leader>tS",
-- 			"<cmd>Trouble symbols toggle focus=false<cr>",
-- 			desc = "Symbols (Trouble)",
-- 		},
-- 		{
-- 			"<leader>tl",
-- 			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
-- 			desc = "LSP Definitions / references / ... (Trouble)",
-- 		},
-- 		{
-- 			"<leader>tL",
-- 			"<cmd>Trouble loclist toggle<cr>",
-- 			desc = "Location List (Trouble)",
-- 		},
-- 		{
-- 			"<leader>tQ",
-- 			"<cmd>Trouble qflist toggle<cr>",
-- 			desc = "Quickfix List (Trouble)",
-- 		},
-- 	},
-- 	opts = {}, -- for default options, refer to the configuration section for custom setup.
-- }
--
return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	enabled = not vim.g.is_perf,
	cmd = "Trouble",
	config = function()
		require("trouble").setup({
			auto_close = true,
			auto_preview = true,
			auto_jump = true,
			modes = {
				lsp_base = {
					params = {
						include_current = false,
					},
				},
				lsp_references = {
					params = {
						include_declaration = false,
					},
				},
				lsp = {
					desc = "LSP definitions, references, implementations, type definitions, and declarations",
					sections = {
						"lsp_references",
						"lsp_definitions",
						"lsp_implementations",
						"lsp_type_definitions",
						"lsp_declarations",
					},
				},
			},
		})
	end,
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>gr",
			"<cmd>Trouble lsp_references toggle focus=false win.position=bottom<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
	},
}
