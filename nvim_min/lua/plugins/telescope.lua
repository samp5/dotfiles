return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- optional but recommended
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				-- Default configuration for telescope goes here:
				-- config_key = value,
				mappings = {
					i = {
						["<C-t>"] = require("trouble.sources.telescope").open,
						["<C-j>"] = require("telescope.actions").move_selection_next,
						["<C-k>"] = require("telescope.actions").move_selection_previous,
						["<C-d>"] = require("telescope.actions").preview_scrolling_down,
						["<C-u>"] = require("telescope.actions").preview_scrolling_up,
					},
				},
			},
		})

		require("telescope").load_extension("fzf")
		local tele = require("telescope.builtin")
		local wk = require("which-key")
		local ic = require("mini.icons")
		wk.add({
			{ "<leader>fh", tele.help_tags, desc = "Help tags", icon = { icon = "", color = "blue" } },
			{ "<leader>fr", tele.resume, desc = "Resume search", icon = { icon = "", color = "blue" } },
			{ "<leader>fs", tele.live_grep, desc = "Live Grep", icon = { icon = "", color = "blue" } },
			{
				"<leader>fw",
				tele.treesitter,
				desc = "Workspace Symbols",
				icon = { icon = ic.get("lsp", "class"), color = "blue" },
			},
			{ "<leader>fb", tele.buffers, desc = "Buffers", icon = { icon = "", color = "blue" } },
			{ "<leader>fg", group = "[G]it", icon = { icon = "", color = "blue" } },
			{ "<leader>fgc", tele.git_commits, desc = "Commits", icon = { icon = "", color = "blue" } },
			{ "<leader>fgo", tele.git_status, desc = "Status", icon = { icon = "󱖫", color = "green" } },
			{ "<leader>f", group = "[F]ind", icon = { icon = "", color = "blue" } },
			{ "<leader>fd", tele.diagnostics, desc = "Diagnostics", icon = { icon = "", color = "red" } },
			{ "<leader>ff", tele.find_files, desc = "Find files", icon = { icon = "󰈞", color = "blue" } },
			{ "<leader>fm", 
        function() tele.man_pages({ sections = { "1", "2", "3", "7" } }) end,
				desc = "Man pages",
				icon = { icon = ic.get("filetype", "help"), color = "blue" },
			},
		})
	end,
}
