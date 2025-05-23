local yaml = {}

function yaml.setup()
	local lspconfig = require("lspconfig")
	local capabilities = require("blink.cmp").get_lsp_capabilities()
	lspconfig.yamlls.setup({
		cmd = { "yaml-language-server", "--stdio" },
		filetypes = { "yaml", "yml" },
		capabilities = capabilities,
		on_attach = function(client, _)
			client.server_capabilities.documentFormattingProvider = true
		end,
		settings = {
			yaml = {
				schemas = {
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					["https://json.schemastore.org/github-action.json"] = "/.github/actions/*",
					["https://json.schemastore.org/github-issue-forms.json"] = "/.github/ISSUE_TEMPLATE/*",
					["https://raw.githubusercontent.com/equinor/radix-operator/release/json-schema/radixapplication.json"] = "radixconfig.yaml",
				},
				trace = {
					server = "verbose",
				},
				format = {
					enable = true,
				},
			},
		},
	})
end

return yaml
