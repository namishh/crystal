-- Returns all widgets, with assigned names, in a table.
return {
  menu         = require(... .. '.menu'),
  notification = require(... .. '.notification'),
  titlebar     = require(... .. '.titlebar'),
  wibar        = require(... .. '.wibar'),
  launcher     = require(... .. ".launcher"),
  settings     = require(... .. ".settings"),
  calnotif     = require(... .. ".calnotif"),
  powermenu    = require(... .. ".power"),
  dash         = require(... .. ".dash"),
  osd          = require(... .. ".osd"),
}
