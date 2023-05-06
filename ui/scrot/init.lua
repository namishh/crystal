local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local lgi = require('lgi')
local Gtk = lgi.require('Gtk', '3.0')
local Gdk = lgi.require('Gdk', '3.0')
local GdkPixbuf = lgi.GdkPixbuf
local animation = require("modules.animation")
local dpi = beautiful.xresources.apply_dpi

local useMouse = true
local mouseString = useMouse and " -u " or ""
local delay = tostring(1) .. " "

local clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD)


local getName = function()
  local string = "~/Pictures/Screenshots/" .. os.date("%d-%m-%Y-%H:%M:%S") .. ".png"
  string = string:gsub("~", os.getenv("HOME"))
  return string
end

local defCommand = "maim --capturebackground -d " .. delay .. mouseString .. " "

local copyScrot = function(path)
  local image = GdkPixbuf.Pixbuf.new_from_file(path)
  clipboard:set_image(image)
  clipboard:store()
end

local createButton = function(icon, name, fn)
  return wibox.widget {
    {
      {
        {
          font = beautiful.icofont .. " 40",
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
        spacing = 8
      },
      widget = wibox.container.margin,
      margins = 8
    },
    forced_width = 120,
    widget = wibox.container.background,
    buttons = awful.button({}, 1, function()
      fn()
    end),
    bg = beautiful.mbg
  }
end


awful.screen.connect_for_each_screen(function(s)
  local scrotter = wibox {
    width = dpi(410),
    height = dpi(180),
    shape = helpers.rrect(8),
    bg = beautiful.bg,
    ontop = true,
    visible = false
  }
  local slide = animation:new({
    duration = 0.6,
    pos = 0 - scrotter.height,
    easing = animation.easing.inOutExpo,
    update = function(_, pos)
      scrotter.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43,
    callback = function()
      scrotter.visible = false
    end,
  })

  local close = function()
    slide_end:again()
    slide:set(0 - scrotter.height)
  end

  local fullscreen = createButton('', 'Fullscreen', function()
    close()
    local name = getName()
    local cmd = defCommand .. name
    awful.spawn.easy_async_with_shell(cmd, function()
      copyScrot(name)
    end)
  end)

  local selection = createButton('', 'Selection', function()
    close()
    local name = getName()
    local cmd = defCommand .. " --select --highlight --color=0.85,0.87,0.91,0.2 " .. name
    awful.spawn.easy_async_with_shell(cmd, function()
      copyScrot(name)
    end)
  end)

  local window = createButton('', 'Window', function()
    close()
    local name = getName()
    local cmd = defCommand .. " --window " .. client.focus.window .. " " .. name
    awful.spawn.with_shell(cmd)
    awful.spawn.easy_async_with_shell(cmd, function()
      copyScrot(name)
    end)
  end)

  scrotter:setup {
    {
      {
        {
          {
            {
              font = beautiful.font .. " Light 12",
              markup = "Screenshotter",
              valign = "center",
              align = "start",
              widget = wibox.widget.textbox,
            },
            nil,
            {
              id = '123',
              font = beautiful.icofont .. " 16",
              markup = useMouse and helpers.colorizeText("󰇀", beautiful.pri) or
                  helpers.colorizeText("󰇀", beautiful.fg),
              valign = "center",
              align = "start",
              widget = wibox.widget.textbox,
              buttons = awful.button({}, 1, function()
                useMouse = not useMouse
                scrotter:get_children_by_id('123')[1].markup = useMouse and helpers.colorizeText("󰇀", beautiful.pri) or
                    helpers.colorizeText("󰇀", beautiful.fg)
              end),
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
        selection,
        window,
        spacing = 15,
        layout = wibox.layout.fixed.horizontal
      },
      spacing = 10,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = 10,
  }

  awesome.connect_signal("toggle::scrotter", function()
    if scrotter.visible then
      slide_end:again()
      slide:set(0 - scrotter.height)
    elseif not scrotter.visible then
      slide:set(beautiful.scrheight / 2 - scrotter.height / 2)
      scrotter.visible = true
    end
    awful.placement.centered(scrotter)
  end)
end)
