local helpers = require("helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")


local quotes = {
  {
    quote = "He that can have patience can have what he will",
    author = "Benjamin Franklin"
  },
  {
    quote = "I am never afraid of failure; for I would sooner fail than not be among the greatest",
    author = "John Keats"
  },
  {
    quote = "Tomorrow we will run faster, stretch out our arms farther",
    author = " F. Scott Fitzgerald "
  },
  {
    quote = "All we have to decide is what to do with the time that is given us. ",
    author = "J. R. R. Tolkein"
  }
}

local finalwidget = wibox.widget {
  {
    {
      {
        {
          {
            id = "quote",
            font = beautiful.font .. " 14",
            markup = "",
            valign = "center",
            align = "start",
            widget = wibox.widget.textbox,
          },
          {
            {
              id = "author",
              font = beautiful.font .. " 12",
              markup = "",
              valign = "center",
              halign = "end",
              widget = wibox.widget.textbox,
            },
            widget = wibox.container.place,
            halign = 'end'
          },
          spacing = 15,
          layout = wibox.layout.fixed.vertical
        },
        widget = wibox.container.place,
        valign = 'center'
      },
      widget = wibox.container.margin,
      margins = 20,
    },
    {
      font = beautiful.sans .. " 150",
      markup = helpers.colorizeText('"', beautiful.pri .. '22'),
      valign = "center",
      align = "start",
      widget = wibox.widget.textbox,
    },
    forced_width = 640,
    layout = wibox.layout.stack
  },
  forced_width = 640,
  widget = wibox.container.background,
  bg = beautiful.mbg,
  shape = helpers.rrect(8),
}

local update = function()
  local random = quotes[math.random(#quotes)]
  finalwidget:get_children_by_id('quote')[1].markup = random.quote
  finalwidget:get_children_by_id('author')[1].markup = helpers.colorizeText('- ' .. random.author, beautiful.pri)
end

update()

return finalwidget
