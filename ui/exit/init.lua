local wibox     = require("wibox")
local helpers   = require("helpers")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local gears     = require("gears")

local music     = require("ui.exit.mods.music")
local bat       = require("ui.exit.mods.bat")
local weather   = require("ui.exit.mods.weather")
local top       = require("ui.exit.mods.topbar")

awful.screen.connect_for_each_screen(function(s)
  local exit = wibox({
    screen = s,
    width = 1920,
    height = 1080,
    bg = beautiful.bg .. "00",
    ontop = true,
    visible = false,
  })


  local back = wibox.widget {
    id = "bg",
    image = beautiful.wallpaper,
    widget = wibox.widget.imagebox,
    forced_height = 1080,
    horizontal_fit_policy = "fit",
    vertical_fit_policy = "fit",
    forced_width = 1920,
  }

  local big = wibox.widget {
    {
      {
        id     = "text",
        markup = helpers.colorizeText("HELLO", beautiful.fg .. '33'),
        font   = beautiful.sans .. " Bold 250",
        align  = "center",
        widget = wibox.widget.textbox,
      },
      widget = wibox.container.background,
      halign = "center",
      valign = "center"
    },
    widget = wibox.container.margin,
    top = 0,
  }

  local overlay = wibox.widget {
    widget = wibox.container.background,
    forced_height = 1080,
    forced_width = 1920,
    bg = beautiful.bg .. "d1"
  }
  local makeImage = function()
    local cmd = 'convert ' ..
        beautiful.wallpaper .. ' -filter Gaussian -blur 0x6 ~/.cache/awesome/exit.jpg'
    awful.spawn.easy_async_with_shell(cmd, function()
      local blurwall = gears.filesystem.get_cache_dir() .. "exit.jpg"
      back.image = blurwall
    end)
  end

  makeImage()

  local createButton = function(icon, name, cmd, color)
    local widget = wibox.widget {
      {
        {
          {
            id     = "icon",
            markup = helpers.colorizeText(icon, color),
            font   = beautiful.icon .. " 40",
            align  = "center",
            widget = wibox.widget.textbox,
          },
          widget = wibox.container.margin,
          margins = 40,
        },
        shape = helpers.rrect(15),
        widget = wibox.container.background,
        bg = beautiful.bg,
        id = "bg",
        shape_border_color = color,
        shape_border_width = 2,
      },
      buttons = {
        awful.button({}, 1, function()
          awesome.emit_signal("toggle::exit")
          awful.spawn.with_shell(cmd)
        end)
      },
      spacing = 15,
      layout = wibox.layout.fixed.vertical,
    }
    widget:connect_signal("mouse::enter", function()
      helpers.gc(widget, "bg").bg = beautiful.mbg
    end)
    widget:connect_signal("mouse::leave", function()
      helpers.gc(widget, "bg").bg = beautiful.bg
    end)
    return widget
  end


  local time = wibox.widget {
    {
      {
        markup = helpers.colorizeText("󰀠", beautiful.blue),
        font   = beautiful.icon .. " 28",
        align  = "center",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      {
        font = beautiful.sans .. " 16",
        format = "%H:%M",
        align = "center",
        valign = "center",
        widget = wibox.widget.textclock
      },
      spacing = 10,
      layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.place,
    valign = "center"
  }

  local down = wibox.widget {
    {
      {
        music,
        time,
        bat,
        weather,
        layout = wibox.layout.fixed.horizontal,
        spacing = 20,
      },
      widget = wibox.container.place,
      valign = "bottom",
      halign = "center"
    },
    widget = wibox.container.margin,
    bottom = 40,
  }

  local buttons = wibox.widget {

    {
      createButton("󰐥", "Power", "poweroff", beautiful.red),
      createButton("󰦛", "Reboot", "reboot", beautiful.green),
      createButton("󰌾", "Lock", "lock", beautiful.blue),
      createButton("󰖔", "Sleep", "systemctl suspend", beautiful.yellow),
      createButton("󰈆", "Log Out", "loginctl kill-user $USER", beautiful.magenta),
      layout = wibox.layout.fixed.horizontal,
      spacing = 20,
    },
    widget = wibox.container.place,
    halign = "center",
    valign = "center"
  }

  exit:setup {
    back,

    overlay,
    top,
    buttons,
    down,
    widget = wibox.layout.stack
  }
  awful.placement.centered(exit)
  awesome.connect_signal("toggle::exit", function()
    exit.visible = not exit.visible
  end)
end)
