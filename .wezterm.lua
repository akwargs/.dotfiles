-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { "nvim" }

config.color_scheme = [[Github (base16)]]
config.font = wezterm.font("JetBrainsMonoNL Nerd Font Mono", { weight = "Light" })
config.font_size = 10.0
config.line_height = 1.0
config.cell_width = 1.0
config.initial_cols = 200
config.initial_rows = 50
config.window_padding = {
  left = 20,
  right = 0,
  top = 5,
  bottom = 5,
}
config.colors = {
  cursor_bg = "#4FFF33",
  cursor_fg = "black",
  cursor_border = "#52ad70",
}

return config
