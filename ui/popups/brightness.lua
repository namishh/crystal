local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local animation = require("mods.animation")

-- osd --

local info = wibox.widget {
  widget = wibox.container.margin,
  margins = 20,
  {
    layout = wibox.layout.fixed.horizontal,
    fill_space = true,
    spacing = 8,
    {
      widget = wibox.widget.textbox,
      id = "icon",
      font = beautiful.icon .. " 14",
    },
    {
      widget = wibox.container.background,
      forced_width = 36,
      {
        widget = wibox.widget.textbox,
        id = "text",
        halign = "center"
      },
    },
    {
      widget = wibox.widget.progressbar,
      id = "progressbar",
      max_value = 100,
      forced_width = 380,
      forced_height = 10,
      background_color = beautiful.mbg,
      color = beautiful.blue,
    },
  }
}

local osd = awful.popup {
  visible = false,
  ontop = true,
  minimum_height = 60,
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


-- bright --

awesome.connect_signal("signal::brightness", function(value)
  anim:set(value)
  info:get_children_by_id("text")[1].text = value
  if value > 90 then
    info:get_children_by_id("icon")[1].text = "󰃠"
  elseif value > 60 then
    info:get_children_by_id("icon")[1].text = "󰃟"
  elseif value > 30 then
    info:get_children_by_id("icon")[1].text = "󰃝"
  elseif value > 10 then
    info:get_children_by_id("icon")[1].text = "󰃞"
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

awesome.connect_signal("open::osdb", function()
  osd_toggle()
end)
