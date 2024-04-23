-- Return a table containing all bar modules, with a name attached
-- to each.
return {
  launcher  = require(... .. '.launcher'),
  taglist   = require(... .. '.taglist'),
  tasklist  = require(... .. '.tasklist'),
  layoutbox = require(... .. '.layoutbox'),
  battery   = require(... .. '.battery'),
  wifi      = require(... .. '.wifi'),
  bluetooth = require(... .. '.bluetooth'),
  systray   = require(... .. '.systray'),
  time      = require(... .. '.time'),
  session   = require(... .. '.session'),
}
