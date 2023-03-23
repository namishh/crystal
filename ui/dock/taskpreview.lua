-- code adapted from bling for my dock
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local cairo = require("lgi").cairo

local drawpreview = function(c, v)
  local content = gears.surface(c.content)
  local cr = cairo.Context(content)
  local x, y, w, h = cr:clip_extents()
  local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w - x, h - y)
  cr = cairo.Context(img)
  cr:set_source_surface(content, 0, 0)
  cr.operator = cairo.Operator.SOURCE
  cr:paint()
  local widget = awful.popup {
    ontop = true,
    visible = v,
    bg = beautiful.bg,
    placement = function(cl) awful.placement.bottom(cl, { margins = dpi(50) }) end,
    shape = helpers.rrect(8),
    widget = wibox.container.background
  }
  widget:setup {
    {
      id = "image_role",
      resize = true,
      image = img,
      visible = v,
      clip_shape = helpers.rrect(8),
      widget = wibox.widget.imagebox,
    },
    height = 300,
    width = 200,
    visible = v,
    widget = wibox.container.constraint
  }
  if not v then
    collectgarbage("collect")
    widget:setup {
      height = 0,
      width = 0,
      visible = v,
      widget = wibox.container.constraint

    }
  end
end

return drawpreview
