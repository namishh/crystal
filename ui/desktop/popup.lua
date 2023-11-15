local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local inspect = require('mods.inspect')
local helpers = require("helpers")

local popup = {}

popup.widget = wibox({
  visible = false,
  ontop = true,
  height = 180,
  width = 400,
  shape = helpers.rrect(5),
  widget = wibox.container.background
})

popup.label = "Rename A File"


popup.prompt = wibox.widget {
  {
    {
      {
        {
          markup = "",
          forced_height = 24,
          id = "txt",
          font = "Rubik 14",
          widget = wibox.widget.textbox,
        },
        {
          markup = "Type Here...",
          forced_height = 15,
          id = "placeholder",
          font = "Rubik 14",
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.stack
      },
      widget = wibox.container.margin,
      margins = 20,
    },
    widget = wibox.container.background,
    bg = beautiful.mbg
  },
  forced_width = 470,
  widget = wibox.container.margin,
}

popup.name = wibox.widget {
  markup = popup.label,
  forced_height = 15,
  id = "okay",
  font = "Rubik 14",
  widget = wibox.widget.textbox,
}

popup.widget:setup({
  {
    {
      {
        {
          {
            {
              {
                {
                  widget = wibox.container.background,
                  forced_width = 17,
                  forced_height = 17,
                  bg = beautiful.red,
                  shape = helpers.rrect(50),
                  buttons = {
                    awful.button({}, 1, function()
                      awesome.emit_signal('quit::popupgrabber')
                      awesome.emit_signal('quit::popup')
                    end)
                  },
                },
                layout = wibox.layout.fixed.horizontal
              },
              widget = wibox.container.place,
              valign = "center"
            },
            nil,
            nil,
            layout = wibox.layout.align.horizontal
          },
          widget = wibox.container.margin,
          margins = 15
        },
        widget = wibox.container.background,
        bg = beautiful.mbg
      },
      {
        {
          popup.name,
          popup.prompt,
          spacing = 20,
          layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.margin,
        margins = 20
      },
      nil,
      layout = wibox.layout.align.vertical
    },
    widget = wibox.container.place,
    valign = "center"
  },
  widget = wibox.container.background,
  bg = beautiful.bg
})

local exclude = {
  "Shift_R",
  "Shift_L",
  "Super_R",
  "Super_L",
  "Tab",
  "Alt_R",
  "Alt_L",
  "Ctrl_L",
  "Ctrl_R",
  "CapsLock",
  "Home",
  "Down",
  "Up",
  "Left",
  "Right"
}
local function has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

popup.grabber = awful.keygrabber({
  auto_start = true,
  stop_event = "release",
  keypressed_callback = function(self, mod, key, command)
    local addition = ''
    if key == "Escape" then
      awesome.emit_signal("quit::popup")
      awesome.emit_signal("quit::popupgrabber")
    elseif key == "BackSpace" then
      popup.prompt:get_children_by_id('txt')[1].markup = popup.prompt:get_children_by_id('txt')[1].markup:sub(1, -2)
    elseif key == "Return" then
      popup.func(popup.prompt:get_children_by_id('txt')[1].markup)
      awesome.emit_signal("quit::popup")
      awesome.emit_signal("quit::popupgrabber")
      awesome.emit_signal("signal::desktop")
    elseif has_value(exclude, key) then
      addition = ''
    else
      addition = key
    end
    popup.prompt:get_children_by_id('txt')[1].markup = popup.prompt:get_children_by_id('txt')[1].markup .. addition
    if string.len(popup.prompt:get_children_by_id('txt')[1].markup) > 0 then
      popup.prompt:get_children_by_id('placeholder')[1].markup = ''
    else
      popup.prompt:get_children_by_id('placeholder')[1].markup = 'Type Here...'
    end
  end,
})

popup.start = function(fn)
  if fn == "create" then
    popup.label = "Create A File"
    popup.name.markup = popup.label
    popup.func = function(name)
      awful.spawn.with_shell("touch ~/Desktop/'" .. name .. "'")
    end
  elseif fn == "folder" then
    popup.label = "Create A Folder"
    popup.name.markup = popup.label
    popup.func = function(name)
      awful.spawn.with_shell("mkdir ~/Desktop/'" .. name .. "'")
    end
  else
    awesome.emit_signal("close::filemenu")
    popup.label = "Rename File"
    popup.name.markup = popup.label
    popup.func = function(name)
      local n = helpers.split(fn, "`")[2]
      awful.spawn.with_shell("mv ~/Desktop/'" .. n .. "' ~/Desktop/'" .. name .. "'")
    end
  end
end

awesome.connect_signal("toggle::popupgrabber", function()
  popup.grabber:start()
end)

awesome.connect_signal("quit::popupgrabber", function()
  popup.grabber:stop()
  popup.prompt:get_children_by_id('txt')[1].markup = ""
end)

awesome.connect_signal("quit::popup", function()
  popup.widget.visible = false
end)

awesome.connect_signal("toggle::popup", function(fn)
  popup.start(fn)
  if popup.widget.visible then
    awesome.emit_signal("quit::popupgrabber")
  else
    awesome.emit_signal("toggle::popupgrabber")
  end
  popup.widget.visible = not popup.widget.visible
  awful.placement.centered(
    popup.widget,
    { honor_workarea = true }
  )
end)

return popup
