local awful     = require('awful')
local naughty   = require('naughty')
local ruled     = require('ruled')
local beautiful = require("beautiful")
local wibox     = require("wibox")
local dpi       = beautiful.xresources.apply_dpi
local helpers   = require("helpers")
local menubar   = require("menubar")
local animation = require("mods.animation")
local gears     = require("gears")

--- Notifications
ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule({
    rule       = nil,
    properties = {
      screen           = awful.screen.preferred,
      implicit_timeout = 5
    }
  })
end)



naughty.connect_signal("request::icon", function(n, context, hints)
  if context ~= "app_icon" then return end

  local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

  if path then n.icon = path end
end)


-- naughty config
naughty.config.defaults.ontop           = true
naughty.config.defaults.screen          = awful.screen.focused()
naughty.config.defaults.timeout         = 10
naughty.config.defaults.title           = "Notification!"
naughty.config.defaults.position        = "bottom_left"

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
        font = beautiful.sans .. " 10",
        widget = wibox.widget.textbox
      },
      left = dpi(6),
      right = dpi(6),
      widget = wibox.container.margin
    },
    bg = beautiful.mbg,
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
      {
        opacity = 0.9,
        image = n.icon and helpers.cropSurface(1, gears.surface.load_uncached(n.icon)) or
            beautiful.notif_bell,
        resize = true,
        halign = "center",
        valign = "center",
        clip_shape = helpers.rrect(50),
        widget = wibox.widget.imagebox,
      },
      strategy = "exact",
      height = dpi(50),
      width = dpi(50),
      widget = wibox.container.constraint,
    },
    id = "arc",
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    value = 100,
    rounded_edge = true,
    thickness = dpi(4),
    start_angle = 4.71238898,
    bg = beautiful.blue .. '33',
    colors = { beautiful.blue },
    forced_width = dpi(60),
    forced_height = dpi(60)
  }
  local anim = animation:new {
    duration = 6,
    target = 100,
    reset_on_stop = false,
    easing = animation.easing.linear,
    update = function(_, pos)
      image_n:get_children_by_id('arc')[1].value = pos
    end,
  }
  anim:connect_signal("ended", function()
    n:destroy()
  end)

  -- title
  local title_n = wibox.widget {
    {
      {
        markup = n.title,
        font   = beautiful.sans .. " 12",
        align  = "right",
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
        font   = beautiful.sans .. " 12",
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
    font   = beautiful.sans .. " 10",
    align  = "left",
    valign = "center",
    widget = wibox.widget.textbox
  }

  local time_n = wibox.widget {
    {
      markup = helpers.colorizeText("now", beautiful.fg .. "BF"),
      font   = beautiful.sans .. " 10",
      align  = "right",
      valign = "center",
      widget = wibox.widget.textbox
    },
    margins = { right = 20 },
    widget  = wibox.container.margin
  }

  local close = wibox.widget {
    widget = wibox.widget.imagebox,
    image = beautiful.titlebar_close_button_focus,
    forced_height = 25,
    forced_width = 25,
    resize = true,
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
    bg              = beautiful.bg,
    shape           = helpers.rrect(10),
    widget_template = {
      {
        {
          -- top bit
          {
            {
              {
                notif_info,
                nil,
                close,
                layout = wibox.layout.align.horizontal,
                expand = "none"
              },
              margins = { left = dpi(10), right = dpi(10), top = dpi(10), bottom = dpi(10) },
              widget = wibox.container.margin
            },
            widget = wibox.container.background,
            bg = beautiful.blue .. '11',
          },
          layout = wibox.layout.fixed.vertical
        },
        {
          -- body
          {
            image_n,
            {
              title_n,
              message_n,
              layout = wibox.layout.fixed.vertical,
              spacing = dpi(3)
            },
            layout = wibox.layout.fixed.horizontal,
            spacing = 20,
          },
          margins = { left = dpi(15), top = dpi(5), right = dpi(10), bottom = dpi(15) },
          widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(10)
      },
      widget = wibox.container.background,
      shape = helpers.rrect(10),
      bg = beautiful.bg,
    }
  }

  widget.buttons = {}
  anim:start()
end)
