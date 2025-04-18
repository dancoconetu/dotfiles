return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	dependencies = {
		"mikavilpas/blink-ripgrep.nvim",
		"fang2hou/blink-copilot",
	},
	version = "*",
	opts = {
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
		keymap = {
			preset = "none",
			["<CR>"] = { "select_and_accept", "fallback" },
			["<Tab>"] = { "select_next" },
			["<S-Tab>"] = { "select_prev" },
			["<C-d>"] = { "scroll_documentation_down" },
			["<C-u>"] = { "scroll_documentation_up" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		},
		signature = { enabled = true },
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
			kind_icons = {
				Copilot = "",
			},
		},
		completion = {
			menu = {
				border = "single",
			},
			documentation = {
				auto_show = true, -- Automatically show documentation
				auto_show_delay_ms = 20, -- Delay before showing documentation
				window = {
					border = "single",
				},
			},
		},
		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = {
				"lsp",
				"easy-dotnet",
				"path",
				"copilot",
				-- "ripgrep",
				"buffer",
			},
			providers = {
				lsp = {
					name = "lsp",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					score_offset = 90,
				},
				["easy-dotnet"] = {
					name = "easy-dotnet",
					enabled = true,
					module = "easy-dotnet.completion.blink",
					score_offset = 10000,
					async = true,
				},
				path = {
					name = "Path",
					module = "blink.cmp.sources.path",
					score_offset = 25,
					fallbacks = { "snippets", "buffer" },
					opts = {
						trailing_slash = false,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = true,
					},
				},
				buffer = {
					name = "Buffer",
					enabled = true,
					max_items = 3,
					module = "blink.cmp.sources.buffer",
					min_keyword_length = 4,
					score_offset = 15,
				},
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
