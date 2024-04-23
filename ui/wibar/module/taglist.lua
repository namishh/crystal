local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local animation = require("mods.animation")
local beautiful = require("beautiful")
return function(s)
  local taglist = awful.widget.taglist {
    layout          = {
      spacing = 8,
      layout = wibox.layout.fixed.horizontal,
    },
    style           = {
      shape = helpers.rrect(4)
    },
    screen          = s,
    filter          = awful.widget.taglist.filter.all,
    buttons         = {
      awful.button({}, 1, function(t) t:view_only() end),
      awful.button({}, 4, function(t)
        awful.tag.viewprev(t.screen)
      end),
      awful.button({}, 5, function(t)
        awful.tag.viewnext(t.screen)
      end)
    },
    widget_template = {
      {
        {
          {
            {
              markup = '',
              shape  = helpers.rrect(0),
              id     = 'text_role',
              widget = wibox.widget.textbox,
            },
            widget = wibox.container.margin,
            left = 10,
            right = 10,
          },
          valign        = 'center',
          id            = 'background_role',
          shape         = helpers.rrect(0),
          widget        = wibox.container.background,
          forced_height = 30,
        },
        widget = wibox.container.place,
        valign = "center",
      },
      widget = wibox.container.place,
      create_callback = function(self, tag)
        self.taganim = animation:new({
          duration = 0.1,
          easing = animation.easing.linear,
          update = function(_, pos)
          end,
        })
        self.update = function()
          if tag.selected then
          elseif #tag:clients() > 0 then
          else
          end
        end

        self.update()
      end,
      update_callback = function(self)
        self.update()
      end,
    }
  }
  return taglist
end
