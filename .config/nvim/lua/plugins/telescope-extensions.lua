-- ~/.config/nvim/lua/plugins/telescope.lua

return {
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	-- Ensure avante.nvim is loaded before telescope if not managed elsewhere
	-- { "yetone/avante.nvim", lazy = false },

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			-- Add explicit dependency if necessary for load order
			-- "yetone/avante.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local builtin = require("telescope.builtin")
			local themes = require("telescope.themes")
			local log = require("telescope.log")

			-- Safely require plenary.path
			local plenary_path_ok, Path = pcall(require, "plenary.path")
			if not plenary_path_ok then
				vim.notify("Telescope Config Error: plenary.path not found.", vim.log.levels.ERROR)
				return -- Stop if plenary is missing
			end

			--- Custom Action: Add selected file path(s) from Telescope to avante.nvim context
			local add_selected_to_avante_context = function(prompt_bufnr)
				log.warn("add_selected_to_avante_context called with prompt_bufnr: " .. vim.inspect(prompt_bufnr))

				-- Safely require Avante module
				local avante_ok, avante = pcall(require, "avante")
				if not avante_ok or not avante or not avante.get then
					vim.notify(
						"Avante Integration Error: Failed to require 'avante' or 'avante.get'.",
						vim.log.levels.ERROR
					)
					log.error("Avante Integration Error: Failed to require 'avante' or 'avante.get'.")
					actions.close(prompt_bufnr)
					return
				end

				local sidebar = avante.get()
				if not sidebar then
					vim.notify("Avante Integration Error: Failed to get Avante sidebar instance.", vim.log.levels.ERROR)
					log.error("Avante Integration Error: Failed to get Avante sidebar instance.")
					actions.close(prompt_bufnr)
					return
				end

				if not sidebar.file_selector or not sidebar.file_selector.add_selected_file then
					vim.notify(
						"Avante Integration Error: 'sidebar.file_selector:add_selected_file' method not found.",
						vim.log.levels.ERROR
					)
					log.error("Avante Integration Error: 'sidebar.file_selector:add_selected_file' method not found.")
					actions.close(prompt_bufnr)
					return
				end

				local picker = action_state.get_current_picker(prompt_bufnr)
				if not picker then
					log.error(
						"Telescope->Avante: Failed to get picker instance for bufnr: " .. vim.inspect(prompt_bufnr)
					)
					vim.notify("Critical Error: Could not get Telescope picker instance.", vim.log.levels.ERROR)
					pcall(actions.close, prompt_bufnr)
					return
				end

				log.warn("Telescope->Avante: Successfully got picker instance.")

				local selections = picker:get_multi_selection()
				if vim.tbl_isempty(selections) then
					local entry = action_state.get_selected_entry()
					if entry then
						selections = { entry }
					else
						log.warn("Telescope->Avante: No selection found.")
						actions.close(prompt_bufnr)
						return
					end
				end

				local files_added = 0
				local files_failed = 0
				local unique_abs_paths = {} -- Use a set to avoid adding the same file multiple times

				for _, entry in ipairs(selections) do
					-- *** CORRECTED PATH EXTRACTION ***
					-- Prioritize 'filename' (correct for grep), fallback to 'value'/'path' (for find_files etc.)
					local file_path = entry.filename or entry.value or entry.path
					-- *** END CORRECTION ***

					if not file_path or file_path == "" then
						log.warn("Telescope->Avante: Could not determine file path for entry: " .. vim.inspect(entry))
						files_failed = files_failed + 1 -- Corrected increment
						goto continue
					end

					-- Make path absolute using the CORRECT plenary method :absolute()
					local abs_path_str
					local path_ok, path_result = pcall(function()
						-- Ensure Path object is available
						if not Path then
							log.error("Telescope->Avante: Plenary Path object is nil!")
							return nil -- Indicate failure
						end
						return Path:new(file_path):absolute()
					end)

					if path_ok and path_result then -- Check path_result is not nil
						abs_path_str = path_result
					else
						-- Log the error from the pcall
						log.warn(
							("Telescope->Avante: Failed to process path '%s': %s"):format(
								tostring(file_path),
								tostring(path_result)
							)
						)
						files_failed = files_failed + 1 -- Corrected increment
						goto continue
					end

					-- Check for uniqueness before trying to add
					if not unique_abs_paths[abs_path_str] then
						unique_abs_paths[abs_path_str] = true -- Mark as seen

						-- Add the absolute path using the sidebar's file_selector instance
						local add_ok, add_err =
							pcall(sidebar.file_selector.add_selected_file, sidebar.file_selector, abs_path_str)
						if add_ok then
							files_added = files_added + 1 -- Corrected increment
							log.info(("Telescope->Avante: Added '%s'"):format(abs_path_str))
						else
							files_failed = files_failed + 1 -- Corrected increment
							log.warn(
								("Telescope->Avante: Error calling add_selected_file for '%s': %s"):format(
									abs_path_str,
									tostring(add_err)
								)
							)
							-- Avoid excessive notifications, summarize at the end
						end
					else
						log.info(("Telescope->Avante: Skipping duplicate path '%s'"):format(abs_path_str))
					end

					::continue::
				end

				actions.close(prompt_bufnr)

				-- User feedback
				if files_added > 0 then
					local message = ("Avante: Added %d unique file(s) from Telescope."):format(files_added)
					if files_failed > 0 then
						message = message .. (" Failed %d item(s)."):format(files_failed)
						vim.notify(message, vim.log.levels.WARN, { title = "Telescope -> Avante" })
					else
						vim.notify(message, vim.log.levels.INFO, { title = "Telescope -> Avante" })
					end
				elseif files_failed > 0 then
					vim.notify(
						("Avante: Failed %d item(s). No files added."):format(files_failed),
						vim.log.levels.ERROR,
						{ title = "Telescope -> Avante" }
					)
				else
					log.warn("Telescope->Avante: No new files were added or processed.")
					-- Optional: Notify if nothing happened but selections were made
					if #selections > 0 then
						vim.notify(
							"Avante: No new unique files to add from selection.",
							vim.log.levels.INFO,
							{ title = "Telescope -> Avante" }
						)
					end
				end
			end -- end of add_selected_to_avante_context function
			-- Configure Telescope Setup (unchanged)
			telescope.setup({
				defaults = {
					layout_strategy = "horizontal",
					layout_config = { horizontal = { prompt_position = "top", preview_width = 0.55 } },
					sorting_strategy = "ascending",
					path_display = {
						filename_first = {
							reverse_directories = false,
						},
					},
					mappings = {
						i = { -- Insert mode mappings
							["<C-n>"] = actions.move_selection_next,
							["<C-p>"] = actions.move_selection_previous,
							["<C-c>"] = actions.close,
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-a>"] = add_selected_to_avante_context,
						},
						n = { -- Normal mode mappings
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["q"] = actions.close,
							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-b>"] = open_avante,
							["<C-a>"] = function(prompt_bufnr)
								if open_avante() then
									add_selected_to_avante_context(prompt_bufnr)
								end
							end,
						},
					},
				},
				pickers = {},
				-- extensions = {
				-- 	["ui-select"] = { themes.get_dropdown({}) },
				-- },
			})

			-- Load extensions (unchanged)
			-- telescope.load_extension("ui-select")

			-- Global keymaps to OPEN Telescope pickers (unchanged)
			vim.keymap.set("n", "<C-p>", function()
				builtin.find_files({ cwd = vim.fn.getcwd() })
			end, { desc = "[Telescope] Find Files" })
			-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[Telescope] Live Grep" })
			-- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[Telescope] Find Buffers" })
			-- vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[Telescope] Recent Files (Oldfiles)" })

			print("Telescope configured with corrected Avante context integration (<C-a>).")
		end, -- end config function
	}, -- end telescope plugin entry
} -- end return
