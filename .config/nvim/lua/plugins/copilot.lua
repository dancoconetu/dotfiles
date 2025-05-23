return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 50,
			keymap = {
				accept = "<M-l>",
				accept_word = "<M-w>",
				accept_line = "<M-]>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
		},

		panel = { enabled = true },
		filetypes = {
			markdown = true,
			help = true,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
		},
		copilot_node_command = "node",
		server_opts_overrides = {
			inlineSuggestCount = 3, -- Number of suggestions to receive
			temperature = 0.2, -- Lower temperature for more focused suggestions
			choices = 1, -- Number of choices to generate
			model = "claude-3.7-sonnet", -- or "copilot-chat" depending on your subscription
		},
	},
}
