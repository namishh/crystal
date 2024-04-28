-- Allows all signals to be connected and/or emitted.
return {
  client = require(... .. '.client'),
  -- NOTE: The `tag` file must be loaded before the `screen` one so that
  -- the correct layouts defined in `config.user` are appended to the tags
  -- upon creation.
  tag    = require(... .. '.tag'),
  screen = require(... .. '.screen'),
  system = require(... .. '.system'),
  stat   = require(... .. '.stat')
}
