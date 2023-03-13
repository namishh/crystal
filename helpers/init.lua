local helpers   = {}
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = beautiful.xresources.apply_dpi
local cairo     = require("lgi").cairo


helpers.rrect        = function(radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

helpers.placeWidget  = function(widget)
  if beautiful.barDir == 'left' then
    awful.placement.bottom_left(widget, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  elseif beautiful.barDir == 'right' then
    awful.placement.bottom_right(widget, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  elseif beautiful.barDir == 'bottom' then
    awful.placement.bottom_right(widget, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  elseif beautiful.barDir == 'top' then
    awful.placement.top_right(widget, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  end
end

helpers.prect        = function(tl, tr, br, bl, radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

helpers.clickKey     = function(c, key)
  awful.spawn.with_shell("xdotool type --window " .. tostring(c.window) .. " '" .. key .. "'")
end

helpers.colorizeText = function(txt, fg)
  if fg == "" then
    fg = "#ffffff"
  end

  return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

helpers.cropSurface  = function(ratio, surf)
  local old_w, old_h = gears.surface.get_size(surf)
  local old_ratio = old_w / old_h
  if old_ratio == ratio then return surf end

  local new_h = old_h
  local new_w = old_w
  local offset_h, offset_w = 0, 0
  -- quick mafs
  if (old_ratio < ratio) then
    new_h = math.ceil(old_w * (1 / ratio))
    offset_h = math.ceil((old_h - new_h) / 2)
  else
    new_w = math.ceil(old_h * ratio)
    offset_w = math.ceil((old_w - new_w) / 2)
  end

  local out_surf = cairo.ImageSurface(cairo.Format.ARGB32, new_w, new_h)
  local cr = cairo.Context(out_surf)
  cr:set_source_surface(surf, -offset_w, -offset_h)
  cr.operator = cairo.Operator.SOURCE
  cr:paint()

  return out_surf
end

return helpers
