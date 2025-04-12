return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	dependencies = {
		"mikavilpas/blink-ripgrep.nvim",
		"fang2hou/blink-copilot",
	},
	version = "*",
	-- dev = true,
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "none",
			["<C-y>"] = { "select_and_accept" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
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
				"copilot",
				"lsp",
				"ripgrep",
				"path",
				"buffer",
			},
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					-- the options below are optional, some default values are shown
					---@module "blink-ripgrep"
					---@type blink-ripgrep.Options
					opts = {
						-- For many options, see `rg --help` for an exact description of
						-- the values that ripgrep expects.

						-- the minimum length of the current word to start searching
						-- (if the word is shorter than this, the search will not start)
						prefix_min_len = 3,

						-- The number of lines to show around each match in the preview
						-- (documentation) window. For example, 5 means to show 5 lines
						-- before, then the match, and another 5 lines after the match.
						context_size = 5,

						-- The maximum file size of a file that ripgrep should include in
						-- its search. Useful when your project contains large files that
						-- might cause performance issues.
						-- Examples:
						-- "1024" (bytes by default), "200K", "1M", "1G", which will
						-- exclude files larger than that size.
						max_filesize = "1M",

						-- Specifies how to find the root of the project where the ripgrep
						-- search will start from. Accepts the same options as the marker
						-- given to `:h vim.fs.root()` which offers many possibilities for
						-- configuration. If none can be found, defaults to Neovim's cwd.
						--
						-- Examples:
						-- - ".git" (default)
						-- - { ".git", "package.json", ".root" }
						project_root_marker = ".git",

						-- Enable fallback to neovim cwd if project_root_marker is not
						-- found. Default: `true`, which means to use the cwd.
						project_root_fallback = true,

						-- The casing to use for the search in a format that ripgrep
						-- accepts. Defaults to "--ignore-case". See `rg --help` for all the
						-- available options ripgrep supports, but you can try
						-- "--case-sensitive" or "--smart-case".
						search_casing = "--ignore-case",

						-- (advanced) Any additional options you want to give to ripgrep.
						-- See `rg -h` for a list of all available options. Might be
						-- helpful in adjusting performance in specific situations.
						-- If you have an idea for a default, please open an issue!
						--
						-- Not everything will work (obviously).
						additional_rg_options = {},

						-- When a result is found for a file whose filetype does not have a
						-- treesitter parser installed, fall back to regex based highlighting
						-- that is bundled in Neovim.
						fallback_to_regex_highlighting = true,

						-- Absolute root paths where the rg command will not be executed.
						-- Usually you want to exclude paths using gitignore files or
						-- ripgrep specific ignore files, but this can be used to only
						-- ignore the paths in blink-ripgrep.nvim, maintaining the ability
						-- to use ripgrep for those paths on the command line. If you need
						-- to find out where the searches are executed, enable `debug` and
						-- look at `:messages`.
						ignore_paths = {},

						-- Any additional paths to search in, in addition to the project
						-- root. This can be useful if you want to include dictionary files
						-- (/usr/share/dict/words), framework documentation, or any other
						-- reference material that is not available within the project
						-- root.
						additional_paths = {},

						-- Keymaps to toggle features on/off. This can be used to alter
						-- the behavior of the plugin without restarting Neovim. Nothing
						-- is enabled by default. Requires folke/snacks.nvim.
						toggles = {
							-- The keymap to toggle the plugin on and off from blink
							-- completion results. Example: "<leader>tg"
							on_off = nil,
						},

						-- Features that are not yet stable and might change in the future.
						-- You can enable these to try them out beforehand, but be aware
						-- that they might change. Nothing is enabled by default.
						future_features = {
							-- Workaround for
							-- https://github.com/mikavilpas/blink-ripgrep.nvim/issues/185. This
							-- is a temporary fix and will be removed in the future.
							issue185_workaround = false,

							backend = {
								-- The backend to use for searching. Defaults to "ripgrep".
								-- Available options:
								-- - "ripgrep", always use ripgrep
								-- - "gitgrep", always use git grep
								-- - "gitgrep-or-ripgrep", use git grep if possible, otherwise
								--   ripgrep
								use = "ripgrep",
							},
						},

						-- Show debug information in `:messages` that can help in
						-- diagnosing issues with the plugin.
						debug = false,
					},
					-- (optional) customize how the results are displayed. Many options
					-- are available - make sure your lua LSP is set up so you get
					-- autocompletion help
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							if item.source_name == "Ripgrep" then
								-- For ripgrep results
								item.labelDetails = {
									description = "(rg)",
								}
							elseif item.source_name == "copilot" then
								-- For Copilot results, show the model
								item.labelDetails = {
									description = "(Copilot)",
								}
							end
						end
						return items
					end,
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
