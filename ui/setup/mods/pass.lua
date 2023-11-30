local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local json = require("mods.json")
local beautiful = require("beautiful")

local O = function(label, var)
  local M = { label = label, hidden = true, value = var, def = var }

  M.textbox = wibox.widget {
    font = beautiful.sans .. " 12",
    markup = helpers.colorizeText(M.hidden and string.rep("*", #M.value) or M.value, beautiful.fg),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "start"
  }

  function M:getInput()
    awful.prompt.run({
      textbox      = M.textbox,
      text         = M.value,
      bg_cursor    = beautiful.fg .. '22',
      exe_callback = function(input)
        -- If no input is present, display old contents.
        if not input or #input == 0 then
          M.textbox.markup = helpers.colorizeText(M.def, beautiful.fg)
          M.textbox.font = beautiful.sans .. " 12"
          return
        end
        -- else update textbox and variable.
        M.value = input
        if self.hidden then
          M.textbox.markup = helpers.colorizeText(string.rep("*", #M.value), beautiful.fg)
        else
          M.textbox.markup = helpers.colorizeText(input, beautiful.fg)
        end
      end
    })
  end

  M.widget = wibox.widget {
    {
      font = beautiful.sans .. " Light 11",
      markup = helpers.colorizeText(M.label, beautiful.fg),
      widget = wibox.widget.textbox,
      valign = "start",
      align = "start"
    },
    {
      nil,
      {
        {
          M.textbox,
          widget = wibox.container.margin,
          top = 15,
          bottom = 15,
          left = 10,
          right = 10,
        },
        shape = helpers.rrect(10),
        widget = wibox.container.background,
        bg = beautiful.mbg,
        buttons = {
          awful.button(nil, 1, function()
            M:getInput()
          end)
        }
      },
      {
        {
          {
            {
              font = beautiful.icon .. " 14",
              markup = helpers.colorizeText("󰈈", beautiful.fg),
              widget = wibox.widget.textbox,
              valign = "center",
              align = "start"
            },
            left = 15,
            right = 15,
            widget = wibox.container.margin,
          },
          shape = helpers.rrect(10),
          widget = wibox.container.background,
          buttons = {
            awful.button(nil, 1, function()
              M.hidden = not M.hidden
              if M.hidden then
                M.textbox.markup = helpers.colorizeText(string.rep("*", #M.value), beautiful.fg)
              else
                M.textbox.markup = helpers.colorizeText(M.value, beautiful.fg)
              end
            end)
          },
          bg = beautiful.mbg,
        },
        left = 10,
        widget = wibox.container.margin,
      },
      layout = wibox.layout.align.horizontal,
    },
    spacing = 2,
    layout = wibox.layout.fixed.vertical
  }

  return M
end

return O
