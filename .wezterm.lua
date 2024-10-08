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
config.font_size = 15;
config.default_cursor_style = 'SteadyUnderline';
config.use_fancy_tab_bar = false;
config.show_tabs_in_tab_bar = false;
config.show_new_tab_button_in_tab_bar = false;
config.window_decorations = "RESIZE"
config.color_scheme = 'Kanagawa (Gogh)';
-- config.color_scheme = 'Catppuccin Macchiato'

return config
