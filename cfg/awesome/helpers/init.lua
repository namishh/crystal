local helpers   = {}
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = beautiful.xresources.apply_dpi

helpers.rrect = function(radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end


helpers.colorizeText = function(txt, fg)
  if fg == "" then
    fg = "#ffffff"
  end

  return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

return helpers
