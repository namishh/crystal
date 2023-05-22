local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local animation = require("modules.animation")
local dpi = beautiful.xresources.apply_dpi




local getName = function()
  local string = "~/Videos/Recordings/" .. os.date("%d-%m-%Y-%H:%M:%S") .. ".mp4"
  string = string:gsub("~", os.getenv("HOME"))
  return string
end

local start = function(fps, file_name)
  local display = os.getenv("DISPLAY")
  local defCommand = string.format(
    'ffmpeg -y -f x11grab ' ..
    '-r "%s" -i %s -f pulse -i 0 -c:v libx264 -qp 0 -profile:v main ' ..
    '-preset ultrafast -tune zerolatency -crf 28 -pix_fmt yuv420p ' ..
    ' -c:a aac -b:a 64k -b:v 500k %s',
    fps,
    display,
    file_name
  )
  print(defCommand)
  awful.spawn.with_shell(defCommand)
end
local createButton = function(icon, name, fn, col)
  return wibox.widget {
    {
      {
        {
          {
            font = beautiful.icofont .. " 38",
            markup = icon,
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
          },
          {
            font = beautiful.font .. " Light 12",
            markup = name,
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.vertical,
          spacing = 12
        },
        widget = wibox.container.margin,
        margins = 8
      },
      forced_width = 120,
      bg = beautiful.mbg,
      widget = wibox.container.background,
    },
    {
      forced_height = 3,
      forced_width = 120,
      bg = col,
      widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.vertical,
    buttons = awful.button({}, 1, function()
      fn()
    end),
  }
end


awful.screen.connect_for_each_screen(function(s)
  local recorder = wibox {
    width = dpi(270),
    height = dpi(180),
    shape = helpers.rrect(8),
    bg = beautiful.bg,
    ontop = true,
    visible = false
  }
  local slide = animation:new({
    duration = 0.6,
    pos = 0 - recorder.height,
    easing = animation.easing.inOutExpo,
    update = function(_, pos)
      recorder.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43,
    callback = function()
      recorder.visible = false
    end,
  })

  local close = function()
    slide_end:again()
    slide:set(0 - recorder.height)
  end

  local fullscreen = createButton('󰄄', 'Start', function()
    close()
    local name = getName()
    start('60', name)
  end, beautiful.ok)


  local window = createButton('󰜺', 'Finish', function()
    close()
    awful.spawn.with_shell("killall ffmpeg")
  end, beautiful.err)

  recorder:setup {
    {
      {
        {
          {
            {
              font = beautiful.font .. " Light 12",
              markup = "Video Recorder",
              valign = "center",
              align = "start",
              widget = wibox.widget.textbox,
            },
            widget = wibox.layout.align.horizontal
          },
          widget = wibox.container.margin,
          margins = 10
        },
        widget = wibox.container.background,
        bg = beautiful.mbg
      },
      {
        fullscreen,
        window,
        spacing = 15,
        layout = wibox.layout.fixed.horizontal
      },
      spacing = 10,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = 13,
  }

  awesome.connect_signal("toggle::recorder", function()
    if recorder.visible then
      slide_end:again()
      slide:set(0 - recorder.height)
    elseif not recorder.visible then
      slide:set(beautiful.scrheight / 2 - recorder.height / 2)
      recorder.visible = true
    end
    awful.placement.centered(recorder)
  end)
end)
