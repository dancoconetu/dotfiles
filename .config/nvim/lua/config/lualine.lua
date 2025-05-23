local get_active_lsp = function()
	local msg = "No Active Lsp"
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) == nil then
		return msg
	end

	local exclude_clients = {} -- Clients to exclude from display
	local active_clients = {}
	for _, client in ipairs(clients) do
		-- Skip excluded clients
		if not vim.tbl_contains(exclude_clients, client.name) then
			table.insert(active_clients, client.name)
		end
	end

	if #active_clients > 0 then
		return table.concat(active_clients, ", ")
	end
	return msg
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			-- statusline = {},
			-- winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		},
	},
	sections = {
		lualine_a = {
			"mode",
		},
		lualine_b = {

			"branch",
			"diff",
			"diagnostics",
		},
		lualine_c = {
			"filename",
			-- { harpoon_files.lualine_component },
		},

		lualine_x = {
			{
				get_active_lsp,
				icon = " LSP:",
			},
			"encoding",
			"filetype",
		},
		lualine_y = { "location" },
		lualine_z = {
			{
				"copilot",
				icon_enabled = true, -- Show an icon next to the status
				show_colors = true, -- Enable colored output for different statuses
			},
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- dap ui
local dap = require("dap")
vim.keymap.set("n", "<leader>di", function()
	dap.repl.open()
	dap.repl.execute(vim.fn.expand("<cexpr>"))
end)
vim.keymap.set("v", "<leader>di", function()
	-- getregion requires nvim 0.10
	local lines = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))
	dap.repl.open()
	dap.repl.execute(table.concat(lines, "\n"))
end)
