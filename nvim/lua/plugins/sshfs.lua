return {
  "nosduco/remote-sshfs.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  opts = {
    -- Refer to the configuration section below
    -- or leave empty for defaults
  },
  config = function ()
    require'remote-sshfs'.setup{}
    require'telescope'.load_extension'remote-sshfs'
  end
}
