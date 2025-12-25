local wezterm = require 'wezterm'
local commands = require 'commands'
local constants = require 'constants'

local config = wezterm.config_builder()

-- --------------------------------------------------
-- Platform detection
-- --------------------------------------------------
local is_macos = wezterm.target_triple:find 'darwin' ~= nil
local is_linux = wezterm.target_triple:find 'linux' ~= nil

-- --------------------------------------------------
-- Font
-- --------------------------------------------------
config.font_size = 11.5

config.font = wezterm.font_with_fallback {
  {
    family = 'JetBrains Mono Nerd Font',
    harfbuzz_features = {
      'calt',
      'liga',
      'ss01',
      'ss02',
      'ss03',
      'ss04',
      'ss05',
      'ss06',
      'ss07',
      'ss08',
      'ss09',
    },
  },
  { family = 'Symbols Nerd Font Mono' },
}

config.font_rules = {
  {
    intensity = 'Bold',
    font = wezterm.font('JetBrains Mono Nerd Font', { weight = 'Bold' }),
  },
  {
    italic = true,
    font = wezterm.font('JetBrains Mono Nerd Font', { style = 'Italic' }),
  },
}

-- --------------------------------------------------
-- Colors
-- --------------------------------------------------
config.color_scheme = 'Catppuccin Mocha'

-- --------------------------------------------------
-- Appearance
-- --------------------------------------------------
config.cursor_blink_rate = 0
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- --------------------------------------------------
-- Background image (loaded from constants.lua)
-- --------------------------------------------------
config.window_background_image = wezterm.config_dir .. '/' .. constants.bg_image

config.window_background_image_hsb = {
  brightness = 0.15,
  hue = 1.0,
  saturation = 1.0,
}

-- --------------------------------------------------
-- Linux / Fedora (Wayland)
-- --------------------------------------------------
if is_linux then
  config.prefer_egl = true
  config.max_fps = 120
end

-- --------------------------------------------------
-- macOS
-- --------------------------------------------------
if is_macos then
  config.macos_window_background_blur = 40
  config.window_decorations = 'RESIZE'
end

-- --------------------------------------------------
-- Custom commands
-- --------------------------------------------------
wezterm.on('augment-command-palette', function()
  return commands
end)

return config
