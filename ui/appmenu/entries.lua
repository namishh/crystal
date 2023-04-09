local wibox = require('wibox')
local beautiful = require('beautiful')
local Gio = require('lgi').Gio
local dpi = beautiful.xresources.apply_dpi
local awful = require('awful')
local lgi = require('lgi')
local iconTheme = lgi.require("Gtk", "3.0").IconTheme.get_default()

local appmenu = {
  grid = wibox.widget { id = "grid_role", layout = wibox.layout.grid },
  finalEntries = {},
  selected = 0
}

appmenu.entry = {
  {
    {
      {
        id = "image",
        scaling_quality = "good",
        widget = wibox.widget.imagebox
      },
      {
        id = "text",
        widget = wibox.widget.textbox
      },
      spacing = 10,
      layout = wibox.layout.fixed.horizontal
    },

    id = "background",
    bg = beautiful.bg,
    widget = wibox.container.background
  },
  forced_height = 30,
  widget = wibox.container.constraint
}

function appmenu:getEntries()
  local entries = {}
  for _, v in ipairs(Gio.AppInfo.get_all()) do
    local name = v:get_name():gsub('<', '&lt;'):gsub("'", "&#39;")
    local cmd = v:get_commandline():gsub('<', '&lt;'):gsub("'", "&#39;")
    table.insert(entries, { name, cmd, v })
  end
  table.sort(entries, function(a, b) return a[1]:lower() < b[1]:lower() end)

  -- making a widget for each entry
  for _, v in ipairs(entries) do
    local widget = wibox.widget(self.entry)
    local name, cmd, appinfo = v[1], v[2], v[3]
    local dependsOnTerminal = Gio.DesktopAppInfo.get_boolean(appinfo, "Terminal")
    widget:get_children_by_id('text'):set_markup_silently(name)

    local icon = appinfo:get_icon()
    local iconWidget = widget:get_children_by_id('image')
    if not icon then return end
    if not icon:to_string() then return end
    local path = icon:to_string()
    if path:find("/") then
      iconWidget:set_image(path)
    else
      local iconInfo = iconTheme:lookup_icon(path, dpi(48), 0)
      local file = iconInfo and iconInfo:get_filename()
      iconWidget.scaling_quality = path or "nearest"
      iconWidget:set_image(file or beautiful.profilepicture)
    end
    widget.name, widget.cmd, widget.appinfo,
    widget.dependsOnTerminal = name, cmd, appinfo, dependsOnTerminal

    self.finalEntries[#self.finalEntries + 1] = widget
  end
end

function appmenu:reset()
  for i = 1, 8, 1 do
    self.grid:remove_widgets_at(i, 1, 1, 1)
    self.grid:add_widget_at(self.finalEntries[i], i, 1, 1, 1)
  end
  self.selected = 8
  self.grid:get_widgets_at(self.selected, 1, 1, 1, 1)[1]:get_children_by_id('background')[1].background = beautiful.bg2 ..
      'cc'
end

function appmenu:select(bool)
  local diff = bool and -1 or 1
  if bool and self.selected > 1 or self.selected < 8 then
    local new_hl = self.grid:get_widgets_at(self.selected_entry + diff, 1, 1, 1)
    if new_hl then
      self:reset_highlights()
      self.selected_entry = self.selected_entry + diff
      new_hl[1]:get_children_by_id("background")[1]:set_bg(beautiful.bg_focus)
    end
  end
end

function appmenu:init(string)
  string = string or ''
  self:getEntries()
  self.wibox = wibox {
    x = beautiful.useless_gap * 2,
    y = beautiful.barSize + beautiful.useless_gap * 2,
    width = 200,
    height = 200,
    visible = true,
    ontop = true,
  }
end

return appmenu
