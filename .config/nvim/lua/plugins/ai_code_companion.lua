return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		adapters = {
			openai = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "claude-3.5-sonnet",
						},
					},
				})
			end,
		},
		strategies = {
			-- Change the default chat adapter
			chat = {
				adapter = "copilot",
				slash_commands = {
					["file"] = {
						-- Location to the slash command in CodeCompanion
						callback = "strategies.chat.slash_commands.file",
						description = "Select a file using Snacks",
						opts = {
							provider = "snacks", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
							contains_code = true,
						},
					},
				},
			},
			inline = {
				adapter = "copilot",
			},
			cmd = {
				adapter = "copilot",
			},
		},
		display = {
			action_palette = {
				width = 95,
				height = 10,
				prompt = "Prompt ", -- Prompt used for interactive LLM calls
				provider = "default", -- default|telescope
				opts = {
					show_default_actions = true, -- Show the default actions in the action palette?
					show_default_prompt_library = true, -- Show the default prompt library in the action palette?
				},
			},
			chat = {
				window = {
					layout = "vertical", -- float|vertical|horizontal|buffer
					border = "rounded",
					height = 0.8,
					width = 0.40,
					relative = "editor",
					opts = {
						breakindent = true,
						cursorcolumn = false,
						cursorline = false,
						foldcolumn = "0",
						linebreak = true,
						list = false,
						signcolumn = "no",
						spell = false,
						wrap = true,
					},
				},
				intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
				show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
				show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
				separator = "─", -- The separator between the different messages in the chat buffer
				show_settings = false, -- Show LLM settings at the top of the chat buffer?
				show_token_count = true, -- Show the token count for each response?
				start_in_insert_mode = false, -- Open the chat buffer in insert mode?
			},
			diff = {
				enabled = true,
				close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
				layout = "vertical", -- vertical|horizontal split for default provider
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "default", -- default|mini_diff
			},
			inline = {
				-- If the inline prompt creates a new buffer, how should we display this?
				layout = "vertical", -- vertical|horizontal|buffer
			},
		},
		opts = {
			-- Set debug logging
			log_level = "DEBUG",
		},
		commands = {
			-- Add commands for actions and chat
			actions = {
				enable = true,
				keymap = "<leader>ca",
			},
			chat = {
				enable = true,
				keymap = "<leader>cc",
			},
		},
	},
}
