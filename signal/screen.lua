local awful     = require('awful')
local gears     = require('gears')
local beautiful = require('beautiful')
local wibox     = require('wibox')

local widgets   = require('ui')

--- Attach tags and widgets to all screens.
screen.connect_signal('request::desktop_decoration', function(s)
  -- Create all tags and attach the layouts to each of them.
  awful.tag(require('config.user').tags, s, awful.layout.layouts[1])
  -- Attach a wibar to each screen.
  widgets.wibar(s)
end)


local corners = function(r)
  return function(cr)
    gears.shape.partially_rounded_rect(cr, 1920, 1080, true, false, true, true, r)
  end
end


screen.connect_signal("request::wallpaper", function(s)
  local geo = s.geometry

  awful.wallpaper {
    screen = s,
    widget = {
      {
        image                 = gears.surface.crop_surface {
          ratio   = geo.width / geo.height,
          surface = gears.surface.load_uncached(beautiful.wallpaper)
        },
        horizontal_fit_policy = "fit",
        vertical_fit_policy   = "fit",
        --clip_shape            = corners(15),
        widget                = wibox.widget.imagebox
      },
      widget = wibox.container.background,
      bg = beautiful.bg,
    }
  }
end)
