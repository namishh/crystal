require("signals.battery")
require("signals.network")
require("signals.bright")
require("signals.volume")
require("signals.bluetooth")
require("signals.dnd")
require("signals.airplane")
require("signals.tog")
require("signals.picom")
require("signals.mic")
return {
  naughty = require 'signals.naughty',
  tag     = require 'signals.tag',
  screen  = require 'signals.screen',
  client  = require 'signals.client',
  ruled   = require 'signals.ruled',
}
