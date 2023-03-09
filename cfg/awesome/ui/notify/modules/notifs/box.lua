local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")
local naughty   = require("naughty")
local gears     = require("gears")
local empty     = require("ui.notify.modules.notifs.empty")
local create    = require("ui.notify.modules.notifs.make")

local clearButton = wibox.widget {
  {
    {
      font = beautiful.font .. " 12",
      markup = helpers.colorizeText("Clear All", beautiful.fg .. 'cc'),
      widget = wibox.widget.textbox,
      valign = "center",
      align = "center",
    },
    margins = dpi(8),
    widget = wibox.container.margin
  },
  bg = beautiful.fg .. '11',
  widget = wibox.container.background,

}
local title = wibox.widget
{
  font = beautiful.font .. " 14",
  markup = "Notifications (0)",
  widget = wibox.widget.textbox,
  valign = "center",
  align = "center"
}
local header = wibox.widget {
  title,
  nil,
  clearButton,
  layout = wibox.layout.align.horizontal,
}
local finalcontent = wibox.widget {
  nil,
  spacing = 20,
  layout = wibox.layout.fixed.vertical,
}
local remove_notifs_empty = true

notif_center_reset_notifs_container = function()
  finalcontent:reset(finalcontent)
  finalcontent:insert(1, empty)
  remove_notifs_empty = true
  title.markup = 'Notifications (0)'
end

notif_center_remove_notif = function(box)
  finalcontent:remove_widgets(box)

  if #finalcontent.children == 0 then
    finalcontent:insert(1, empty)
    title.markup = 'Notifications (0)'
    remove_notifs_empty = true
  else
    title.markup = 'Notifications (' .. #finalcontent.children .. ')'
  end
end
finalcontent:insert(1, empty)
naughty.connect_signal("request::display", function(n)
  if #finalcontent.children == 1 and remove_notifs_empty then
    finalcontent:reset(finalcontent)
    remove_notifs_empty = false
  end

  local appicon = n.icon or n.app_icon
  if not appicon then
    appicon = 'none'
  end
  title.markup = 'Notifications (' .. #finalcontent.children + 1 .. ')'
  finalcontent:insert(1, create(appicon, n))
end)
local finalwidget = wibox.widget {
  {
    {
      header,
      finalcontent,
      spacing = dpi(20), widget = wibox.container.scroll.vertical,
      step_function = wibox.container.scroll,
      layout = wibox.layout.fixed.vertical,
    },
    margins = dpi(20),
    widget = wibox.container.margin
  },
  bg = beautiful.bg2 .. 'cc',
  widget = wibox.container.background,
}

clearButton:buttons(gears.table.join(awful.button({}, 1, function()
  notif_center_reset_notifs_container()
end)))
return finalwidget
