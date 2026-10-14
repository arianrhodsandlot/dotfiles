local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.adjust_window_size_when_changing_font_size = false
config.default_cursor_style = 'BlinkingBlock'
config.font = wezterm.font_with_fallback {
  { family = 'CodeNewRoman Nerd Font Mono' },
}
config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 10000
config.use_dead_keys = false
config.warn_about_missing_glyphs = false
config.window_close_confirmation = 'NeverPrompt'

return config
