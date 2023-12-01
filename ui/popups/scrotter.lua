local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local lgi = require('lgi')
local Gtk = lgi.require('Gtk', '3.0')
local Gdk = lgi.require('Gdk', '3.0')
local GdkPixbuf = lgi.GdkPixbuf
local dpi = beautiful.xresources.apply_dpi

local delay = tostring(1) .. " "

local clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD)


local getName = function()
  local string = "~/Pictures/Screenshots/" .. os.date("%d-%m-%Y-%H:%M:%S") .. ".jpg"
  string = string:gsub("~", os.getenv("HOME"))
  return string
end

local defCommand = "maim " .. "-d " .. delay

local copyScrot = function(path)
  local image = GdkPixbuf.Pixbuf.new_from_file(path)
  clipboard:set_image(image)
  clipboard:store()
end

local createButton = function(icon, name, fn, col)
  return wibox.widget {
    {
      {
        {
          {
            font = beautiful.icon .. " 38",
            markup = helpers.colorizeText(icon, col),
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
          },
          widget = wibox.container.margin,
          margins = 23,
        },
        shape = helpers.rrect(10),
        widget = wibox.container.background,
        bg = beautiful.mbg,
      },
      {
        font = beautiful.sans .. " 10",
        markup = name,
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox,
      },
      spacing = 10,
      layout = wibox.layout.fixed.vertical,
    },
    layout = wibox.layout.fixed.vertical,
    buttons = awful.button({}, 1, function()
      fn()
    end),
  }
end


awful.screen.connect_for_each_screen(function(s)
  local scrotter = wibox {
    width = dpi(410),
    height = dpi(210),
    shape = helpers.rrect(8),
    bg = beautiful.bg,
    ontop = true,
    visible = false
  }

  local close = function()
    scrotter.visible = not scrotter.visible
  end

  local fullscreen = createButton('󰍹', 'Fullscreen', function()
    close()
    local name = getName()
    local cmd = defCommand .. name
    awful.spawn.easy_async_with_shell(cmd, function()
      copyScrot(name)
    end)
  end, beautiful.green)

  local selection = createButton('󰩭', 'Selection', function()
    close()
    local name = getName()
    local cmd = "maim" .. " -s " .. name
    awful.spawn.easy_async_with_shell(cmd, function()
      copyScrot(name)
    end)
  end, beautiful.blue)

  local window = createButton('󰘔', 'Window', function()
    close()
    local name = getName()
    local cmd = "maim" .. " -i " .. client.focus.window .. " " .. name
    awful.spawn.with_shell(cmd)
    awful.spawn.easy_async_with_shell(cmd, function()
      copyScrot(name)
    end)
  end, beautiful.red)

  scrotter:setup {
    {
      {
        {
          {
            {
              font = beautiful.font .. " 14",
              markup = "Screenshotter",
              valign = "center",
              align = "start",
              widget = wibox.widget.textbox,
            },
            nil,
            {
              font = beautiful.icon .. " 18",
              markup = helpers.colorizeText("󰅖", beautiful.red),
              valign = "center",
              align = "start",
              widget = wibox.widget.textbox,
              buttons = {
                awful.button({}, 1, function()
                  close()
                end)
              },
            },
            widget = wibox.layout.align.horizontal
          },
          widget = wibox.container.margin,
          margins = 10
        },
        widget = wibox.container.background,
      },
      {
        {
          fullscreen,
          selection,
          window,
          spacing = 25,
          layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.place,
        halign = "center"
      },
      spacing = 10,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = 10,
  }

  awesome.connect_signal("toggle::scrotter", function()
    scrotter.visible = not scrotter.visible
    awful.placement.centered(scrotter)
  end)
end)
