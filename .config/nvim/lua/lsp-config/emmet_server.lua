local emmet_server = {}

function emmet_server.settup()
	local lspconfig = require("lspconfig")
	lspconfig.emmet_ls.setup({
		capabilities = require("lsp-config.lsp_capabilities").capabilities,
		on_attach = function(client, bufnr)
			require("lsp-config.keymaps").on_attach(client, bufnr)
		end,
		filetypes = {
			"html",
			"css",
			"scss",
			"less",
			"javascriptreact",
			"typescriptreact",
		},
	})
end

return emmet_server
