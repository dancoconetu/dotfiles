-- ~/.config/nvim/lua/plugins/neotest.lua

return {
	-- Plenary test adapter
	{ "nvim-neotest/neotest-plenary" },

	-- .NET test adapter
	-- { "Nsidorenco/neotest-dotnet" },
	{ "Issafalcon/neotest-dotnet" },

	-- Main neotest plugin
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio", -- REQUIRED for async
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-plenary",
			-- "Nsidorenco/neotest-dotnet",
			"Issafalcon/neotest-dotnet",
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				log_level = 1,
				adapters = {
					require("neotest-plenary"),
					require("neotest-dotnet")({
						-- sdk_path = "/usr/lib/dotnet/sdk/8.0.115",
						sdk_path = "/usr/lib/dotnet/sdk/9.0.105",
						-- 	discovery_root = "solution",
						-- 	dap_settings = {
						-- 		adapter = "coreclr",
						-- 		name = "coreclr - attach",
						-- 	},
					}),
				},
			})

			-- Keybindings (all user-triggered, so async-safe)
			vim.keymap.set("n", "<C-A-t>", function()
				neotest.summary.toggle()
			end, { desc = "Toggle Neotest Summary" })

			vim.keymap.set("n", "<leader>tt", function()
				neotest.run.run()
			end, { desc = "Run nearest test" })

			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "Run test file" })

			vim.keymap.set("n", "<leader>td", function()
				neotest.run.run({ strategy = "dap" })
			end, { desc = "Debug nearest test" })

			vim.keymap.set("n", "<leader>ts", function()
				neotest.run.stop()
			end, { desc = "Stop test" })

			vim.keymap.set("n", "<leader>ta", function()
				neotest.run.run(vim.fn.getcwd())
			end, { desc = "Run all tests in project" })
			-- Show output for nearest test (floating window)
			vim.keymap.set("n", "<leader>to", function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end, { desc = "Show Output (Neotest)" })
		end,
	},
}
