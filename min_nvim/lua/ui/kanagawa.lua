return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			transparent = true,
			commentStyle = { italic = false },
			keywordStyle = { italic = false },
			statementStyle = { bold = true },
			dimInactive = false,
			terminalColors = true,
			theme = "wave",
			background = {
				dark = "wave",
			},
		})
	end,
}
