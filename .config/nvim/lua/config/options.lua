local opt = vim.opt -- for conciseness
local g = vim.g

opt.guicursor = ""
opt.updatetime = 50
opt.laststatus = 3
-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 4 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 4 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.smartindent = true -- smart indent
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping
-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true
-- disable some default providers
g["loaded_python_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_node_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_ruby_provider"] = 0
-- turn off cursorline
-- opt.cursorline = false

-- load the default colorscheme
--vim.cmd([[colorscheme catppuccin-mocha]])

-- start terminal in insert mode
--vim.cmd([[autocmd TermOpen * startinsert]])

-- turn off line numbers in terminal
--vim.cmd([[autocmd TermOpen term://* setlocal nonumber norelativenumber]])
