local awful = require "awful"
local gears = require "gears"
local ruled = require "ruled"

ruled.client.connect_signal("request::rules", function()
  ruled.client.append_rule {
    id = "global",
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  }

  ruled.client.append_rule {
    id = "titlebars",
    rule_any = {
      type = { "normal", "dialog" },
    },
    properties = {
      titlebars_enabled = true
    }
  }
  ruled.client.append_rule {
    id = "desktop",
    rule_any = {
      class = {
        "Nemo-desktop"
      }
    },
    properties = { sticky = true, tag = " " }
  }
end)
