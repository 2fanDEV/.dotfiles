return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},
	config = function()
		require("fidget").setup({})
		local servers = {
			rust_analyzer = {
				settings = {
				},
			},
			ts_ls = {
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayVariableTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "Lua 5.1" },
						diagnostics = { globals = { "vim", "it", "describe", "before_each", "after_each" } },
					},
				},
			},
		}

		local ensure_installed = {}
		for name, _ in pairs(servers) do
			table.insert(ensure_installed, name)
		end

		table.insert(ensure_installed, "ts_ls")
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
		})

		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.textDocument.inlayHint = { dynamicRegistration = true }

		local on_attach = function(client, bufnr)
			if client.name == "rust_analyzer" and client.server_capabilities.inlayHintProvider then
				-- Wait until the server sends "initialized" notification
				client.rpc.notify("initialized") -- or hook via a proper callback
				vim.defer_fn(function()
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end, 0) -- minimal delay, only triggers after initialization
			elseif client.server_capabilities.inlayHintProvider then
				-- other LSPs (TypeScript, Lua, etc.)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end

		for server_name, server_config in pairs(servers) do
			lspconfig[server_name].setup(vim.tbl_deep_extend("force", {
				capabilities = capabilities,
				on_attach = on_attach,
			}, server_config))
		end

		vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
			if not result then
				return
			end
			local filtered = {}
			for _, d in ipairs(result.diagnostics) do
				if not (d.code == 6133 or d.code == 6196) then
					table.insert(filtered, d)
				end
			end
			result.diagnostics = filtered
			vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, config)
		end

		local cmp = require("cmp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-x>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			update_in_insert = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
