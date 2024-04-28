local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require("beautiful")
local helpers   = require("helpers")

local module    = require(... .. '.module')

return function(s)
  s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

  -- Create the wibox
  s.mywibox = awful.wibar({
    position = 'top',
    height   = 70,
    ontop    = false,
    width    = 1920,
    shape    = helpers.rrect(5),
    bg       = beautiful.bg .. "00",
    screen   = s,
    widget   = {
      {
        {
          {
            {
              {
                module.session,
                {
                  widget = wibox.container.background,
                  bg = beautiful.bg3,
                  forced_height = 1,
                },
                spacing = 8,
                module.taglist(s),
                {
                  {
                    widget = wibox.container.background,
                    bg = beautiful.bg3,
                    forced_width = 1,
                  },
                  widget = wibox.container.margin,
                  left = 40,
                },
                module.systray,
                {
                  {
                    {
                      module.battery,
                      module.wifi,
                      layout = wibox.layout.fixed.horizontal,
                      spacing = 8
                    },
                    widget = wibox.container.margin,
                    left = 10,
                    right = 10,
                  },
                  widget = wibox.container.background,
                  shape = helpers.rrect(5),
                  bg = beautiful.blue .. '11',
                  buttons = {
                    awful.button({}, 1, function()
                      awesome.emit_signal("toggle::settings")
                    end)
                  },
                },
                module.time,
                layout = wibox.layout.fixed.horizontal,
              },
              widget = wibox.container.place,
              halign = "center",
              valign = "center",
            },
            widget = wibox.container.margin,
            left = 9,
            top = 9,
            bottom = 9,
            right = 9
          },
          widget = wibox.container.background,
          bg = beautiful.bg,
          shape = helpers.rrect(5),
        },
        nil,
        nil,
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin,
      top = 14,
      right = 14,
      left = 14,
    }
  })
end
