-- Returns titlebars for normal clients, this structure allows one to
-- easily define special titlebars for particular clients.
return {
  normal = require(... .. '.normal'),
  music = require(... .. '.music')
}
