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
local currPath
local elems = wibox.widget {
  {
    layout = wibox.layout.fixed.vertical,
    spacing = 20,
    id = "switcher"
  },
    forced_height = 200,
  layout = require("modules.overflow").vertical
}

local setWall = function(path) 
                gears.wallpaper.maximized(curr, s, beautiful.mbg)
                awful.spawn.with_shell('setWall ' .. path .. " " .. beautiful.name)
end

local imageWidget = wibox.widget {
        image = helpers.cropSurface(2, gears.surface.load_uncached(curr)),
        forced_width = 690,
  horizontal_fit_policy = "fit",
  vertical_fit_policy = "fit",
        widget = wibox.widget.imagebox,
}

awful.screen.connect_for_each_screen(function(s)
  local wallswitcher = wibox {
    width = dpi(650),
    height = dpi(550),
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
    {
      imageWidget,
      {
        {
          widget = wibox.widget.textbox,
        },
        bg = {
          type = "linear",
          from = { 0, 0 },
          to = { 250, 0 },
          stops = { { 0, beautiful.bg .. "99" }, { 1, beautiful.bg .. "cc" } }
        },
        widget = wibox.container.background,
      },
      {
        {
              markup = "Set As Wall",
              font   = beautiful.font .. " 12",
              valign = "bottom",
              halign = 'right',
              widget = wibox.widget.textbox
            },
            widget = wibox.container.margin,
            margins = 12,
            buttons = {
              awful.button({}, 1, function()
                setWall(currPath)
              end)
            },
      },
      layout = wibox.layout.stack
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
        if curr == DIR..path then
          currPath = path
        end
        local widget = wibox.widget {
          {
            markup = curr == DIR .. path and helpers.colorizeText(path, beautiful.pri) or path,
            font   = beautiful.font .. " 12",
            align  = "left",
            valign = "center",
            widget = wibox.widget.textbox,
            buttons = {
              awful.button({}, 1, function()
                curr = DIR .. path
                currPath = path
                imageWidget.image = curr
                refresh()
              end)
            },
          },
          widget = wibox.container.margin,
          bottom = 10
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
    awful.placement.top(wallswitcher)
  end)
end)
