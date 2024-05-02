local config_user = loadfile(os.getenv("HOME") .. "/.config/awesome/config/user.lua")()
local flavour     = config_user.flavour
local m           = {}
m.name            = 'dawn'
if flavour == "serenity" then
  m.type = "dark"
  m.bg   = "#191724"
  m.mbg  = "#1f1d2e"
  m.bg3  = "#26233a"
  m.bg4  = "#393552"

  m.fg   = "#e0def4"
  m.fg2  = "#e0def4"
  m.fg3  = "#908caa"
  m.fg4  = "#9893a5"
  m.comm = "#9893a5"
  m.mab  = "#252736"

  m.pri  = "#9ccfd8"
  m.ok   = "#3e8fb0"
  m.err  = "#ea9a97"
  m.dis  = "#c4a7e7"
  m.warn = "#f6c177"
else
  m.mbg  = "#f4ede8"
  m.bg   = "#fffaf3"
  m.bg3  = "#f2e9e1"
  m.bg4  = "#cecacd"
  m.fg   = "#575279"
  m.fg2  = "#575279"
  m.fg3  = "#797593"
  m.fg4  = "#9893a5"
  m.comm = "#9893a5"
  m.type = "light"
  if flavour == "dawn" then
    m.pri  = "#56949f"
    m.warn = "#ea9d34"
    m.err  = "#d7827e"
    m.mab  = "#edebe8"
    m.dis  = "#907aa9"
    m.ok   = "#286983"
  else
    m.ok   = "#56949f"
    m.warn = "#ea9d34"
    m.dis  = "#d7827e"
    m.err  = "#907aa9"
    m.pri  = "#286983"
    m.mab  = "#edebe8"
  end
end
return m
