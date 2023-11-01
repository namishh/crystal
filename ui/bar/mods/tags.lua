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
      shape = helpers.rrect(9)
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
          markup = '',
          shape  = helpers.rrect(3),
          widget = wibox.widget.textbox,
        },
        valign        = 'center',
        id            = 'background_role',
        shape         = helpers.rrect(1),
        widget        = wibox.container.background,
        forced_width  = 40,
        forced_height = 14,
      },
      widget = wibox.container.place,
      create_callback = function(self, tag)
        self.taganim = animation:new({
          duration = 0.25,
          easing = animation.easing.linear,
          update = function(_, pos)
            self:get_children_by_id('background_role')[1].forced_width = pos
          end,
        })
        self.update = function()
          if tag.selected then
            self.taganim:set(60)
          elseif #tag:clients() > 0 then
            self.taganim:set(40)
          else
            self.taganim:set(20)
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
