local lgi = require "lgi"
local Gio = lgi.Gio
local DesktopAppInfo = Gio.DesktopAppInfo
local AppInfo = Gio.DesktopAppInfo
local Gtk = lgi.require("Gtk", "3.0")
local string = string
local ipairs = ipairs

local ICON_SIZE = 48
local GTK_THEME = Gtk.IconTheme.get_default()

local _icon_theme = {}

function _icon_theme.choose_icon(icons_names, icon_theme, icon_size)
  if icon_theme then
    GTK_THEME = Gtk.IconTheme.new()
    Gtk.IconTheme.set_custom_theme(GTK_THEME, icon_theme)
  end
  if icon_size then
    ICON_SIZE = icon_size
  end

  local icon_info = GTK_THEME:choose_icon(icons_names, ICON_SIZE, 0)
  if icon_info then
    local icon_path = icon_info:get_filename()
    if icon_path then
      return icon_path
    end
  end

  return ""
end

function _icon_theme.get_gicon_path(gicon, icon_theme, icon_size)
  if gicon == nil then
    return ""
  end

  if icon_theme then
    GTK_THEME = Gtk.IconTheme.new()
    Gtk.IconTheme.set_custom_theme(GTK_THEME, icon_theme)
  end
  if icon_size then
    ICON_SIZE = icon_size
  end

  local icon_info = GTK_THEME:lookup_by_gicon(gicon, ICON_SIZE, 0)
  if icon_info then
    local icon_path = icon_info:get_filename()
    if icon_path then
      return icon_path
    end
  end

  return ""
end

function _icon_theme.get_icon_path(icon_name, icon_theme, icon_size)
  if icon_theme then
    GTK_THEME = Gtk.IconTheme.new()
    Gtk.IconTheme.set_custom_theme(GTK_THEME, icon_theme)
  end
  if icon_size then
    ICON_SIZE = icon_size
  end

  local icon_info = GTK_THEME:lookup_icon(icon_name, ICON_SIZE, 0)
  if icon_info then
    local icon_path = icon_info:get_filename()
    if icon_path then
      return icon_path
    end
  end

  return ""
end

function _icon_theme.get_client_icon_path(client, icon_theme, icon_size)
  local app_list = AppInfo.get_all()

  local class = string.lower(client.class)
  local name = string.lower(client.name)

  for _, app in ipairs(app_list) do
    local id = app:get_id()
    local desktop_app_info = DesktopAppInfo.new(id)
    if desktop_app_info then
      local props = {
        id:gsub(".desktop", ""),
        desktop_app_info:get_string "Name",
        desktop_app_info:get_filename(),
        desktop_app_info:get_startup_wm_class(),
        desktop_app_info:get_string "Icon",
        desktop_app_info:get_string "Exec",
        desktop_app_info:get_string "Keywords",
      }

      for _, prop in ipairs(props) do
        if prop ~= nil and (prop:lower() == class or prop:lower() == name) then
          local icon = desktop_app_info:get_string "Icon"
          if icon ~= nil then
            return _icon_theme.get_icon_path(icon, icon_theme, icon_size)
          end
        end
      end
    end
  end

  return _icon_theme.choose_icon({ "window", "window-manager", "xfwm4-default", "window_list" }, icon_theme, icon_size)
end

return _icon_theme
