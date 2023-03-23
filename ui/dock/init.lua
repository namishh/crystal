local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local getIcon = require("ui.dock.getIcon")
local drawPreview = require("ui.dock.taskpreview")

local dock = {
  createDock = function(s)
    return awful.popup {
      type = "dock",
      visible = true,
      ontop = true,
      height = 100,
    }
  end
}
