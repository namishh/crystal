local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local animation = require("modules.animation")

return function(s)
  local taglist = awful.widget.taglist {
    layout          = {
      spacing = 15,
      layout = wibox.layout.fixed.horizontal,
    },
    style           = {
      shape = helpers.rrect(50)
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
        markup = '',
        shape  = helpers.rrect(20),
        widget = wibox.widget.textbox,
      },
      valign          = 'center',
      id              = 'background_role',
      shape           = gears.shape.circle,
      widget          = wibox.container.background,
      forced_width    = 10,
      forced_height   = 11,
      create_callback = function(self, tag)

        self.taganim = animation:new({
          duration = 0.12,
          easing = animation.easing.linear,
          update = function(_, pos)
            self:get_children_by_id('background_role')[1].forced_width = pos
          end,
        })
        self.update = function()
          if tag.selected then
            self.taganim:set(30)
          elseif #tag:clients() > 0 then
            self.taganim:set(11)
          else
            self.taganim:set(11)
          end
        end

        self.update()
      end,
      update_callback = function(self)
        self.update()
      end,
    }
    --widget_template = {
    --   {
    --     {
    --       id     = 'text_role',
    --       widget = wibox.widget.textbox,
    --     },
    --     margins = {
    --       left = 12,
    --       right = 12
    --     },
    --     widget  = wibox.container.margin,
    --   },
    --   id     = 'background_role',
    --   widget = wibox.container.background,
    -- }
  }
  return taglist
end
