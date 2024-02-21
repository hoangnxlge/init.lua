local opt = vim.opt
vim.g.mapleader = " "
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.syntax = "on"
opt.number = true
opt.relativenumber = true
opt.ignorecase = true
opt.colorcolumn = "80"
opt.shell = ""

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

require("lazy").setup({
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
		},
		config = function() end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = "Format buffer",
			},
		},
		-- Everything in opts will be passed to setup()
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				python = { "isort", "black" },
				javascript = { { "prettierd", "prettier" } },
			},
			-- Set up format-on-save
			-- format_on_save = { timeout_ms = 500, lsp_fallback = true },
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup()

			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			extensions = {
				flutter,
			},
		},
	},
	{
		"pocco81/auto-save.nvim",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		keys = {
			{
				"<leader>e",
				"<cmd>Neotree focus<cr>",
				desc = "NeoTree",
			},
		},
		opts = {
			window = {
				mappings = {
					["o"] = "open",
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	},
	{
		"NvChad/nvterm",
		config = function()
			require("nvterm").setup()

			local terminal = require("nvterm.terminal")

			local ft_cmds = {
				--python = "python3 " .. vim.fn.expand('%'),
				--...
				--<your commands here>
			}
			local toggle_modes = { "n", "t" }
			local mappings = {
				{
					"n",
					"<C-l>",
					function()
						require("nvterm.terminal").send(ft_cmds[vim.bo.filetype])
					end,
				},
				{
					toggle_modes,
					"<A-h>",
					function()
						require("nvterm.terminal").toggle("horizontal")
					end,
				},
				{
					toggle_modes,
					"<A-v>",
					function()
						require("nvterm.terminal").toggle("vertical")
					end,
				},
				{
					toggle_modes,
					"<A-i>",
					function()
						require("nvterm.terminal").toggle("float")
					end,
				},
			}
			local opts = { noremap = true, silent = true }
			for _, mapping in ipairs(mappings) do
				vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
			end
		end,
		opts = {
			terminals = {
				shell = vim.o.shell,
				list = {},
				type_opts = {
					float = {
						relative = "editor",
						row = 0.3,
						col = 0.25,
						width = 0.5,
						height = 0.4,
						border = "single",
					},
					horizontal = { location = "rightbelow", split_ratio = 0.3 },
					vertical = { location = "rightbelow", split_ratio = 0.5 },
				},
			},
			behavior = {
				autoclose_on_quit = {
					enabled = false,
					confirm = true,
				},
				close_on_exit = true,
				auto_insert = true,
			},
		},
	},
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = true,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
		},
		config = function()
			-- import lspconfig plugin
			local lspconfig = require("lspconfig")

			-- import cmp-nvim-lsp plugin
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			local keymap = vim.keymap -- for conciseness

			local opts = { noremap = true, silent = true }
			local on_attach = function(client, bufnr)
				opts.buffer = bufnr

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end

			-- used to enable autocompletion (assign to every lsp server config)
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Change the Diagnostic symbols in the sign column (gutter)
			-- (not in youtube nvim video)
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end


			-- configure python server
			lspconfig["pyright"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
	},
})

-- Keymaps

local map = vim.keymap.set
local allModes = { "n", "i", "v" }
map("n", "<leader>qq", "<cmd>xa!<cr>", { desc = "Save and quit" })
map(allModes, "<c-h>", "<c-w>h", { desc = "Focus on left window" })
map(allModes, "<c-j>", "<c-w>j", { desc = "Focus on down window" })
map(allModes, "<c-k>", "<c-w>k", { desc = "Focus on up window" })
map(allModes, "<c-l>", "<c-w>l", { desc = "Focus on right window" })
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
map(allModes, "<c-z>", "<cmd>u<cr>", { desc = "Undo" })

-- Keymaps for telescope
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Search all text" })
map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
