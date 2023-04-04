local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require("helpers")
local awful       = require("awful")
local finalWidget = wibox.widget {
  {
    {
      layout = wibox.layout.align.horizontal,
      {
        {
          font = beautiful.icofont .. " 16",
          markup = "󰍉",
          valign = "center",
          align = "center",
          widget = wibox.widget.textbox,
        },
        widget = wibox.container.margin,
        margins = { right = dpi(15) },
      },
      {
        {
          id = "input",
          font = beautiful.font .. " Light 12",
          markup = "",
          valign = "center",
          align = "start",
          widget = wibox.widget.textbox,
        },
        {
          id = "place_holder",
          font = beautiful.font .. " Light 12",
          markup = "Search",
          valign = "center",
          align = "start",
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.stack,
      },
      nil,
    },
    widget = wibox.container.margin,
    margins = 10
  },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::search')
    end),
  },
  shape   = helpers.rrect(5),
  widget  = wibox.container.background,
  bg      = beautiful.bg2 .. 'cc'
}
local exclude     = {
  "Shift_R",
  "Shift_L",
  "Tab",
  "Alt_R",
  "Alt_L",
  "Ctrl_L",
  "Ctrl_R",
  "CapsLock",
  "Home"
}
local function has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

local exit_screen_grabber = awful.keygrabber({
  auto_start = true,
  stop_event = "release",
  keypressed_callback = function(self, mod, key, command)
    local addition = ''
    if key == "Escape" or key == "Super_L" then
      awesome.emit_signal("quit::search")
    elseif key == "BackSpace" then
      finalWidget:get_children_by_id('input')[1].markup = finalWidget:get_children_by_id('input')[1].markup:sub(1, -2)
    elseif key == "Return" then
      if string.len(finalWidget:get_children_by_id('input')[1].markup) > 0 then
        awful.spawn.with_shell("bash -c 'firefox \"" ..
        "https://google.com/search?q=" .. finalWidget:get_children_by_id('input')[1].markup .. "\"'")
        finalWidget:get_children_by_id('input')[1].markup = ''
        awesome.emit_signal("toggle::dashboard")
      end
    elseif has_value(exclude, key) then
      addition = ''
    else
      addition = key
    end
    finalWidget:get_children_by_id('input')[1].markup = finalWidget:get_children_by_id('input')[1].markup .. addition
    if string.len(finalWidget:get_children_by_id('input')[1].markup) > 0 then
      finalWidget:get_children_by_id('place_holder')[1].markup = ''
    else
      finalWidget:get_children_by_id('place_holder')[1].markup = 'Search'
    end
  end,
})

awesome.connect_signal("toggle::search", function()
  exit_screen_grabber:start()
end)

awesome.connect_signal("quit::search", function()
  exit_screen_grabber:stop()
end)

return finalWidget
