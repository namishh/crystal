local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local timer = { defaultTime = 25 * 60 }


function timer:stop()
  self.clock:stop()
end

function timer:pause()
  self.paused = true
  self.pausedTime = os.time()
end

function timer:resume()
  self.paused = false
  self.clock:again()
  if self.pausedTime then
    self.pausedTime = nil
  end
end

function timer:new()
  self.timeRemaining = self.defaultTime
  self.paused = true
  self.pausedTime = nil

  self.widget = wibox.widget {
    {
      {
        {
          {
            {
              id = "timer",
              font = beautiful.font .. " Bold 48",
              markup = "00:00",
              valign = "center",
              align = "start",
              widget = wibox.widget.textbox,
            },
            widget = wibox.container.place,
            halign = 'center'
          },
          id = "prog",
          start_angle = 1.57,
          widget = wibox.container.arcchart,
          thickness = 10,
          forced_height = 300,
          forced_width = 300,
          min_value = 0,
          max_value = 100,
          value = 50,
          bg = beautiful.ok .. '22',
          colors = { beautiful.ok }
        },
        {
          {
            {
              {
                {
                  id = "reset",
                  font = beautiful.icofont .. " 20",
                  markup = helpers.colorizeText("󰍴", beautiful.fg),
                  valign = "center",
                  align = "start",
                  widget = wibox.widget.textbox,
                },
                widget = wibox.container.margin,
                margins = 12,
              },
              widget = wibox.container.background,
              shape = helpers.rrect(50),
              buttons = {
                awful.button({}, 1, function()
                  if self.defaultTime > 5 * 60 then
                    self.paused = true
                    self.defaultTime = self.defaultTime - 5 * 60
                    self.timeRemaining = self.defaultTime
                    self.timeRemaining = self.defaultTime
                    self.pausedTime = self.defaultTime
                    self.clock:stop()
                    self:update()
                  end
                end)
              },
            },
            {
              {
                {
                  id = "resume",
                  font = beautiful.icofont .. " 20",
                  markup = helpers.colorizeText("󰐎", beautiful.fg),
                  valign = "center",
                  align = "start",
                  widget = wibox.widget.textbox,
                },
                widget = wibox.container.margin,
                margins = 12,
              },
              widget = wibox.container.background,
              shape = helpers.rrect(50),
              buttons = {
                awful.button({}, 1, function()
                  if self.paused == false then
                    self:pause()
                  else
                    self:resume()
                  end
                end)
              },
              bg = beautiful.pri
            },
            {
              {
                {
                  id = "reset",
                  font = beautiful.icofont .. " 20",
                  markup = helpers.colorizeText("󰦛", beautiful.fg),
                  valign = "center",
                  align = "start",
                  widget = wibox.widget.textbox,
                },
                widget = wibox.container.margin,
                margins = 12,
              },
              widget = wibox.container.background,
              shape = helpers.rrect(50),
              buttons = {
                awful.button({}, 1, function()
                  self.paused = true
                  self.timeRemaining = self.defaultTime
                  self.pausedTime = self.defaultTime
                  self.clock:stop()
                  self:update()
                end)
              },
              bg = beautiful.err
            },
            {
              {
                {
                  id = "increasetime",
                  font = beautiful.icofont .. " 20",
                  markup = helpers.colorizeText("󰐕", beautiful.fg),
                  valign = "center",
                  align = "start",
                  widget = wibox.widget.textbox,
                },
                widget = wibox.container.margin,
                margins = 12,
              },
              widget = wibox.container.background,
              shape = helpers.rrect(50),
              buttons = {
                awful.button({}, 1, function()
                  self.paused = true
                  self.defaultTime = self.defaultTime + 5 * 60
                  self.timeRemaining = self.defaultTime
                  self.timeRemaining = self.defaultTime
                  self.pausedTime = self.defaultTime
                  self.clock:stop()
                  self:update()
                end)
              },
            },
            layout = wibox.layout.fixed.horizontal,
            spacing = 20,
          },
          widget = wibox.container.place,
          halign = 'center',
        },
        layout = wibox.layout.fixed.vertical,
        spacing = 40,
      },
      widget = wibox.container.margin,
      margins = 25,
    },
    shape  = helpers.rrect(7),
    widget = wibox.container.background,
    bg     = beautiful.mbg
  }

  function self:update()
    local percent = math.floor((self.timeRemaining / self.defaultTime) * 100)
    self.widget:get_children_by_id("timer")[1].markup = string.format("%02d:%02d", self.timeRemaining / 60,
      self.timeRemaining % 60)
    self.widget:get_children_by_id('prog')[1].value = percent
    if self.timeRemaining == 0 then
      awful.spawn.with_shell("notify-send 'Time is up!' 'Get some rest'")
    end
  end

  local tick = function()
    if not self.paused then
      self.timeRemaining = self.timeRemaining - 1
      self:update()
    end
  end
  self.clock = gears.timer({
    timeout = 1,
    call_now = true,
    autostart = false,
    callback = tick
  })


  self:update()
  return self.widget
end

return timer:new()
