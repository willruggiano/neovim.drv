local themes = require "telescope.themes"

return {
  cursor = themes.get_cursor {},
  ivy = themes.get_ivy { layout_config = { preview_cutoff = 150 }, winblend = 5 },
}
