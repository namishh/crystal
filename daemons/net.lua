-- i am gonna rip off kasper
local dbus_proxy = require("modules.dbus_proxy")
local lgi = require("lgi")
local gears = require("gears")
local helpers = require("helpers")

local NM = require("lgi").NM

local network = {}
local accessPoint = {}

network.states = {
  UNKNOWN = 0,
  ASLEEP = 10,
  DISCONNECTED = 20,
  DISCONNECTING = 30,
  CONNECTING = 40,
  CONNECTED_LOCAL = 50,
  CONNECTED_SITE = 60,
  CONNECTED_GLOBAL = 70
}

network.DeviceType = {
  ETHERNET = 1,
  WIFI = 2
}

network.DeviceState = {
  UNKNOWN = 0,
  UNMANAGED = 10,
  UNAVAILABLE = 20,
  DISCONNECTED = 30,
  PREPARE = 40,
  CONFIG = 50,
  NEED_AUTH = 60,
  IP_CONFIG = 70,
  IP_CHECK = 80,
  SECONDARIES = 90,
  ACTIVATED = 100,
  DEACTIVATING = 110,
  FAILED = 120,
}

function network.deviceStateToString(state)
  local strings = {
    [0] = "Unknown",
    [10] = "Unmanaged",
    [20] = "Unavailable",
    [30] = "Disconnected",
    [40] = "Prepare",
    [50] = "Config",
    [60] = "Need Auth",
    [70] = "IP Config",
    [80] = "IP Check",
    [90] = "Secondaries",
    [100] = "Activated",
    [110] = "Deactivated",
    [120] = "Failed"
  }
  return strings[state]
end

local function securityFlag(flags, wpa_flags, rsn_flags)
  local str = ''
  if flags == 1 and wpa_flags == 0 and rsn_flags == 0 then
    str = str .. " WEP"
  end
  if wpa_flags ~= 0 then
    str = str .. " WPA1"
  end
  if not rsn_flags ~= 0 then
    str = str .. " WPA2"
  end
  if wpa_flags == 512 or rsn_flags == 512 then
    str = str .. " 802.1X"
  end

  return (str:gsub("^%s", ""))
end

local function createProfile(ap, pass, ac)
  local con = {
    ["uuid"] = lgi.GLib.Variant("s", helpers.generateId()),
    ["id"] = lgi.GLib.Variant("s", ap.ssid),
    ["type"] = lgi.GLib.Variant("s", "802-11-wireless"),
    ["autoconnect"] = lgi.GLib.Variant("b", ac)
  }

  local ip4 = {
    ["method"] = lgi.GLib.Variant("s", "auto")
  }

  local ip6 = {
    ["method"] = lgi.GLib.Variant("s", "auto")
  }

  local wifi = {
    ["mode"] = lgi.GLib.Variant("s", "infrastructure")
  }

  local wsec = {}
  if ap.security ~= "" then
    if ap.security:match("WPA") ~= nil then
      wsec["key-mgmt"] = lgi.GLib.Variant("s", "wpa-psk")
      wsec["auth-alg"] = lgi.GLib.Variant("s", "open")
      wsec["psk"] = lgi.GLib.Variant("s", pass:gsub("^%s*(.-)%s*$", "%1"))
    else
      wsec["key-mgmt"] = lgi.GLib.Variant("s", "None")
      wsec["wep-key-type"] = lgi.GLib.Variant("s", NM.WepKeyType.PASSPHRASE)
      wsec["wep-key0"] = lgi.GLib.Variant("s", pass:gsub("^%s*(.-)%s*$", "%1"))
    end
  end
  return {
    ["connection"] = con,
    ["ipv4"] = ip4,
    ["ipv6"] = ip6,
    ["802-11-wireless"] = wifi,
    ["802-11-wireless-security"] = wsec
  }
end

local function onWifiDeviceStateChanged(self, _, new, old, _)
  local activePoint = dbus_proxy.Proxy:new {
    bus = dbus_proxy.Proxy.Bus.SYSTEM,
    name = "org.freedesktop.NetworkManager",
    interface = "org.freedesktop.NetworkManager.AccessPoint",
    path = self._private.wifi_proxy.ActiveAccessPoint
  }
  self:emit_signal(tostring(activePoint.HwAddress) .. "::state", new, old)
  if new == network.DeviceState.ACTIVATED then
    local SSID = NM.utils_ssid_to_utf8(activePoint.Ssid)
    self:emit_signal("access_point:connected", SSID, activePoint.Strength)
  end
end

local function getAccessPointConnections(self, ssid)
  local proxies = {}
  local connections = self._private.settings_proxy:ListConnections()
  for _, path in ipairs(connections) do
    local proxy = dbus_proxy.Proxy:new {
      bus = dbus_proxy.Bus.SYSTEM,
      name = "org.freedesktop.NetworkManager",
      interface = "org.freedesktop.NetworkManager.Settings.Connection",
      path = path
    }

    if string.find(proxy.Filename, ssid) then
      table.insert(proxies, proxy)
    end
  end
  return proxies
end

local function getWifiProxy(self)
  local devices = self._private.client_proxy:GetDevices()
  for _, path in ipairs(devices) do
    local proxy = dbus_proxy.Proxy:new {
      bus = dbus_proxy.Bus.SYSTEM,
      name = "org.freedesktop.NetworkManager",
      interface = "org.freedesktop.NetworkManager.Device",
      path = path
    }
    if proxy.DeviceType == network.DeviceType.WIFI then
      self._private.device_proxy = proxy
      self._private.wifi_proxy = dbus_proxy.Proxy:new {
        bus = dbus_proxy.Bus.SYSTEM,
        name = "org.freedesktop.NetworkManager",
        interface = "org.freedesktop.NetworkManager.Device.Wireless",
        path = path
      }
      self._private.device_proxy:connect_signal("StateChanged", function(p, new, old)
        onWifiDeviceStateChanged(self, p, new, old)
      end)
    end
  end
end

function network:scanAccessPoints()
  if self._private.wifi_proxy == nil then
    return
  end

  self._private.access_points = {}
  self._private.wifi_proxy:RequestScanAsync(function(_, _, _, f)
    if f ~= nil then
      self:emit_signal("scan_access_points::failed", tostring(f), tostring(f.code))
      return
    end
    local accessPoints = self._private.wifi_proxy:GetAccessPoints()
    for _, accessPointPath in ipairs(accessPoints) do
      local accessPointProxy = dbus_proxy.Proxy:new {
        bus = dbus_proxy.Bus.SYSTEM,
        name = "org.freedesktop.NetworkManager",
        interface = "org.freedesktop.NetworkManager.AccessPoint",
        path = accessPointPath
      }

      if accessPointProxy.Ssid ~= nil then
        local ssid = NM.utils_ssid_to_utf8(accessPointProxy.Ssid)
        local security = securityFlag(accessPointProxy.Flags, accessPointProxy.WpaFlags, accessPointProxy.RsnFlags)
        local password = ""
        local connections = getAccessPointConnections(self, ssid)

        for _, connection in ipairs(connections) do
          if string.find(connection.Filename, ssid) then
            local secrets = connection:GetSecrets("802-11-wireless-security")
            if secrets ~= nil then
              password = secrets["802-11-wireless-security"]
            end
          end
        end

        local ret = {
          raw_ssid = accessPointProxy.Ssid,
          ssid = ssid,
          security = security,
          password = password,
          strength = accessPointProxy.Strength,
          path = accessPointPath,
          hw_address = accessPointProxy.HwAddress,
          device_interface = self._private.device_proxy.Interface,
          device_proxy_path = self._private.device_proxy.object_path,
          network_manager = self
        }
        gears.table.crush(ret, accessPoint, true)
        table.insert(self._private.access_points, ret)
      end
    end
    table.sort(self._private.access_points, function(a, b)
      return a.strength > b.strength
    end)
    self:emit_signal("scan_access_points::success", self._private.access_points)
  end, {
    call_id = "my-id"
  }, {})
end

function network:disconnectActive()
  self._private.client_proxy:DeactivateConnection(self._private.device_proxy.ActiveConnection)
end

function network:toggleWireless()
  local enable = not self._private.client_proxy.WirelessEnabled
  if enable == true then
    self:setNetworkState(true)
  end
  self._private.client_proxy:Set("org.freedesktop.NetworkManager", "WirelessEnabled", lgi.GLib.Variant("b", enable))
  self._private.client_proxy.WirelessEnabled = {
    signature = "b",
    value = enable
  }
end

function network:setNetworkState(state)
  self._private.client_proxy:Enable(state)
end

function network:getAccessPoints()
  return self._private.access_points
end

function accessPoint:connect(password, connect)
  local connections = getAccessPointConnections(self.network_manager, self.ssid)
  local profile = createProfile(self, password, connect)
  if #connections == 0 then
    self._private.client_proxy:AddAndActivateConnectionAsync(function(_, _, _, failure)
      if failure ~= nil then
        print("Failed to activate connection: ", failure)
        print("Failed to activate connection error code: ", failure.code)
        self.network_manager:emit_signal("activate_access_point::failed", tostring(failure), tostring(failure.code))
        return
      end

      self.network_manager:emit_signal("activate_access_point::success", self.ssid)
    end, { call_id = "my-id" }, profile, self.device_proxy_path, self.path)
  else
    connections[1]:Update(profile)
    self.network_manager._private.client_proxy:ActivateConnectionAsync(function(_, _, _, failure)
      if failure ~= nil then
        print("Failed to activate connection: ", failure)
        print("Failed to activate connection error code: ", failure.code)
        self.network_manager:emit_signal("activate_access_point::failed", tostring(failure), tostring(failure.code))
        return
      end

      self.network_manager:emit_signal("activate_access_point::success", self.ssid)
    end, { call_id = "my-id" }, connections[1].object_path, self.device_proxy_path, self.path)
  end
end

function accessPoint:isActive()
  return self.path == self.network_manager._private.wifi_proxy.ActiveAccessPoint
end

function accessPoint:toggle(password, connect)
  if self:isActive() then
    self.network_manager:disconnectActive()
  else
    self:connect(password, connect)
  end
end

local function init()
  local ret = gears.object {}
  gears.table.crush(ret, network, true)

  ret._private = {}
  ret._private.access_points = {}

  ret._private.client_proxy = dbus_proxy.Proxy:new {
    bus = dbus_proxy.Bus.SYSTEM,
    name = "org.freedesktop.NetworkManager",
    interface = "org.freedesktop.NetworkManager",
    path = "/org/freedesktop/NetworkManager"
  }

  ret._private.settings_proxy = dbus_proxy.Proxy:new {
    bus = dbus_proxy.Bus.SYSTEM,
    name = "org.freedesktop.NetworkManager",
    interface = "org.freedesktop.NetworkManager.Settings",
    path = "/org/freedesktop/NetworkManager/Settings"
  }

  local client_properties_proxy = dbus_proxy.Proxy:new {
    bus = dbus_proxy.Bus.SYSTEM,
    name = "org.freedesktop.NetworkManager",
    interface = "org.freedesktop.DBus.Properties",
    path = "/org/freedesktop/NetworkManager"
  }

  client_properties_proxy:connect_signal("PropertiesChanged", function(_, _, data)
    if data.WirelessEnabled ~= nil and ret._private.WirelessEnabled ~= data.WirelessEnabled then
      ret._private.WirelessEnabled = data.WirelessEnabled
      ret:emit_signal("wireless_state", data.WirelessEnabled)

      if data.WirelessEnabled == true then
        gears.timer.start_new(5, function()
          ret:scan_access_points()
          return false
        end)
      end
    end
  end)

  getWifiProxy(ret)
  ret:scanAccessPoints()

  gears.timer.delayed_call(function()
    ret:emit_signal("wireless_state", ret._private.client_proxy.WirelessEnabled)

    local active_access_point = ret._private.wifi_proxy.ActiveAccessPoint
    if ret._private.device_proxy.State == network.DeviceState.ACTIVATED and active_access_point ~= "/" then
      local active_access_point_proxy = dbus_proxy.Proxy:new {
        bus = dbus_proxy.Bus.SYSTEM,
        name = "org.freedesktop.NetworkManager",
        interface = "org.freedesktop.NetworkManager.AccessPoint",
        path = active_access_point
      }

      local ssid = NM.utils_ssid_to_utf8(active_access_point_proxy.Ssid)
      ret:emit_signal("access_point::connected", ssid, active_access_point_proxy.Strength)
    end
  end)

  return ret
end

return init()
