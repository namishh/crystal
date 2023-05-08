local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")
local animation = require("modules.animation")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local currentTheme = beautiful.name
local DIR = gears.filesystem.get_configuration_dir() .. "theme/wallpapers/" .. currentTheme .. "/"
local curr = beautiful.wall
local elems = wibox.widget {
  {
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = 20,
      id = "switcher"
    },
    widget = wibox.container.margin,
    bottom = 20,
  },
  layout = require("modules.overflow").horizontal
}

awful.screen.connect_for_each_screen(function(s)
  local wallswitcher = wibox {
    width = dpi(800),
    height = dpi(250),
    shape = helpers.rrect(8),
    bg = beautiful.bg,
    ontop = true,
    visible = false
  }

  wallswitcher:setup {
    {
      widget = wibox.container.margin,
      margins = 20,
      elems,
    },
    layout = wibox.layout.fixed.vertical
  }

  local slide = animation:new({
    duration = 0.6,
    pos = 0 - wallswitcher.height,
    easing = animation.easing.inOutExpo,
    update = function(_, pos)
      wallswitcher.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43,
    callback = function()
      wallswitcher.visible = false
    end,
  })

  local close = function()
    slide_end:again()
    slide:set(0 - wallswitcher.height)
  end
  local function refresh()
    elems:reset()
    for path in io.popen("cd " .. DIR .. " && find . -maxdepth 1 | tail -n +2"):lines() do
      path = string.sub(path, 3)
      if not os.execute("cd '" .. DIR .. path .. "'") then
        local widget = wibox.widget {
          {
            widget = wibox.widget.imagebox,
            image = DIR .. path,
            forced_height = 197,
            resize = true,
          },
          widget = wibox.container.background,
          border_width = curr == DIR .. path and dpi(3) or dpi(0),
          forced_height = curr == DIR .. path and dpi(180) or dpi(197),
          shape = helpers.rrect(9),
          border_color = curr == DIR .. path and beautiful.pri or beautiful.bg,
          buttons = {
            awful.button({}, 1, function()
              beautiful.wall = DIR .. path
              curr = DIR .. path
              gears.wallpaper.maximized(DIR .. path, s, beautiful.mbg)
              awful.spawn.with_shell('setWall ' .. path .. " " .. beautiful.name)
              refresh()
            end)
          },
        }
        elems:add(widget)
      end
    end
  end


  awesome.connect_signal("toggle::wallswitcher", function()
    if wallswitcher.visible then
      close()
    elseif not wallswitcher.visible then
      slide:set(beautiful.barSize + beautiful.useless_gap * 2)
      wallswitcher.visible = true
      refresh()
    end
    awful.placement.centered(wallswitcher)
  end)
end)
