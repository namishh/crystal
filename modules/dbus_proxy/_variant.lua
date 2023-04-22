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
local VariantType = require("lgi").GLib.VariantType

local variant = {}

--[[-- Strip an `lgi.GLib.VariantType` object of its types

@param[type=lgi.GLib.VariantType] v an `lgi.GLib.VariantType` object

@return simple lua data (nested structures will be stripped too). The C to lua
type correspondence is straightforward:

  - numeric types will be returned as lua numbers
  - booleans are preserved
  -  string are preserved,
  - object paths (e.g. `/org/freedesktop/DBus`) will be returned as strings too
  - arrays (homogeneous types, signature `a`) and tuples (mixed types, signature `()`) will be returned as lua arrays
  - dictionaries (signature `{}`) will be returned as lua tables

@usage
GVariant = require("lgi").GLib.VariantType

-- strip a nested variant
v1 = GVariant("v", GVariant("s", "in a variant"))
stripped1 = variant.strip(v1)
-- "in a variant"

-- strip a dictionary of variants
v2 = GVariant("a{sv}", {one = GVariant("i", 123),
                              two = GVariant("s", "Lua!")})
stripped2 = variant.strip(v2)
-- {one = 123, two = "Lua!"}

-- strip a nested array
v3 = GVariant("aai", {{1, 2, 3}, {4, 1, 2, 3}})
stripped3 = variant.strip(v3)
-- {{1, 2, 3}, {4, 1, 2, 3}, n=2}
]]
function variant.strip(v)
  if not tostring(v):find "GLib%.Variant$" then
    if type(v) == "table" and #v > 0 then
      -- Strip the 'n' field from pure arrays.
      -- This is found in nested tuples.
      v.n = nil
    end
    return v
  end

  if v:is_container() and not v:is_of_type(VariantType.VARIANT) then
    local out = {}
    local n_children = v:n_children()
    local idx = 0

    local is_dict = v:is_of_type(VariantType.DICTIONARY)
    while idx < n_children do
      local val = v:get_child_value(idx)
      idx = idx + 1
      if is_dict then
        local key = val[1]
        local value = variant.strip(val[2])
        out[key] = variant.strip(value)
      else
        out[idx] = variant.strip(val)
      end
    end

    return out
  else
    return variant.strip(v.value)
  end
end

return variant
