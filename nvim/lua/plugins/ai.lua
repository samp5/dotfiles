return {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = false;
    },
    signs = { enabled = false },
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
  },
}
