--[[
  Copyright 2017 Stefano Mazzucco
  Copyright 2018 - 2020 Stefano Mazzucco and contributors

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
local string = string
local table = table
local unpack = unpack or table.unpack -- luacheck: globals unpack

local lgi = require "lgi"

local DBusProxy = lgi.Gio.DBusProxy
local DBusProxyFlags = lgi.Gio.DBusProxyFlags
local DBusInterfaceInfo = lgi.Gio.DBusInterfaceInfo
local DBusNodeInfo = lgi.Gio.DBusNodeInfo
local DBusCallFlags = lgi.Gio.DBusCallFlags
local GVariant = lgi.GLib.Variant

local _DEFAULT_TIMEOUT = -1

local variant = require "modules.dbus_proxy._variant"

local gdebug = require "gears.debug"

--[[-- A proxy object

Proxy objects act as intermediares between your lua code and DBus.  All the
properties, methods and signals of the object are exposed.  Be aware that
properties, methods and signals will likely be written in `CamelCase` since
this it the convention in DBus (e.g. `proxy.SomeProperty` or
`proxy:SomeMethod()`). Please refer to the documentation of the object you are
proxying for more information.

When a property in a DBus object changes, the same change is reflected in the
proxy.  Similarly, when a signal is emitted, the proxy object is notified
accordingly.

Additionally, the following fields reflect the corresponding [`g-*`
properties](https://developer.gnome.org/gio/2.50/GDBusProxy.html#GDBusProxy.properties):

- `connection`: g-connection
- `flags`: g-flags
- `interface`: g-interface-name
- `name`: g-name
- `name_owner`: g-name-owner
- `object_path`: g-object-path

Some proxy methods may report errors (see the documentation of the object your
are proxying). In that case you can check them with the usual error-checking
pattern as shown in the usage example.

For all this to work though, the code must run inside [GLib's main event
loop](https://developer.gnome.org/glib/stable/glib-The-Main-Event-Loop.html#glib-The-Main-Event-Loop.description). This
can be achieved in two ways:

1. Create a
   [main loop](https://developer.gnome.org/glib/stable/glib-The-Main-Event-Loop.html#GMainLoop)
   and run it when the application starts:


           local GLib = require("lgi").GLib
           -- Set up the application, then do:
           local main_loop = GLib.MainLoop()
           main_loop:run()
           -- use main_loop:quit() to stop the main loop.


2. Use more fine-grained control by running an iteration at a time from
   the
   [main context](https://developer.gnome.org/glib/stable/glib-The-Main-Event-Loop.html#GMainContext);
   this is particularly useful when you want to integrate your code with an
   **external main loop**:


          local GLib = require("lgi").GLib
          -- Set up the code, then do
          local ctx = GLib.MainLoop():get_context()
          -- Run a single non-blocking iteration
          if ctx:iteration() == true then
            print("something changed!")
          end
          -- Run a single blocking iteration
          if ctx:iteration(true) == true then
            print("something changed here too!")
          end

--------

  **NOTE**

  If you use the Awesome Window Manager, the code will be already running
  inside a main loop.

--------

@table Proxy
@usage
p = require("dbus_proxy")
proxy = p.Proxy:new(
    {
      bus = p.Bus.SYSTEM,
      name = "com.example.BusName",
      interface = "com.example.InterfaceName",
      path = "/com/example/objectPath"
    }
)

res, err = proxy:SomeMethod()
-- Check whether an error occurred.
if not res and err then
    print("Error:", err)
    print("Error code:", err.code)
end

proxy:SomeMethodWithArguments("hello", 123)
proxy.SomeProperty

-- Asynchronous method calls are also supported, they have the "Async"
-- suffix. For example:

local function callback_fn(proxy, context, success, failure)
  if failure ~= nil then  -- error from the DBus Method
    print("Error:", failure)
    print("Error code:", failure.code)
    -- add the data from the DBus method to the context
    context.failure = failure
    return
  end

  -- add the data from the DBus method to the context
  context.success = success
end

local my_context = {call_id = "my-id"}
some_proxy:SomeMethodWithArgumentsAsync(callback_fn, my_context, "hello", 123)

-- Do something else while waiting for the callback to be called with the
-- result

]]
local Proxy = {}

--- Build a lgi.GLib.Variant tuple that can be used to call a method
-- @param args[type=table] an array of tables that have the `type` and `value` fields.
-- For example
--
--    {
--      {type = "s", value = "a string"},
--      {type = "v", value = lgi.GLib.Variant("s", "a string variant")}
--    }
--
-- @return [lgi.GLib.Variant
-- tuple](https://developer.gnome.org/glib/stable/glib-GVariant.html) or `nil`
-- if no arguments are passed.
--
-- @see build_args
local function build_params(args)
  if not args then
    return nil
  end

  local sig = "("
  local val = {}
  for i, v in ipairs(args) do
    sig = sig .. v.type
    val[i] = v.value
  end
  sig = sig .. ")"
  return GVariant(sig, val)
end

--- Synchronously call a method with arguments from a given interface on a proxy object.
-- @param[type=Proxy] proxy a Proxy object
-- @param[type=string] interface the interface name
-- @param[type=string] method the method name
-- @param[type=lgi.GLib.Variant] args [lgi.GLib.Variant
-- tuple](https://developer.gnome.org/glib/stable/glib-GVariant.html) arguments
-- to be passed to `method`
--
-- @see build_args
-- @see generate_method
local function call(proxy, interface, method, args)
  local out, err = proxy._proxy:call_sync(interface .. "." .. method, args, DBusCallFlags.NONE, _DEFAULT_TIMEOUT)
  if not out and err then
    return out, err
  end
  local result = variant.strip(out)
  if type(result) == "table" and #result == 1 then
    result = result[1]
  end
  return result
end

--- Asynchronously call a method with arguments from a given interface on a proxy object.
-- Internally, it uses
-- [g_dbus_proxy_call](https://developer.gnome.org/gio/stable/GDBusProxy.html#g-dbus-proxy-call)
-- and
-- [g_dbus_proxy_call_finish](https://developer.gnome.org/gio/stable/GDBusProxy.html#g-dbus-proxy-call-finish).
-- @param[type=Proxy] proxy a Proxy object.
-- @param[type=string] interface the interface name.
-- @param[type=string] method the method name
-- @param[type=function] user_callback callback function that accepts **four**
-- arguments: `proxy` (the Proxy object), `context` arbitrary context data (see
-- also the `context` parameter of this function), `success` (the data, if any,
-- returned by the DBus method in case of success), `failure` (the data, if any,
-- returned by the DBus method in case of failure)
-- @param[type=any] context context data that will be passed to `user_callback`.
-- @param[type=lgi.GLib.Variant] args [lgi.GLib.Variant
-- tuple](https://developer.gnome.org/glib/stable/glib-GVariant.html) arguments
-- to be passed to `method`
--
-- @see build_args
-- @see generate_async_method
local function call_async(proxy, interface, method, user_callback, context, args)
  proxy._proxy:call(interface .. "." .. method, args, DBusCallFlags.NONE, _DEFAULT_TIMEOUT, nil, function(_proxy, res)
    local out, err = _proxy:call_finish(res)

    if not out and err then
      user_callback(proxy, context, out, err)
      return
    end

    local result = variant.strip(out)
    if type(result) == "table" and #result == 1 then
      result = result[1]
    end

    user_callback(proxy, context, result)
  end)
end

--- Get a cached property out of a proxy object
-- @param[type=Proxy] proxy a proxy object
-- @param[type=string] name the name of the property
-- @return the value of the property
local function get_property(proxy, name)
  local out = proxy._proxy:get_cached_property(name)
  return variant.strip(out)
end

--- Set a cached property of a proxy object
-- @param[type=Proxy] proxy a proxy object
-- @param[type=string] name the name of the property
-- @param[type=table] opts containing the following attributes: <br>
-- -  `value` the value to be set <br>
-- -  `signature` the DBus signature as a string
local function set_property(proxy, name, opts)
  local variant_value = GVariant(opts.signature, opts.value)
  proxy._proxy:set_cached_property(name, variant_value)
end

--- Get the XML representation of a proxy object
-- @param[type=Proxy] proxy a proxy object
-- @return a string with the XML representation of the object
local function introspect(proxy)
  return call(proxy, "org.freedesktop.DBus.Introspectable", "Introspect")
end

--- Build arguments for a method call.
-- @param[type=lgi.Gio.DBusMethodInfo] method the [method info
-- object](https://developer.gnome.org/gio/stable/gio-D-Bus-Introspection-Data.html#GDBusMethodInfo-struct)
-- @param[type=any] list of arguments as lua types
--
-- @return [lgi.GLib.Variant
-- tuple](https://developer.gnome.org/glib/stable/glib-GVariant.html) or `nil`
-- if no arguments are passed.
--
-- @see build_params
-- @see generate_method
-- @see generate_async_method
local function build_args(method, ...)
  local args = {}
  for _, arg in ipairs(method.in_args) do
    args[#args + 1] = {
      type = arg.signature,
    }
  end

  assert(#{ ... } == #args, string.format("Expected %d parameters but got %d", #args, #{ ... }))

  for idx, val in ipairs { ... } do
    args[idx].value = val
  end

  return build_params(args)
end

--- Generate a *synchronous* method.
-- @param[type=string] interface_name the interface name
-- @param[type=lgi.Gio.DBusMethodInfo] method the [method info
-- object](https://developer.gnome.org/gio/stable/gio-D-Bus-Introspection-Data.html#GDBusMethodInfo-struct)
-- @return a function that wraps @{build_args} and @{call} so the method can be called
-- by passing the arguments as simple lua types.
-- @see build_args
-- @see call
local function generate_method(interface_name, method)
  return function(proxy, ...)
    local args = build_args(method, ...)

    return call(proxy, interface_name, method.name, args)
  end
end

--- Generate an *asynchronous* method.
-- @param[type=string] interface_name the interface name
-- @param[type=lgi.Gio.DBusMethodInfo] method the [method info
-- object](https://developer.gnome.org/gio/stable/gio-D-Bus-Introspection-Data.html#GDBusMethodInfo-struct)
-- @return a function that wraps @{build_args} and @{call_async} so the method can be called
-- by passing the arguments as simple lua types.
-- @see build_args
-- @see call_async
local function generate_async_method(interface_name, method)
  return function(proxy, user_callback, context, ...)
    local args = build_args(method, ...)

    return call_async(proxy, interface_name, method.name, user_callback, context, args)
  end
end

--- Generate the accessor table for a property
-- @param[type=lgi.Gio.DBusPropertyInfo] property the [property info
-- object](https://developer.gnome.org/gio/stable/gio-D-Bus-Introspection-Data.html#GDBusPropertyInfo-struct)
-- @return a table with the `getter` and `setter` fields that wrap
-- @{get_property} and @{set_property} respectively. If the property is **not**
-- readable or writeable, the functions will return an error when attempting to
-- read/write the property.
-- @see get_property
-- @see set_property
local function generate_accessor(property)
  local accessor = {}

  if property.flags.READABLE then
    accessor.getter = function(proxy)
      return get_property(proxy, property.name)
    end
  else
    accessor.getter = function()
      error(string.format("Property '%s' is not readable", property.name))
    end
  end

  if property.flags.WRITABLE then
    accessor.setter = function(proxy, opts)
      set_property(proxy, property.name, opts)
    end
  else
    accessor.setter = function()
      error(string.format("Property '%s' is not writable", property.name))
    end
  end

  return accessor
end

--- Generate the fields of a proxy object.
--
-- This function will attach properties, methods and signals to the proxy
-- object. To be used during initialization.  **NOTE** This function will
-- **not** generate fields for nested nodes, if any.
--
-- @param[type=Proxy] proxy a proxy object
local function generate_fields(proxy)
  local xml_data_str, err = introspect(proxy)

  if not xml_data_str then
    gdebug.print_warning(
      string.format(
        "Failed to introspect object '%s'\nerror: %s\ncode: %s",
        proxy.name,
        err or "<unknown>",
        err.code or "<unknown>"
      )
    )
    -- error(
    --   string.format(
    --     "Failed to introspect object '%s'\nerror: %s\ncode: %s",
    --     proxy.name, err or "<unknown>", err.code or "<unknown>"
    --   )
    -- )
    return
  end

  local node = DBusNodeInfo.new_for_xml(xml_data_str)

  -- NOTE: does not take into account nested nodes.
  for _, iface in ipairs(node.interfaces) do
    for _, method in ipairs(iface.methods) do
      if not proxy[method.name] then
        proxy[method.name] = generate_method(iface.name, method)
        proxy[method.name .. "Async"] = generate_async_method(iface.name, method)
      else
        -- override only if the interface name is the same as the proxy's
        if iface.name == proxy.interface then
          proxy[method.name] = generate_method(iface.name, method)
          proxy[method.name .. "Async"] = generate_async_method(iface.name, method)
        end
      end
    end

    for _, signal in ipairs(iface.signals) do
      proxy.signals[signal.name] = true
    end

    for _, property in ipairs(iface.properties) do
      proxy.accessors[property.name] = generate_accessor(property)
    end
  end

  for k, _ in pairs(proxy) do
    if proxy.accessors[k] ~= nil then
      -- A property with the same name as a method was found, rename it by
      -- adding an underscore and remove the original, but bail out silently in
      -- the unlikely case that the name exists too.
      local new_name = "_" .. k
      if proxy.accessors[new_name] == nil then
        proxy.accessors[new_name], proxy.accessors[k] = proxy.accessors[k], nil
      end
    end
  end
end

local meta = {
  __index = function(tbl, key)
    if Proxy[key] then
      return Proxy[key]
    end

    local v = tbl.accessors[key]

    if v then
      return v.getter(tbl)
    end

    return rawget(tbl, key)
  end,
  __newindex = function(tbl, key, value)
    local v = tbl.accessors[key]

    if v then
      v.setter(tbl, value)
    else
      rawset(tbl, key, value)
    end
  end,
}

--[[-- Connect a callback function to a signal.

@param[type=function] callback a callback function to be called.  The proxy
object itself and the parameters from the signal as (simple lua types) will be
passed to the callback when the signal is emitted

@param[type=string] signal_name the name of the signal

@tparam[opt] string sender_name the name of the sender.  This may have the form
of a well known name (e.g. `"org.freedesktop.DBus"`) or a specific connection
name ( e.g. `":1.113"`).  See also the [Bus Names section of the DBus
tutorial](https://dbus.freedesktop.org/doc/dbus-tutorial.html#bus-names).  If
specified, only signals from this sender will be taken into account.

@usage
proxy:connect_signal(
  function (p, x, y)
    assert(p == proxy)
    print("SomeSignalName emitted with params: ", x, y)
  end,
  "SomeSignalName"
)
]]
function Proxy:connect_signal(signal_name, callback, sender_name)
  if not self.signals[signal_name] then
    error(string.format("Invalid signal: %s", signal_name))
  end

  self._proxy.on_g_signal = function(_, sender, signal, params)
    if sender_name ~= nil and sender_name ~= sender then
      return
    end

    if signal == signal_name then
      params = variant.strip(params)
      return callback(self, unpack(params))
    end
  end
end

--[[-- Call a function when the properties of the proxy object change.

@param[type=function] callback a function that will be called when the
 properties change. The callback will receive the proxy object itself and two
 tables: `changed_properties` (a table where the keys are the properties that
 changed and the values the new values) and `invalidated_properties` (an array
 containg the names of the invalidated properties).  Either may be empty.  The
 local cache has already been updated when the signal is emitted, so the
 properties on the object will be up-to-date

@usage
proxy:on_properties_changed(function (p, changed, invalidated)
    assert(p == proxy)
    print("******")
    print("changed properties:")
    for k, v in pairs(changed) do
      print("name", k, "ne value", v)
    end
    print("invalidated properties")
    for _, v in ipairs(invalidated) do
      print("name", v)
    end
    print("******")
end)

]]
function Proxy:on_properties_changed(callback)
  self._proxy.on_g_properties_changed = function(_, changed, invalidated)
    changed = variant.strip(changed)
    return callback(self, changed, invalidated)
  end
end

--[[-- Create a new proxy object

@param[type=table] opts table that specifies what DBus object should be
proxied.
The `opts` table should have the following fields:

  - `bus`: a DBus connection from the @{Bus} table
  - `interface`: a (**string**) representing the interface name
  - `name`: a (**string**) representing the Bus name
  - `path`: a (**string**) representing the object path
  - `flags`: one of the [`lgi.Gio.DBusProxyFlags`](https://developer.gnome.org/gio/2.50/GDBusProxy.html#GDBusProxyFlags); defaults to `lgi.Gio.DBusProxyFlags.NONE` *(optional)*


@return a new proxy object

]]
function Proxy:new(opts)
  local proxy, err = DBusProxy.new_sync(
    opts.bus,
    opts.flags or DBusProxyFlags.NONE,
    DBusInterfaceInfo {
      name = opts.interface,
    },
    opts.name,
    opts.path,
    opts.interface
  )

  if err then
    error(err)
  end

  local o = {}
  o.accessors = {}
  o.signals = {}
  o._proxy = proxy
  -- g-* properties
  o.connection = proxy.g_connection
  o.flags = proxy.g_flags
  o.interface = proxy.g_interface_name
  o.name = proxy.g_name
  o.name_owner = proxy.g_name_owner
  o.object_path = proxy.g_object_path

  generate_fields(o)

  setmetatable(o, meta)
  self.__index = self

  return o
end

return Proxy
