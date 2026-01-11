local has_words_before = function()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	if col == 0 then
		return false
	end
	local line = vim.api.nvim_get_current_line()
	return line:sub(col, col):match("%s") == nil
end
return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap

		-- in your blink configuration
		keymap = {
			preset = "none",

			-- If completion hasn't been triggered yet, insert the first suggestion; if it has, cycle to the next suggestion.
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = { auto_show = true },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				path = {
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
