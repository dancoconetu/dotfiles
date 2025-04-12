return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			enter_to_send = true,
			model = "claude-3.5-sonnet",
			-- See Configuration section for options
		},
		keys = {
			{ "<leader>cc", ":CopilotChat<CR>", desc = "Open CopilotChat" },

			{
				"<leader>ccq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, {
							selection = require("CopilotChat.select").buffer,
						})
					end
				end,
				desc = "CopilotChat - Quick chat",
			},

			{
				"<leader>ccl",
				function()
					require("CopilotChat").ask("How can I optimize this?", {
						model = "claude-3.5-sonnet",
						context = { "buffers", "git:staged" },
					})
				end,
				desc = "CopilotChat - Ask about buffer and staged files",
			},

			{
				"<leader>cce",
				function()
					local input = vim.fn.input("Edit Command: ")
					if input ~= "" then
						require("CopilotChat").ask(input, {
							selection = require("CopilotChat.select").buffer,
							agent = "code_edit",
							model = "claude-3.5-sonnet",
						})
					end
				end,
				desc = "CopilotChat - Edit code based on input",
			},
		},
	},
}
