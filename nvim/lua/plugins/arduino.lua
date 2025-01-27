return {
  "stevearc/vim-arduino",
  ft = "arduino",
  config = function()
    local wk = require 'which-key'
    wk.add({
      { "<leader>r",  group = "a[R]duino",           bufffer = 0 },
      { "<leader>ra", "<cmd>ArduinoAttach<CR>",      bufffer = 0 },
      { "<leader>rv", "<cmd>ArduinoVerify<CR>",      bufffer = 0 },
      { "<leader>ru", "<cmd>ArduinoUpload<CR>",      bufffer = 0 },
      { "<leader>rs", "<cmd>ArduinoSerial<CR>",      bufffer = 0 },
      { "<leader>rb", "<cmd>ArduinoChooseBoard<CR>", bufffer = 0 },
    })
  end
}
