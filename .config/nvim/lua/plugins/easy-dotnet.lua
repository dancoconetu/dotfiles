local function add_dotnet_mappings()
	local dotnet = require("easy-dotnet")

	vim.api.nvim_create_user_command("Secrets", function()
		dotnet.secrets()
	end, {})

	vim.keymap.set("n", "<A-t>", function()
		vim.cmd("Dotnet testrunner")
	end, { nowait = true })

	vim.keymap.set("n", "<leader>dp>", function()
		dotnet.run_with_profile(true)
	end, { nowait = true })

	vim.keymap.set("n", "<C-b>", function()
		dotnet.build_default_quickfix()
	end, { nowait = true })
end

return {
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		local dotnet = require("easy-dotnet")
		dotnet.setup({
			auto_bootstrap_namespace = true,
			csproj_mappings = true,
			test_runner = {
				---@type "split" | "float" | "buf"
				viewmode = "float",
				enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
				noBuild = true,
				noRestore = true,
				icons = {
					passed = "",
					skipped = "",
					failed = "",
					success = "",
					reload = "",
					test = "",
					sln = "󰘐",
					project = "󰘐",
					dir = "",
					package = "",
				},
				mappings = {
					run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
					filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
					debug_test = { lhs = "<leader>d", desc = "debug test" },
					go_to_file = { lhs = "g", desc = "got to file" },
					run_all = { lhs = "<leader>R", desc = "run all tests" },
					run = { lhs = "<leader>r", desc = "run test" },
					peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
					expand = { lhs = "o", desc = "expand" },
					expand_node = { lhs = "E", desc = "expand node" },
					expand_all = { lhs = "-", desc = "expand all" },
					collapse_all = { lhs = "W", desc = "collapse all" },
					close = { lhs = "q", desc = "close testrunner" },
					refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
				},
				--- Optional table of extra args e.g "--blame crash"
				additional_args = {},
			},
			terminal = function(path, action, args)
				local commands = {
					run = function()
						return string.format("dotnet run --project %s %s", path, args)
					end,
					test = function()
						return string.format("dotnet test %s %s", path, args)
					end,
					restore = function()
						return string.format("dotnet restore %s %s", path, args)
					end,
					build = function()
						return string.format("dotnet build %s %s", path, args)
					end,
					watch = function()
						return string.format("dotnet watch --project %s %s", path, args)
					end,
				}

				local command = commands[action]() .. "\r"
				require("toggleterm").exec(command, nil, nil, nil, "float")
			end,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if dotnet.is_dotnet_project() then
					add_dotnet_mappings()
				end
			end,
		})
	end,
}
