-- ═══════════════════════════════════════════════════════════════
-- Minimal nvim config with vim.pack
-- ═══════════════════════════════════════════════════════════════

print("Using " .. (vim.env.NVIM_APPNAME or "default"))

-- Keymaps
vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")
vim.keymap.set("n", "<leader>nh", "<cmd>noh<CR>")
vim.keymap.set("n", "<leader>ss", "<cmd>set spell!<CR>")

-- UI
vim.opt.linebreak = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 10
vim.opt.completeopt = { "menuone", "noinsert", "fuzzy" }

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-completion", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

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
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

-- Plugins: setup
vim.cmd.colorscheme("miniautumn")
vim.api.nvim_set_hl(0, "Comment", { fg = "#FF0000" })

require("mini.icons").setup()
require("mini.statusline").setup()
require("oil").setup({ view_options = { show_hidden = true } })
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "html", "cssls", "ts_ls", "pyright", "yamlls" },
})

require("mason-tool-installer").setup({
	ensure_installed = { "stylua", "ruff", "prettier" },
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
	},
	format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
})

require("nvim-treesitter").install({
	"lua",
	"vim",
	"vimdoc",
	"markdown",
	"html",
	"css",
	"javascript",
	"typescript",
	"python",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})

-- Plugins: Oil keymaps
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

-- Plugins: Telescope keymaps
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>gf", "<cmd>Telescope git_files<cr>", { desc = "Find git tracked files" })
-- TODO: Convert to function to enable hidden
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set(
	"n",
	"<leader>en",
	"<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<cr>",
	{ desc = "Edit Neovim config" }
)
vim.keymap.set(
	"n",
	"<leader>ep",
	"<cmd>Telescope find_files cwd=" .. vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt") .. "<cr>",
	{ desc = "Edit Neovim packages" }
)

-- LSP: setup
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})
