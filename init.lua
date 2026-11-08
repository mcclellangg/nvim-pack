-- ═══════════════════════════════════════════════════════════════
-- Minimal nvim config with vim.pack()
-- ═══════════════════════════════════════════════════════════════

print("Using " .. (vim.env.NVIM_APPNAME or "default"))

-- Keymaps
vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

-- UI
vim.opt.linebreak = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 10

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Plugins: install
vim.pack.add({
	"https://github.com/nvim-mini/mini.hues",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-mini/mini.statusline",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/neovim/nvim-lspconfig",
})

-- Plugins: setup
vim.cmd.colorscheme("miniwinter")
vim.api.nvim_set_hl(0, "Comment", { fg = "#FF0000" })

require("mini.icons").setup()
require("mini.statusline").setup()
require("oil").setup({ view_options = { show_hidden = true } })

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })

-- LSP: enable
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

vim.lsp.enable("lua_ls")
