local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local helpers   = require("helpers")
local wibox     = require("wibox")
local naughty   = require("naughty")
local gears     = require("gears")

local create    = function(n, icon)
  local title_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.sans .. '  12',
    markup = helpers.colorizeText(n.title, beautiful.fg),
    align = "left",
    forced_width = 200,
  }

  local text_notif = wibox.widget {
    font = beautiful.sans .. ' 12',
    markup = helpers.colorizeText(n.message, beautiful.fg2),
    align = "left",
    valign = "top",
    widget = wibox.widget.textbox,
  }

  local image_width = 120
  local image_height = 120
  local image = wibox.widget {
    {
      image = icon,
      resize = true,
      halign = "center",
      opacity = 0.6,
      valign = "center",
      widget = wibox.widget.imagebox,
    },
    strategy = "exact",
    forced_height = image_height,
    forced_width = image_width,
    widget = wibox.container.constraint,
  }

  local widget = wibox.widget {
    {
      {
        {
          title_widget,
          widget = wibox.container.margin,
          margins = 10,
        },
        widget = wibox.container.background,
        bg = beautiful.magenta .. '18',
      },
      {
        {
          {
            {
              image,
              widget = wibox.container.place,
              valign = "center",
            },

            text_notif,
            spacing = 4,
            layout = wibox.layout.fixed.horizontal,
          },
          widget = wibox.container.place,
          valign = "center",
          halign = "left",
        },
        widget = wibox.container.margin,
        margins = 10,
      },
      spacing = 4,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.background,
    bg = beautiful.mab,
    forced_height = 150,
    shape = helpers.rrect(10),
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
      markup = helpers.colorizeText("No Notifications!", beautiful.comm),
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
  forced_height = 320,
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
  local appicon = n.icon or n.app_icon
  if not appicon then
    appicon = beautiful.awesome_icon
  end

  finalcontent:insert(1, create(n, appicon))
end)



local widget = wibox.widget {
  {
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
              top = 8,
              bottom = 8,
              left = 10,
              right = 10,
            },

            widget = wibox.container.background,
            bg = beautiful.red .. '22',
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
    bg = beautiful.blue .. '11',
    shape = helpers.rrect(10),
  },
  widget = wibox.container.margin,
  top = 15,
  left = 15,
  right = 15,
}

return widget
