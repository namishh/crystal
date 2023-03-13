-- Copyleft © 2022 Saimoomedits
--most stuff copied from guy above


local naughty = require("naughty")
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local ruled = require("ruled")
local menubar = require("menubar")
local gears = require("gears")



naughty.connect_signal("request::icon", function(n, context, hints)
  if context ~= "app_icon" then return end

  local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

  if path then n.icon = path end

end)

local function get_oldest_notification()
  for _, notification in ipairs(naughty.active) do
    if notification and notification.timeout > 0 then
      return notification
    end
  end

  --- Fallback to first one.
  return naughty.active[1]
end

-- naughty config
naughty.config.defaults.ontop    = true
naughty.config.defaults.screen   = awful.screen.focused()
naughty.config.defaults.timeout  = 10
naughty.config.defaults.title    = "Ding!"
naughty.config.defaults.position = "top_left"


-- Timeouts
naughty.config.presets.low.timeout      = 10
naughty.config.presets.critical.timeout = 0

-- ruled notification
ruled.notification.connect_signal("request::rules", function()
  ruled.notification.append_rule {
    rule = {},
    properties = { screen = awful.screen.preferred, implicit_timeout = 6 }
  }
end)



-- connect to each display
--------------------------
naughty.connect_signal("request::display", function(n)


  -- action widget
  local action_widget = {
    {
      {
        id = "text_role",
        align = "center",
        valign = "center",
        font = beautiful.font .. " 10",
        widget = wibox.widget.textbox
      },
      left = dpi(6),
      right = dpi(6),
      widget = wibox.container.margin
    },
    bg = beautiful.bg_2,
    forced_height = dpi(30),
    shape = helpers.rrect(2),
    widget = wibox.container.background
  }


  -- actions
  local actions = wibox.widget {
    notification = n,
    base_layout = wibox.widget {
      spacing = dpi(8),
      layout = wibox.layout.flex.horizontal
    },
    widget_template = action_widget,
    style = { underline_normal = false, underline_selected = true },
    widget = naughty.list.actions
  }



  -- image
  local image_n = wibox.widget {
    {
      opacity = 0.6,
      image = n.icon,
      resize = true,
      halign = "center",
      valign = "center",
      widget = wibox.widget.imagebox,
    },
    strategy = "exact",
    height = dpi(50),
    width = dpi(50),
    widget = wibox.container.constraint,
  }


  -- title
  local title_n = wibox.widget {
    {
      {
        markup = n.title,
        font   = beautiful.font .. " Bold 11",
        align  = "left",
        valign = "center",
        widget = wibox.widget.textbox
      },
      forced_width  = dpi(240),
      widget        = wibox.container.scroll.horizontal,
      step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
      speed         = 50
    },
    margins = { right = 15 },
    widget  = wibox.container.margin
  }


  local message_n = wibox.widget {
    {
      {
        markup = helpers.colorizeText("<span weight='normal'>" .. n.message .. "</span>", beautiful.fg .. "BF"),
        font   = beautiful.font .. " 11",
        align  = "left",
        valign = "center",
        wrap   = "char",
        widget = wibox.widget.textbox
      },
      forced_width = dpi(240),
      layout       = wibox.layout.fixed.horizontal
    },
    margins = { right = 15 },
    widget  = wibox.container.margin
  }


  -- app name
  local aname = ''
  if n.app_name ~= '' then
    aname = n.app_name
  else
    aname = 'naughty'
  end
  local app_name_n = wibox.widget {
    markup = helpers.colorizeText(aname, beautiful.fg .. "BF"),
    font   = beautiful.font .. " 10",
    align  = "left",
    valign = "center",
    widget = wibox.widget.textbox
  }

  local time_n = wibox.widget {
    {
      markup = helpers.colorizeText("now", beautiful.fg .. "BF"),
      font   = beautiful.font .. " 10",
      align  = "right",
      valign = "center",
      widget = wibox.widget.textbox
    },
    margins = { right = 20 },
    widget  = wibox.container.margin
  }

  local close = wibox.widget {
    markup = helpers.colorizeText('󰅖', beautiful.err),
    font   = beautiful.icofont .. " 12",
    align  = "ceneter",
    valign = "center",
    widget = wibox.widget.textbox
  }

  close:buttons(gears.table.join(
    awful.button({}, 1, function() n:destroy(naughty.notification_closed_reason.dismissed_by_user) end)))


  -- extra info
  local notif_info = wibox.widget {
    app_name_n,
    {
      widget = wibox.widget.separator,
      shape = gears.shape.circle,
      forced_height = dpi(4),
      forced_width = dpi(4),
      color = beautiful.fg .. "BF"
    },
    time_n,
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(7)
  }




  local widget = naughty.layout.box {
    notification    = n,
    type            = "notification",
    bg              = beautiful.bg_color,
    shape           = helpers.rrect(beautiful.rounded),
    widget_template = {
      {

        { -- top bit
          {
            {
              {
                notif_info,
                nil,
                close,
                layout = wibox.layout.align.horizontal,
                expand = "none"
              },
              margins = { left = dpi(15), right = dpi(15), top = dpi(10), bottom = dpi(10) },
              widget = wibox.container.margin
            },
            widget = wibox.container.background,
            bg = beautiful.bg2,
          },
          layout = wibox.layout.fixed.vertical
        },

        { -- body
          {
            {
              title_n,
              message_n,
              layout = wibox.layout.fixed.vertical,
              spacing = dpi(3)
            },
            nil,
            image_n,
            layout = wibox.layout.align.horizontal,
            expand = "none"
          },
          margins = { left = dpi(15), top = dpi(10), right = dpi(10) },
          widget = wibox.container.margin
        },

        { -- foot
          actions,
          margins = dpi(10),
          widget = wibox.container.margin
        },

        layout = wibox.layout.fixed.vertical,
        spacing = dpi(10)

      },

      widget = wibox.container.background,
      shape = helpers.rrect(3),
      bg = beautiful.bg,
    }
  }

  widget.buttons = {}



end)

