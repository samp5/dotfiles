return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "%.class" },
					path_display = { "smart" },
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--multiline",
					},
					layout_strategy = "flex",
					selection_caret = " ",
					prompt_prefix = " ",
					multi_icon = " ",
				},
			})

			local tele = require("telescope.builtin")
			local wk = require("which-key")
			wk.add({
				{ "<leader>f", group = "[F]ind", icon = { icon = "", color = "blue" } },
				{
					"<leader>fc",
					tele.current_buffer_fuzzy_find,
					desc = "FF Current Buffer",
					icon = { icon = "󰮗", color = "blue" },
				},
				{ "<leader>fd", tele.diagnostics, desc = "Diagnostics", icon = { icon = "", color = "red" } },
				{ "<leader>ff", tele.find_files, desc = "Find files", icon = { icon = "󰈞", color = "blue" } },
				{ "<leader>fh", tele.help_tags, desc = "Help tags", icon = { icon = "", color = "blue" } },
				{
					"<leader>fm",
					function()
						tele.man_pages({ sections = { "1", "2", "3", "7" } })
					end,
					desc = "Man pages",
				},
				{ "<leader>fr", tele.resume, desc = "Resume search", icon = { icon = "", color = "blue" } },
				{ "<leader>fs", tele.live_grep, desc = "Live Grep", icon = { icon = "", color = "blue" }
 },
			})
		end,
	},
}
