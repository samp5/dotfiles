return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" }, -- loads for new files or new buffers
	config = true -- runs require("Comment").setup with default config options
}

