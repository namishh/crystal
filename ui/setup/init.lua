local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local json = require("mods.json")
local beautiful = require("beautiful")

local inspect = require("mods.inspect")
local input = require("ui.setup.mods.input")
local pass = require("ui.setup.mods.pass")
local check = require("ui.setup.mods.check")
local intin = require("ui.setup.mods.intin")
local themer = require("ui.setup.mods.themer")

local data = helpers.readJson(gears.filesystem.get_cache_dir() .. "json/settings.json")
local a1 = input("Profile Picture", true, data.pfp)
local a2 = input("Icon Theme Path", true, data.iconTheme)
local a3 = pass("OpenWeather API Key", data.openWeatherApi)

local a4 = check("Image Wallpaper", "colorful", "plain", data.wallpaper)
local a5 = check("Desktop Icons", true, false, data.showDesktopIcons)
local a6 = intin("Gaps", tostring(data.gaps))

local function writeData()
  local data = {
    pfp = a1.value,
    iconTheme = a2.value,
    openWeatherApi = a3.value,
    wallpaper = a4.value,
    showDesktopIcons = a5.value,
    gaps = tonumber(a6.value),
    colorscheme = themer.current
  }
  local w = assert(io.open(gears.filesystem.get_cache_dir() .. "json/settings.json", "w"))
  w:write(json.encode(data, nil, { pretty = true, indent = "	", align_keys = false, array_newline = true }))
  w:close()
  awesome.restart()
end

awful.screen.connect_for_each_screen(function(s)
  local setup = wibox({
    shape = helpers.rrect(12),
    screen = s,
    width = 560,
    height = 670,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })

  awful.placement.centered(setup, { honor_workarea = true })
  awesome.connect_signal("toggle::setup", function()
    setup.visible = not setup.visible
  end)

  setup:setup {
    {
      {
        {
          font = beautiful.sans .. " 14",
          markup = helpers.colorizeText("Configure", beautiful.fg),
          widget = wibox.widget.textbox,
          valign = "center",
          align = "center"
        },
        nil,
        {
          {
            {
              {
                font = beautiful.sans .. " 10",
                markup = helpers.colorizeText("Apply In Nix", beautiful.blue),
                widget = wibox.widget.textbox,
                valign = "center",
                align = "center"
              },
              widget = wibox.container.margin,
              margins = 10
            },
            widget = wibox.container.background,
            shape = helpers.rrect(6),
            buttons = {
              awful.button({}, 1, function()
                awful.spawn.with_shell("setTheme " .. themer.current)
                awesome.emit_signal('toggle::setup')
              end)
            },
            bg = beautiful.blue .. '11'
          },
          {
            {
              {
                font = beautiful.icon .. " 12",
                markup = helpers.colorizeText("󰄬", beautiful.green),
                widget = wibox.widget.textbox,
                valign = "center",
                align = "center"
              },
              widget = wibox.container.margin,
              margins = 10
            },
            widget = wibox.container.background,
            shape = helpers.rrect(6),
            buttons = {
              awful.button({}, 1, function()
                writeData()
                awesome.emit_signal('toggle::setup')
              end)
            },
            bg = beautiful.green .. '11'
          },
          {
            {
              {
                font = beautiful.icon .. " 12",
                markup = helpers.colorizeText("󰅖", beautiful.red),
                widget = wibox.widget.textbox,
                valign = "center",
                align = "center"
              },
              widget = wibox.container.margin,
              margins = 10
            },
            widget = wibox.container.background,
            shape = helpers.rrect(6),
            buttons = {
              awful.button({}, 1, function()
                awesome.emit_signal('toggle::setup')
              end)
            },
            bg = beautiful.red .. '11'
          },
          spacing = 20,
          layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
      },
      a1.widget,
      a2.widget,
      a3.widget,
      {
        a4.widget,
        a5.widget,
        a6.widget,
        layout = wibox.layout.flex.horizontal
      },
      themer.widget,
      spacing = 25,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
    margins = 20,
  }
end)
