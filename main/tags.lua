local awful = require "awful"

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "1", "2", "3", " " }, s, awful.layout.layouts[1])
end)
