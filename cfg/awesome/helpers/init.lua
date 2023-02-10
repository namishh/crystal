local helpers   = {}
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = beautiful.xresources.apply_dpi

helpers.rrect = function(radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

helpers.prect = function(tl, tr, br, bl, radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end
helpers.clickKey = function(c, key)
  awful.spawn.with_shell("xdotool type --window " .. tostring(c.window) .. " '" .. key .. "'")
end

helpers.colorizeText = function(txt, fg)
  if fg == "" then
    fg = "#ffffff"
  end

  return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

return helpers
