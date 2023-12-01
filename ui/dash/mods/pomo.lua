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
      id = "image",
      image = helpers.cropSurface(1.42, gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "/theme/assets/pomo.jpg")),
      widget = wibox.widget.imagebox,
      clip_shape = helpers.rrect(20),
      opacity = 0.9,
      resize = true,
      horizontal_fit_policy = "fit"
    },
    {
      {
        widget = wibox.widget.textbox,
      },
      bg = {
        type = "linear",
        from = { 0, 0 },
        to = { 200, 0 },
        stops = { { 0, beautiful.mbg .. "aa" }, { 1, beautiful.bg .. 'dd' } }
      },
      shape = helpers.rrect(20),
      widget = wibox.container.background,
    },
    {
      {
        {
          {
            {
              {
                id = "timer",
                font = beautiful.sans .. " 48",
                markup = "00:00",
                valign = "center",
                align = "start",
                widget = wibox.widget.textbox,
              },
              widget = wibox.container.place,
              halign = 'center'
            },
            {
              {
                {
                  {
                    {
                      id = "reset",
                      font = beautiful.icon .. " 20",
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
                      font = beautiful.icon .. " 20",
                      markup = helpers.colorizeText("󰐎", beautiful.blue),
                      valign = "center",
                      align = "start",
                      widget = wibox.widget.textbox,
                    },
                    widget = wibox.container.margin,
                    margins = 12,
                  },
                  widget = wibox.container.background,
                  shape = helpers.rrect(10),
                  buttons = {
                    awful.button({}, 1, function()
                      if self.paused == false then
                        self:pause()
                      else
                        self:resume()
                      end
                    end)
                  },
                  bg = beautiful.blue .. '11'
                },
                {
                  {
                    {
                      id = "reset",
                      font = beautiful.icon .. " 20",
                      markup = helpers.colorizeText("󰦛", beautiful.red),
                      valign = "center",
                      align = "start",
                      widget = wibox.widget.textbox,
                    },
                    widget = wibox.container.margin,
                    margins = 12,
                  },
                  widget = wibox.container.background,
                  shape = helpers.rrect(10),
                  buttons = {
                    awful.button({}, 1, function()
                      self.paused = true
                      self.timeRemaining = self.defaultTime
                      self.pausedTime = self.defaultTime
                      self.clock:stop()
                      self:update()
                    end)
                  },
                  bg = beautiful.red .. '11'
                },
                {
                  {
                    {
                      id = "increasetime",
                      font = beautiful.icon .. " 20",
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
        widget = wibox.container.place,
        valign = 'center',
      },
      shape  = helpers.rrect(20),
      widget = wibox.container.background,
    },
    {
      {
        nil,
        {
          id               = "prog",
          max_value        = 100,
          value            = 0,
          forced_height    = 20,
          bar_shape        = helpers.prect(false, false, true, true, 20),
          shape            = helpers.prect(false, false, true, true, 20),
          color            = beautiful.green,
          background_color = beautiful.green .. '11',
          paddings         = 1,
          border_width     = 1,
          widget           = wibox.widget.progressbar,
        },
        nil,
        layout = wibox.layout.align.vertical,
      },
      widget = wibox.container.place,
      valign = "bottom"
    },
    layout = wibox.layout.stack,
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
