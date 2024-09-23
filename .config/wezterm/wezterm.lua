-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = 'nord'
config.font = wezterm.font 'Hack'
config.font_size = 9.3
config.enable_tab_bar = false
config.warn_about_missing_glyphs = false
config.audible_bell = "Disabled"
config.custom_block_glyphs = true
config.enable_scroll_bar = false
config.window_close_confirmation = "NeverPrompt"

-- and finally, return the configuration to wezterm
return config
