local json = require("mods.json")
local helpers = require("helpers")
local gfs = require("gears.filesystem")

local M = {}

M.defaultData = {
  colorscheme = "cat",
  gaps = 10,
  iconTheme = "~/.local/share/icons/hicolor/",
  openWeatherApi = "KEY_HERE",
  showDesktopIcons = true,
  pfp = "/home/" .. string.gsub(os.getenv('USER'), '^%l', string.lower) .. "/.config/awesome/theme/assets/pfp.png",
  wallpaper = "colorful",
}

M.path = gfs.get_cache_dir() .. "json/settings.json"

function M:generate()
  if not helpers.file_exists(self.path) then
    local w = assert(io.open(self.path, "w"))
    w:write(json.encode(self.defaultData, nil, { pretty = true, indent = "	", align_keys = false, array_newline = true }))
    w:close()
    M.settings = self.defaultData
  else
    local r = assert(io.open(self.path, "rb"))
    local t = r:read("*all")
    r:close()
    local settings = json.decode(t)
    M.settings = settings
  end

  if not helpers.file_exists(gfs.get_cache_dir() .. "lock/lock.jpg") then
    os.execute("mkdir -p ~/.cache/awesome/lock")
  end
end

return M
