return {
  "jbyuki/nabla.nvim",
  config = function()
    local wk = require("which-key")
    local n = require "nabla"
    wk.register({
      ["<leader>nt"] = { function()
        n.toggle_virt({
          autogen = true,
        })
      end, "Toggle nabla" }

    })
  end
}
