local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")
require("lazy").setup("plugins")
require("config.lualine")

local utils = require("user.utils") -- Adjust path if needed

vim.api.nvim_create_user_command("OpenAvante", utils.ensure_avante_open, {
	desc = "Ensures the Avante sidebar is open, attempting to open it if closed.",
	-- Other options like 'bang', 'range', etc., can be added here if needed
})
