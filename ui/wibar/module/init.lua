-- Return a table containing all bar modules, with a name attached
-- to each.
return {
  taglist  = require(... .. '.taglist'),
  tasklist = require(... .. '.tasklist'),
  battery  = require(... .. '.battery'),
  wifi     = require(... .. '.wifi'),
  systray  = require(... .. '.systray'),
  time     = require(... .. '.time'),
  session  = require(... .. '.session'),
}
