local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require("beautiful")
local helpers   = require("helpers")

local module    = require(... .. '.module')

return function(s)
  s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

  -- Create the wibox
  s.mywibox = awful.wibar({
    position = 'bottom',
    height   = 60,
    ontop    = false,
    width    = 1920,

    screen   = s,
    widget   = {
      {
        widget = wibox.container.background,
        bg = beautiful.fg3,
        forced_width = 1920,
        forced_height = 1,
      },
      {
        -- Left widgets.
        {
          {
            {
              layout = wibox.layout.fixed.horizontal,
              module.launcher(),
              {
                {

                  module.taglist(s),
                  widget = wibox.container.margin,
                  left = 6,
                  right = 6,
                },

                widget = wibox.container.background,
                bg = beautiful.mbg,
                shape_border_width = 1,
                shape_border_color = beautiful.fg3,
                shape = helpers.rrect(5),
              },
              spacing = 8
            },
            widget = wibox.container.place,
            valign = "center",
            halign = "center",
          },
          widget = wibox.container.margin,
          margins = 8,
          top = 9
        },
        {
          {
            widget = wibox.container.background,
            bg = beautiful.fg3,
            forced_width = 1,
          },
          {
            module.tasklist(s),
            widget = wibox.container.margin,
            top = 9,
            bottom = 8
          },
          spacing = 8,
          layout = wibox.layout.fixed.horizontal,
        },
        -- Right widgets.
        {
          {
            widget = wibox.container.background,
            bg = beautiful.fg3,
            forced_width = 1,
          },
          {
            {
              {
                module.systray,

                {
                  {
                    {
                      module.battery,
                      module.wifi,
                      module.bluetooth,
                      layout = wibox.layout.fixed.horizontal,
                      spacing = 10,
                    },
                    widget = wibox.container.margin,
                    top = 3,
                    bottom = 3,
                    left = 10,
                    right = 10
                  },
                  widget = wibox.container.background,
                  bg = beautiful.mbg,
                  shape_border_width = 1,
                  buttons = {
                    awful.button({}, 1, function()
                      awesome.emit_signal('toggle::settings')
                    end)
                  },
                  shape_border_color = beautiful.fg3,
                  shape = helpers.rrect(5),
                },
                module.time,
                module.layoutbox(s),
                module.session,
                layout = wibox.layout.fixed.horizontal,
                spacing = 8,
              },
              widget = wibox.container.place,
              valign = "center",
              halign = "center",
            },
            widget = wibox.container.margin,
            left = 8,
            right = 8,
            bottom = 8,
            top = 10
          },
          layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal,
      },
      layout = wibox.layout.fixed.vertical,
    }
  })
end
