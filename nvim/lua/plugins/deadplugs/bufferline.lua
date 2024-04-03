--[[
return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = { -- so we don't have to call a config function, calls require(bufferline).setup(opts)
		options = {
			mode = "tabs",
			separator_style = "slant",
		},
	},
}
]]--
