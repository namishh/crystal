local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local animation = require("mods.animation")
local helpers = require("helpers")

-- osd --

local info = wibox.widget {
  {
    widget = wibox.container.margin,
    margins = 20,
    {
      layout = wibox.layout.fixed.horizontal,
      fill_space = true,
      spacing = 8,
      {
        widget = wibox.widget.imagebox,
        forced_width = 25,
        forced_height = 25,
        resize = true,
        id = "icon",
      },
      {
        widget = wibox.widget.progressbar,
        id = "progressbar",
        max_value = 100,
        forced_width = 380,
        forced_height = 10,
        shape = helpers.rrect(5),
        background_color = beautiful.mbg,
        color = beautiful.fg,
      },
    }
  },
  background_color = beautiful.bg,
  widget = wibox.container.background,
  shape_border_width = 1,
  shape_border_color = beautiful.fg3,
  shape = helpers.rrect(5),
}

local osd = awful.popup {
  visible = false,
  ontop = true,
  minimum_height = 60,
  shape = helpers.rrect(5),
  maximum_height = 60,
  minimum_width = 290,
  maximum_width = 290,
  placement = function(d)
    awful.placement.bottom(d, { margins = 20, honor_workarea = true, })
  end,
  widget = info,
}

local anim = animation:new {
  duration = 0.3,
  easing = animation.easing.linear,
  update = function(self, pos)
    info:get_children_by_id("progressbar")[1].value = pos
  end,
}

-- volume --

local getimg = function(image)
  return gears.color.recolor_image(
    gears.filesystem.get_configuration_dir() .. "theme/icons/osd/" .. image .. ".svg", beautiful.fg)
end

-- bright --

awesome.connect_signal("signal::volume", function(value)
  anim:set(value)
  if value > 60 then
    info:get_children_by_id("icon")[1].image = getimg("speaker-high")
  else
    info:get_children_by_id("icon")[1].image = getimg("speaker-low")
  end
end)

-- function --

local function osd_hide()
  osd.visible = false
  osd_timer:stop()
end

local osd_timer = gears.timer {
  timeout = 4,
  callback = osd_hide
}

local function osd_toggle()
  if not osd.visible then
    osd.visible = true
    osd_timer:start()
  else
    osd_timer:again()
  end
end

awesome.connect_signal("open::osd", function()
  osd_toggle()
end)
