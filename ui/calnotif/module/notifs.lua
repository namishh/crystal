local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local helpers   = require("helpers")
local wibox     = require("wibox")
local naughty   = require("naughty")
local gears     = require("gears")

local create    = function(n)
  local title_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.sans .. '  12',
    markup = helpers.colorizeText(n.title, beautiful.fg),
    align = "left",
    forced_width = 200,
  }

  local text_notif = wibox.widget {
    font = beautiful.sans .. ' 10',
    markup = helpers.colorizeText(n.message, beautiful.fg2),
    align = "left",
    forced_width = 165,
    widget = wibox.widget.textbox,
  }

  local widget = wibox.widget {
    {
      {
        title_widget,
        text_notif,
        spacing = 10,
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.margin,
      margins = 15,
    },
    widget = wibox.container.background,
    bg = beautiful.mbg,
    forced_height = 100,
    shape = helpers.rrect(5),
    shape_border_width = 1,
    shape_border_color = beautiful.fg3,
  }
  widget:buttons(gears.table.join(awful.button({}, 1, function()
    notif_center_remove_notif(widget)
  end)))

  return widget
end


local empty                         = wibox.widget {
  {
    {
      widget = wibox.widget.textbox,
      markup = helpers.colorizeText("You are completely caught up :)", beautiful.comm),
      font = beautiful.sans .. " 14",
      valign = "center",
      align = "center",
    },
    margins = { top = dpi(15) },
    widget = wibox.container.margin
  },
  widget = wibox.container.background,
  forced_height = 260,
}

local finalcontent                  = wibox.widget {
  layout = require('mods.overflow').vertical,
  scrollbar_enabled = false,
  spacing = 15,
}

local remove_notifs_empty           = true

notif_center_reset_notifs_container = function()
  finalcontent:reset(finalcontent)
  finalcontent:insert(1, empty)
  remove_notifs_empty = true
end

notif_center_remove_notif           = function(box)
  finalcontent:remove_widgets(box)

  if #finalcontent.children == 0 then
    finalcontent:insert(1, empty)
    remove_notifs_empty = true
  end
end

finalcontent:insert(1, empty)
naughty.connect_signal("request::display", function(n)
  if #finalcontent.children == 1 and remove_notifs_empty then
    finalcontent:reset(finalcontent)
    remove_notifs_empty = false
  end

  finalcontent:insert(1, create(n))
end)



local widget = wibox.widget {
  {
    {
      {
        {
          markup = helpers.colorizeText("Notifs", beautiful.fg2),
          halign = 'center',
          font   = beautiful.sans .. " 14",
          widget = wibox.widget.textbox
        },
        nil,
        {
          {
            {
              {
                widget = wibox.widget.imagebox,
                image = beautiful.trash,
                forced_height = 20,
                forced_width = 20,
                valign = 'center',
                resize = true,
              },
              {
                markup = helpers.colorizeText("Delete", beautiful.fg2),
                halign = 'center',
                valign = 'center',
                font   = beautiful.sans .. " 12",
                widget = wibox.widget.textbox
              },
              spacing = 8,
              layout = wibox.layout.fixed.horizontal,
            },
            widget = wibox.container.margin,
            top = 4,
            bottom = 4,
            left = 10,
            right = 10,
          },

          widget = wibox.container.background,
          bg = beautiful.mbg,
          shape_border_width = 1,
          shape_border_color = beautiful.fg3,
          buttons = {
            awful.button({}, 1, function()
              notif_center_reset_notifs_container()
            end)
          },
          shape = helpers.rrect(5),
        },
        layout = wibox.layout.align.horizontal,
      },
      finalcontent,
      spacing = 15,
      layout = wibox.layout.fixed.vertical,
    },
    margins = 15,
    widget = wibox.container.margin,
  },
  widget = wibox.container.background,
  bg = beautiful.mbg,
  shape_border_width = 1,
  shape_border_color = beautiful.fg3,
  shape = helpers.rrect(5),
}

return widget
