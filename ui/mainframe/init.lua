local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local animation = require("modules.animation")
local profile = require("ui.mainframe.modules.profile")
local search = require("ui.mainframe.modules.search")
local music = require("ui.mainframe.modules.music")
local taw = require("ui.mainframe.modules.taw")
local notifbox = require("ui.mainframe.modules.notifs.box")

local timer = require("ui.mainframe.modules.timer")
local todo = require("ui.mainframe.modules.todo")
local quik = require("ui.mainframe.modules.quiklinks")
local quikl = require("ui.mainframe.modules.quiklocations")
local quote = require("ui.mainframe.modules.quote")

awful.screen.connect_for_each_screen(function(s)
  local mainframe = wibox({
    screen = s,
    width = 960,
    shape = helpers.rrect(8),
    height = 775,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })
  local main = wibox.widget {
    {
      taw,
      profile,
      music,
      spacing = 20,
      layout = wibox.layout.fixed.vertical,
    },
    notifbox,
    spacing = 20,
    visible = true,
    layout = wibox.layout.fixed.horizontal,
  }
  local set = wibox.widget {
    {
      timer,
      todo,
      quik,
      spacing = 20,
      layout = wibox.layout.fixed.horizontal,
    },
    {
      quikl,
      quote,
      spacing = 20,
      layout = wibox.layout.fixed.horizontal,
    },
    spacing = 20,
    visible = false,
    layout = wibox.layout.fixed.vertical,
  }
  local but = wibox.widget {
    {
      {
        {
          {
            id = "mainText",
            font = beautiful.font .. " 14",
            markup = "Dashboard",
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
          },
          widget = wibox.container.margin,
          margins = {
            top = 8,
            left = 10,
            right = 10,
            bottom = 8
          }
        },
        id = "mainBack",
        bg = beautiful.mbg,
        widget = wibox.container.background,
        buttons = {
          awful.button({}, 1, function()
            awesome.emit_signal('toggle::dashboardMain')
          end)
        },
      },
      {
        {
          {
            id = "settingsText",
            font = beautiful.font .. " 14",
            markup = "Get Work Done",
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
          },
          widget = wibox.container.margin,
          margins = {
            top = 8,
            left = 10,
            right = 10,
            bottom = 8
          }
        },
        id = "settingsBack",
        widget = wibox.container.background,
        buttons = {
          awful.button({}, 1, function()
            awesome.emit_signal('toggle::dashboardSet')
          end)
        },
      },
      layout = wibox.layout.fixed.horizontal,
      spacing = 20
    },
    widget = wibox.container.place,
    halign = 'center',
  }
  mainframe:setup {
    {
      {
        nil,
        search,
        {
          but,
          widget = wibox.container.margin,
          margins = { left = 20, }
        },
        layout = wibox.layout.align.horizontal
      },
      {
        main,
        set,
        layout = wibox.layout.stack
      },
      layout = wibox.layout.fixed.vertical,
      spacing = 20,
    },
    margins = dpi(25),
    widget = wibox.container.margin,
  }

  helpers.placeWidget(mainframe)
  local slide = animation:new({
    duration = 0.6,
    pos = 0 - mainframe.height,
    easing = animation.easing.inOutExpo,
    update = function(_, pos)
      mainframe.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43 + 0.08,
    callback = function()
      mainframe.visible = false
    end,
  })
  awesome.connect_signal("toggle::dashboardMain", function()
    main.visible = true
    but:get_children_by_id('mainBack')[1].bg = beautiful.mbg
    but:get_children_by_id('settingsBack')[1].bg = beautiful.bg
    set.visible = false
  end)
  awesome.connect_signal("toggle::dashboardSet", function()
    main.visible = false
    but:get_children_by_id('settingsBack')[1].bg = beautiful.mbg
    but:get_children_by_id('mainBack')[1].bg = beautiful.bg
    set.visible = true
  end)
  awesome.connect_signal("toggle::dashboard", function()
    local pad = 0
    if beautiful.barShouldHaveGaps then
      pad = beautiful.barPadding
    end
    if mainframe.visible then
      slide_end:again()
      slide:set(0 - mainframe.height)
    elseif not mainframe.visible then
      slide:set(beautiful.barSize + beautiful.useless_gap + math.ceil(pad / 2))
      mainframe.visible = true
    end
  end)
end)
