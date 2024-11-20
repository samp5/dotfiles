return {
        "catppuccin/nvim",
        name = "catppuccin",
        event = "User",
        config = function()
                require("catppuccin").setup({
                        no_italic = true,
                })
        end
}
