return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "powershell_es", "yamlls", "rust_analyzer", "fsautocomplete" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp-config.lua_ls").setup()
			require("lsp-config.tsserver").setup()
			require("lsp-config.yaml").setup()
			-- bindings
			require("lsp-config.bindings").setup()
		end,
	},
}
