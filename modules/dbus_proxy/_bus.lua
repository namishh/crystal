--[[
  Copyright 2017 Stefano Mazzucco

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
]]
---  @submodule dbus_proxy
local Gio = require("lgi").Gio

-- Private table
local _Bus = {}
setmetatable(_Bus, {
  __index = function(tbl, key)
    local v
    if key == "SESSION" or key == "SYSTEM" then
      v = Gio.bus_get_sync(Gio.BusType[key])
    else
      -- Pulseaudio example:
      -- key = "unix:path=/run/user/1000/pulse/dbus-socket"
      v = Gio.DBusConnection.new_for_address_sync(key, Gio.DBusConnectionFlags.NONE)
    end
    rawset(tbl, key, v)
    return v
  end,
})

--[[-- Available connections to the DBus daemon. Fields on this table
can only be accessed. Trying to set fields will result in an error.

@field SESSION Connection to the session bus for this process
@field SYSTEM  Connection to the system bus for this process
@field any_valid_dbus_address Connection to the
[DBus address](https://dbus.freedesktop.org/doc/dbus-tutorial.html#addresses).
If an invalid address is passed, its value will be `nil`.
@table Bus
@usage
Bus = require("dbus_proxy").Bus
system_bus = Bus.SYSTEM
session_bus = Bus.SESSION

-- This is a string that looks like
-- "unix:path=/run/user/1000/bus"
address = os.getenv("DBUS_SESSION_BUS_ADDRESS")

bus = Bus[address]
assert("Gio.DBusConnection" == bus._name)

invalid1 = Bus["something really wrong"]
assert(nil == invalid1)

invalid2 = Bus.this_will_not_work
assert(nil == invalid2)
]]
local Bus = {}
setmetatable(Bus, {
  __index = _Bus,
  __newindex = function()
    error("Cannot set values", 2)
  end,
})

return Bus
