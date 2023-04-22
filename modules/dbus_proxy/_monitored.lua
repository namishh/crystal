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
local table = table

local lgi = require "lgi"
local Gio = lgi.Gio
local GObject = lgi.GObject

local Proxy = require "modules.dbus_proxy._proxy"

local monitored = {}

local function make_disconnected(name)
  local o = {
    name = name,
  }

  local function disconnected_error()
    error(name .. " disconnected", 2)
  end

  setmetatable(o, {
    __call = disconnected_error,
    __newindex = disconnected_error,
    __index = disconnected_error,
  })
  return o
end

local function make_callbacks(managed, cb)
  local function name_appeared_callback()
    -- (bus, name, name_owner) passed as params, but we don't use them
    local proxy_obj = Proxy:new(managed._get_opts())
    rawset(managed, "is_connected", true)
    rawset(managed, "proxy", proxy_obj)
    setmetatable(managed, {
      __index = proxy_obj,
    })
    if cb then
      cb(managed, true)
    end
  end

  local function name_vanished_callback()
    -- (bus, name) passed as params, but we don't use them
    local proxy_obj = managed._get_disconnected_proxy()
    rawset(managed, "is_connected", false)
    rawset(managed, "proxy", proxy_obj)
    setmetatable(managed, {
      __index = proxy_obj,
    })
    if cb then
      cb(managed, false)
    end
  end

  return name_appeared_callback, name_vanished_callback
end

local function validate_opts(params)
  local opts = params or {}

  local absent_keys = {
    bus = false,
    interface = false,
    name = false,
    path = false,
  }

  for k, _ in pairs(absent_keys) do
    if opts[k] ~= nil then
      absent_keys[k] = true
    end
  end

  local result = {}
  local i = 1
  for k, v in pairs(absent_keys) do
    if v == false then
      result[i] = k
      i = i + 1
    end
  end

  local msg = table.concat(result, ", ")

  if msg ~= "" then
    error("Missing required DBus options: " .. msg, 2)
  end
end

--[[-- Create a monitored proxy object from the given options.

  This function creates a *monitored* @{Proxy} object that can come "live" as
  soon as the referenced DBus name is available.

  When the name is available (i.e. connected), the object will have the exact
  same behavior as a normal @{Proxy} object.

  When the name is **not** available, the object will raise an error when
  trying to access properties or call methods of the @{Proxy} object with the
  exception of the `name` property.

  @tparam table opts options that specify the DBus object to be proxied. In
  addition to the fields documented in @{Proxy:new}, the optional
  `watcher_flags` can be set to either `lgi.Gio.BusNameWatcherFlags.NONE` (the
  default) or `lgi.Gio.BusNameWatcherFlags.AUTO_START`. The latter will ask the
  bus to launch an owner for the name if there is no owner when beginning to
  watch the name (see also the [GBusNameWatcherFlags documentation on the GNOME
  website](https://developer.gnome.org/gio/stable/gio-Watching-Bus-Names.html#GBusNameWatcherFlags))

  @tparam[opt] func cb A callback function called with two parameters:
  the proxy object, and a boolean that is true when the DBus name
  appears and false when it vanishes.

  @see Proxy:new
  @return a @{Proxy} object with extra properties:

  - `is_connected` a boolean property that indicates whether the monitored
    proxy is actually connected. It can be checked before calling methods or
    accessing other properties on the object to avoid errors.

  @usage
  p = require("dbus_proxy")
  opts = {
    bus = p.Bus.SYSTEM,
    name = "com.example.BusName",
    interface = "com.example.InterfaceName",
    path = "/com/example/objectPath"
  }
  function callback(proxy, appeared)
    if appeared then
      -- proxy.is_connected is true
      proxy:SomeMethod()
    else
      -- proxy.is_connected is false
    end
  end
  proxy = p.monitored.new(opts, callback)

]]
function monitored.new(opts, cb)
  validate_opts(opts)

  local disconnected_proxy = make_disconnected(opts.name)

  local out = {
    name = opts.name,
    _get_opts = function()
      return opts
    end,
    _get_disconnected_proxy = function()
      return disconnected_proxy
    end,
  }

  local name_appeared_callback, name_vanished_callback = make_callbacks(out, cb)

  Gio.bus_watch_name_on_connection(
    opts.bus,
    opts.name,
    opts.watcher_flags or Gio.BusNameWatcherFlags.NONE,
    GObject.Closure(name_appeared_callback),
    GObject.Closure(name_vanished_callback),
    out
  )

  return out
end

return monitored
