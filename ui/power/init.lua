local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

awful.screen.connect_for_each_screen(function(s)
  local powermenu = wibox({
    screen = s,
    width = 230,
    height = 270,
    bg = beautiful.bg .. 00,
    ontop = true,
    visible = false,
  })

  local button = function(label, cmd, image)
    local img = gears.color.recolor_image(
      gears.filesystem.get_configuration_dir() .. "theme/icons/power/" .. image .. ".svg", beautiful.fg)

    local widget = wibox.widget {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = img,
            valign = 'center',
            forced_height = 20,
            forced_width = 20,
            resize = true,
          },
          {
            markup = helpers.colorizeText(label, beautiful.fg),
            halign = 'center',
            valign = 'center',
            font   = beautiful.sans .. " 12",
            widget = wibox.widget.textbox
          },
          layout = wibox.layout.fixed.horizontal,
          spacing = 10,
        },
        widget = wibox.container.margin,
        margins = 10,
      },
      buttons = {
        awful.button({}, 1, function()
          awesome.emit_signal("toggle::powermenu")
          awful.spawn.with_shell(cmd)
        end)
      },
      widget = wibox.container.background,
      bg = beautiful.bg,
    }
    helpers.addHover(widget, beautiful.bg, beautiful.mbg)
    return widget
  end
  powermenu:setup {
    {
      {
        button("Power Off", "poweroff", "power"),
        button("Reboot", "reboot", "reboot"),
        button("Lock", "slock", "lock"),
        button("Suspend", "systemctl suspend", "suspend"),
        button("Logout", "loginctl kill-user $USER", "logout"),
        spacing = 10,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.margin,
      margins = 8,
    },
    widget = wibox.container.background,
    bg = beautiful.bg,
    shape_border_width = 1,
    shape_border_color = beautiful.fg3,
  }

  awesome.connect_signal("toggle::powermenu", function()
    powermenu.visible = not powermenu.visible
    awful.placement.bottom_right(powermenu, { honor_workarea = true, margins = { right = 6, bottom = 6 } })
  end)
end)
