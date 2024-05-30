return {
	'AckslD/nvim-FeMaco.lua',
	lazy = true,
	event = "BufEnter *.md",
	config = function()
		require "femaco".setup({})
	end
}
