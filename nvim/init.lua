vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.have_nerd_font = true

-- ======================================================================
-- ========================== Basic Options =============================
-- ======================================================================
-- Set leader key.
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.wrap = true
vim.opt.backup = false
vim.opt.termguicolors = false
vim.opt.swapfile = false
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.showmode = true
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.shell = "/bin/zsh"

--* Neovim settings *--
vim.opt.cmdheight = 0 --* Truly disable statusline (even in splits) *--
vim.opt.laststatus = 0
vim.opt.statusline = '%{repeat("─",winwidth("."))}'
vim.cmd("highlight! link StatusLine Normal")
vim.cmd("highlight! link StatusLineNC Normal")

vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<Up>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Up>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Left>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Right>", "<nop>", { noremap = true, silent = true })

if vim.g.neovide then
	-- Helper function for transparency formatting
	vim.g.neovide_window_blurred = true
	vim.g.neovide_scroll_animation_far_lines = 1
	vim.g.neovide_cursor_animation_length = 0.01
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animate_command_line = false

	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0

	vim.g.neovide_transparency = 0.95
	vim.g.neovide_window_blurred = true

	-- Copy/Paste using Ctrl+C & Ctrl+V
	vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
	vim.keymap.set("v", "<D-c>", '"+y') -- Copy
	vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
	vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
	vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
	vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end

--* Terminal autocmd *--
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
	callback = function()
		local is_terminal = vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal"
			or vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "nofile"
		vim.opt.number = not is_terminal
		vim.opt.signcolumn = is_terminal and "no" or "yes"
	end,
})

-- ====================================================================
-- ============================ Plugins ===============================
-- ====================================================================
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		opts = {
			direction = "float",
			persist_mode = true,
			float_opts = {
				border = "curved",
				winblend = 3,
			},
		},
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{ "echasnovski/mini.icons", version = false },
	{ "shortcuts/no-neck-pain.nvim" },
	{ "numToStr/Comment.nvim", opts = {} },
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"projekt0n/github-nvim-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			vim.cmd("colorscheme github_dark_default")
		end,
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = true,
				filesystem = {
					follow_current_file = {
						enabled = true,
						leave_dirs_opsn = true,
					},
				},
				width = 20,
				buffers = {
					follow_current_file = {
						enabled = true,
						leave_dirs_opsn = false,
					},
					window = {
						width = 20,
					},
				},
			})
		end,
	},
	{ -- Status line bar
		"nvim-lualine/lualine.nvim",
		opts = {
			globalstatus = true,
			winbar = {},
		},
	},
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Keymap suggestion tooltip
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			require("which-key").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = { prompt_position = "top" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous, -- move to prev result
							["<C-j>"] = actions.move_selection_next, -- move to next result
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
							["<esc>"] = actions.close,
							["C-c"] = actions.close,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					file_browser = {
						path = "%:p:h", -- open from within the folder of your current buffer
						display_stat = false, -- don't show file stat
						grouped = true, -- group initial sorting by directories and then files
						hidden = true, -- show hidden files
						hide_parent_dir = true, -- hide `../` in the file browser
						hijack_netrw = true, -- use telescope file browser when opening directory paths
						prompt_path = true, -- show the current relative path from cwd as the prompt prefix
						use_fd = true, -- use `fd` instead of plenary, make sure to install `fd`
					},
				},
			})
			pcall(telescope.load_extension, "ui-select")
		end,
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
				},
			})
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>rf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gD", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map(
						"<C-s>",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[F]ind Workspace [S]ymbol"
					)

					map("<leader>rn", vim.lsp.buf.rename, "Refactor: [n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap.
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following autocommand is used to enable inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				terraformls = {},
				gopls = {},
				rust_analyzer = {},
				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			--* load LSP for the current filetype *--
			local default_setup = function(server)
				require("lspconfig")[server].setup({
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				})
			end

			require("mason").setup({ ui = { border = "rounded" } })

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					default_setup,
				},
			})

			local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treesitter** module to be loaded in time.
			-- Luckily, the only things that those plugins need are the custom queries, which we make available
			-- during startup.
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts = {
			ensure_installed = {
				"bash",
				"diff",
				"html",
				"lua",
				"markdown",
				"vim",
				"json",
				"lua",
				"yaml",
				"go",
				"gowork",
				"gomod",
				"svelte",
			},
			auto_install = true,
			indent = { enable = true },
			highlight = { enabled = true },
			incremental_selection = {
				enabled = false,
			},
			textobjects = {
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					enable = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
						["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
						["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
						["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

						["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
						["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
						["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
						["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },

						["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
						["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

						["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
						["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

						["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
						["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

						["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
						["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

						["am"] = {
							query = "@function.outer",
							desc = "Select outer part of a method/function definition",
						},
						["im"] = {
							query = "@function.inner",
							desc = "Select inner part of a method/function definition",
						},

						["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
						["<leader>n:"] = "@property.outer", -- swap object property with next
						["<leader>nm"] = "@function.outer", -- swap function with next
					},
					swap_previous = {
						["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
						["<leader>p:"] = "@property.outer", -- swap object property with prev
						["<leader>pm"] = "@function.outer", -- swap function with previous
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = { query = "@call.outer", desc = "Next function call start" },
						["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
						["]c"] = { query = "@class.outer", desc = "Next class start" },
						["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
						["]l"] = { query = "@loop.outer", desc = "Next loop start" },

						-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
						-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]F"] = { query = "@call.outer", desc = "Next function call end" },
						["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
						["]C"] = { query = "@class.outer", desc = "Next class end" },
						["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
						["]L"] = { query = "@loop.outer", desc = "Next loop end" },
					},
					goto_previous_start = {
						["[f"] = { query = "@call.outer", desc = "Prev function call start" },
						["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
						["[c"] = { query = "@class.outer", desc = "Prev class start" },
						["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
						["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
					},
					goto_previous_end = {
						["[F"] = { query = "@call.outer", desc = "Prev function call end" },
						["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
						["[C"] = { query = "@class.outer", desc = "Prev class end" },
						["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
						["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
					},
				},
			},

			-- textobjects = {
			-- 	enable = true,
			-- 	select = {
			-- 		enable = true,
			-- 		lookahead = true,
			-- 	},
			-- 	move = {
			-- 		enabled = true,
			-- 	},
			-- },
		},
		config = function(_, opts)
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.configs").setup(opts)
			vim.cmd([[TSEnable highlight]])
		end,
		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		enabled = true,
	},
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		-- Optional dependency
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			-- If you want to automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- ====================================================================
-- =========================== Auto Commands ==========================
-- ====================================================================
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Format-on-save for Go files using goimports.
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
	group = format_sync_grp,
})

-- ====================================================================
-- ====================== Basic Key bindings ==========================
-- ====================================================================
vim.keymap.set("n", "<leader><cr>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>")
vim.keymap.set("n", "<leader>gt", "<cmd>GoAddTag<CR>")
vim.keymap.set("n", "<leader>fe", "<cmd>Neotree<CR>")
vim.keymap.set("n", "<leader>gT", "<cmd>GoTestPkg<CR>")
vim.keymap.set("n", "<C-\\>", "<cmd>ToggleTerm<CR>")

-- Telescope related key bindings.
local ts_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fc", ts_builtin.commands, { desc = "[F]ind using [G]rep" })
vim.keymap.set("n", "<space>", ts_builtin.live_grep, { desc = "[F]ind using [G]rep" })
vim.keymap.set("n", "<leader>ff", ts_builtin.find_files, { desc = "[F]ind: [F]iles" })
vim.keymap.set("n", "<leader>fb", ts_builtin.buffers, { desc = "[F]ind: [B]uffers" })
vim.keymap.set("n", "<leader>fd", ts_builtin.diagnostics, { desc = "[F]ind: [d]iagnostics" })
vim.keymap.set("n", "<leader>fr", ts_builtin.oldfiles, { desc = "[F]ind: [r]ecent files" })

vim.keymap.set("n", "/", function()
	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
	ts_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 3,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })
