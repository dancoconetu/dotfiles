-- ~/.config/nvim/lua/user/utils.lua

local M = {}

--- Ensures the Avante sidebar is open.
-- Tries to open it via API if closed.
-- Returns true if open after execution, false otherwise.
function M.ensure_avante_open()
	-- Safely require avante core
	local avante_ok, avante = pcall(require, "avante")
	if not avante_ok or not avante or not avante.get then
		vim.notify("Avante not found or invalid. Please install/update avante.nvim.", vim.log.levels.WARN)
		return false
	end

	-- Get sidebar instance
	local sidebar = avante.get()
	if not sidebar then
		vim.notify("Failed to get Avante sidebar instance (initial check).", vim.log.levels.ERROR)
		return false
	end

	-- Check if already open
	if sidebar:is_open() then
		-- vim.notify("Avante sidebar is already open.", vim.log.levels.INFO) -- Optional: uncomment for feedback
		return true
	end

	-- If closed, try to open via API
	vim.notify("Avante sidebar is closed. Attempting to open...", vim.log.levels.INFO)
	local api_ok, api = pcall(require, "avante.api")
	if not api_ok or not api or not api.ask then
		vim.notify("Avante API module/function not found. Cannot open sidebar automatically.", vim.log.levels.ERROR)
		return false
	end

	-- Call api.ask() safely
	local ask_ok, ask_err = pcall(api.ask)
	if not ask_ok then
		-- Log the error we saw previously, just in case
		vim.notify("Error calling avante.api.ask(): " .. tostring(ask_err), vim.log.levels.ERROR)
		-- Even if 'ask' fails, maybe the sidebar state changed? Re-check below.
	end

	-- Re-get the sidebar instance *after* calling ask, as it might change
	sidebar = avante.get()
	if not sidebar then
		vim.notify("Failed to get Avante sidebar instance (after trying to open).", vim.log.levels.ERROR)
		return false -- Failed to get instance after attempting open
	end

	if sidebar:is_open() then
		vim.notify("Avante sidebar opened successfully.", vim.log.levels.INFO)
		return true
	else
		vim.notify("Failed to open Avante sidebar (remained closed after attempt).", vim.log.levels.WARN)
		return false
	end
end

return M
