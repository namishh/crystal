local notify = require 'notify'
notify.setup {
  icons = {
    DEBUG = "  ",
    ERROR = "  ",
    WARN = "  ",
    TRACE = "  ",
    INFO = "  ",
  },
  fps = 60,
  max_height = 5,
  max_widht = 10,
  timeout = 5,
}

