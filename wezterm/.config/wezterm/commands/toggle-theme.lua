local wezterm = require 'wezterm'

local command = {
  brief = 'Toggle theme',
  icon = 'md_theme_light_dark',
  action = wezterm.action_callback(function(window)
    local shell = os.getenv 'SHELL' or '/bin/sh'
    local home = os.getenv 'HOME'

    local is_latte = window:effective_config().color_scheme
        == 'Catppuccin Latte'

    if is_latte then
      wezterm.run_child_process {
        shell,
        '-c',
        home .. '/.config/tmux/switch-catppuccin-theme.sh mocha',
      }
    else
      wezterm.run_child_process {
        shell,
        '-c',
        home .. '/.config/tmux/switch-catppuccin-theme.sh latte',
      }
    end
  end),
}

return command
