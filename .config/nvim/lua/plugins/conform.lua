return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		---@diagnostic disable-next-line: undefined-global
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "prettierd", stop_after_first = true },
				typescript = { "prettierd", stop_after_first = true },
				javascriptreact = { "prettierd", stop_after_first = true },
				typescriptreact = { "prettierd", stop_after_first = true },
				css = { "prettierd", stop_after_first = true },
				cs = { "csharpier", stop_after_first = true },
				html = { "prettierd", stop_after_first = true },
				json = { "prettierd", stop_after_first = true },
				yaml = { "prettierd", stop_after_first = true },
				markdown = { "prettierd", stop_after_first = true },
				graphql = { "prettierd", stop_after_first = true },
				lua = { "stylua" },
				sql = { "sqlfluff" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 2000,
			},
		})
	end,
}
