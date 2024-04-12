local wezterm = require 'wezterm'
local config = wezterm.config_builder()
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
config.font_size = 10;
config.initial_cols = 100;
config.initial_rows = 40
config.default_cursor_style = 'SteadyUnderline'
config.use_fancy_tab_bar = false;
config.show_tabs_in_tab_bar = false;
config.show_new_tab_button_in_tab_bar = false;
config.color_scheme = 'Kanagawa (Gogh)'
config.window_background_opacity = 0.96;
config.window_decorations = "RESIZE"
return config
