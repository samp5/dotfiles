local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.default_prog = { '/usr/bin/fish' }
config.font = wezterm.font_with_fallback {
  {
    family = 'Fira Code',
    weight = 'Regular',
    -- [Link](https://github.com/tonsky/FiraCode?tab=readme-ov-file)
    harfbuzz_features = { 'ss03', 'zero', 'ss02' },
  },
  {
    family = 'CaskaydiaCove Nerd Font Mono',
  },
}
config.window_padding = {
  right = 0,
  top = 9,
  bottom = 0,
}
config.font_size = 16;
config.enable_tab_bar = false;
config.default_cursor_style = 'SteadyUnderline';
config.use_fancy_tab_bar = false;
config.show_tabs_in_tab_bar = false;
config.show_new_tab_button_in_tab_bar = false;
config.window_decorations = "RESIZE"
config.color_scheme = 'Catppuccin Latte (Gogh)'
-- config.color_scheme = 'Kanagawa (Gogh)';

return config
