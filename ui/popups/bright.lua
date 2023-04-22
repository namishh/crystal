local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local animation = require("modules.animation")
local helpers = require("helpers")
local lightdaemon = require("daemons.light")

local bpop = function(s)
  local icon = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.icofont .. " 60",
    halign = "center",
  }
  local progress = wibox.widget {
    widget = wibox.widget.progressbar,
    forced_width = 130,
    forced_height = 15,
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    value = 0,
    max_value = 1,
    background_color = beautiful.mbg,
    color = beautiful.primary,
  }
  local anim = animation:new {
    duration = 0.1,
    easing = animation.easing.linear,
    update = function(self, pos)
      progress:set_value(pos)
    end,
  }

  local widget = awful.popup {
    type = "notification",
    visible = false,
    ontop = true,
    placement = function(c)
      awful.placement.centered(c, { offset = { y = 0 - (s.geometry.height / 3) } })
    end,
    minimum_width = 170,
    minimum_height = 170,
    shape = gears.shape.rectangle,
    bg = gears.color.transparent,
    widget = {
      {
        widget = wibox.container.place,
        halign = "center",
        valign = "center",
        { layout = wibox.layout.fixed.vertical, spacing = 20, icon, progress },
      },
      widget = wibox.container.background,
      bg = beautiful.bg,
      shape = helpers.rrect(5)
    }
  }
  local hide = gears.timer {
    timeout = 1,
    callback = function()
      widget.visible = false
    end
  }
  local show = false
  lightdaemon:connect_signal("update", function(self, percentage)
    if show == true then
      if percentage == 0 or percentage <= 35 then
        icon.text = "󰃜"
      elseif percentage > 35 and percentage <= 75 then
        icon.text = "󰃛"
      elseif percentage > 50 then
        icon.text = "󰃚"
      end
      anim:set(percentage / 100)

      if widget.visible then
        hide:again()
      else
        widget.visible = true
        hide:again()
      end
    else
      anim:set(percentage / 100)
      show = true
    end
  end)

  return widget
end


awful.screen.connect_for_each_screen(function(s)
  bpop(s)
end)
