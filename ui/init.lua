-- Returns all widgets, with assigned names, in a table.
return {
  menu         = require(... .. '.menu'),
  notification = require(... .. '.notification'),
  titlebar     = require(... .. '.titlebar'),
  wibar        = require(... .. '.wibar'),
  launcher     = require(... .. ".launcher"),
  settings     = require(... .. ".settings"),
  lock         = require(... .. ".lock"),
  calendar     = require(... .. ".calendar"),
  osd          = require(... .. ".osd"),
}
