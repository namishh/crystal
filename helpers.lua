local helpers        = {}
local awful          = require("awful")
local beautiful      = require("beautiful")
local gears          = require("gears")
local dpi            = beautiful.xresources.apply_dpi
local cairo          = require("lgi").cairo
local gmatrix        = require("gears.matrix")
local json           = require("mods.json")

helpers.rrect        = function(radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

helpers.addHover     = function(element, bg, hbg)
  element:connect_signal('mouse::enter', function(self)
    self.bg = hbg
  end)
  element:connect_signal('mouse::leave', function(self)
    self.bg = bg
  end)
end

helpers.placeWidget  = function(widget)
  if beautiful.barDir == 'left' then
    awful.placement.bottom_left(widget, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  elseif beautiful.barDir == 'right' then
    awful.placement.bottom_right(widget, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  elseif beautiful.barDir == 'bottom' then
    awful.placement.bottom(widget, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  elseif beautiful.barDir == 'top' then
    awful.placement.top(widget, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  end
end

helpers.prect        = function(tl, tr, br, bl, radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

helpers.clickKey     = function(c, key)
  awful.spawn.with_shell("xdotool type --window " .. tostring(c.window) .. " '" .. key .. "'")
end

helpers.colorizeText = function(txt, fg)
  if fg == "" then
    fg = "#ffffff"
  end

  return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

helpers.cropSurface  = function(ratio, surf)
  local old_w, old_h = gears.surface.get_size(surf)
  local old_ratio = old_w / old_h
  if old_ratio == ratio then return surf end

  local new_h = old_h
  local new_w = old_w
  local offset_h, offset_w = 0, 0
  -- quick mafs
  if (old_ratio < ratio) then
    new_h = math.ceil(old_w * (1 / ratio))
    offset_h = math.ceil((old_h - new_h) / 2)
  else
    new_w = math.ceil(old_h * ratio)
    offset_w = math.ceil((old_w - new_w) / 2)
  end

  local out_surf = cairo.ImageSurface(cairo.Format.ARGB32, new_w, new_h)
  local cr = cairo.Context(out_surf)
  cr:set_source_surface(surf, -offset_w, -offset_h)
  cr.operator = cairo.Operator.SOURCE
  cr:paint()

  return out_surf
end

helpers.inTable      = function(t, v)
  for _, value in ipairs(t) do
    if value == v then
      return true
    end
  end

  return false
end


helpers.generateId = function()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

helpers.find_last = function(haystack, needle)
  -- Set the third arg to false to allow pattern matching
  local found = haystack:reverse():find(needle:reverse(), nil, true)
  if found then
    return haystack:len() - needle:len() - found + 2
  else
    return found
  end
end



helpers.addTables = function(a, b)
  local result = {}
  for _, v in pairs(a) do
    table.insert(result, v)
  end
  for _, v in pairs(b) do
    table.insert(result, v)
  end
  return result
end

helpers.hasKey = function(set, key)
  return set[key] ~= nil
end

helpers.trim = function(string)
  return string:gsub("^%s*(.-)%s*$", "%1")
end
helpers.indexOf = function(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

helpers.split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

helpers.readFile = function(file)
  local f = assert(io.open(file, "rb"))
  local content = f:read("*all")
  f:close()
  return content
end

helpers.file_exists = function(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function get_widget_geometry(_hierarchy, widget)
  local width, height = _hierarchy:get_size()
  if _hierarchy:get_widget() == widget then
    -- Get the extents of this widget in the device space
    local x, y, w, h = gmatrix.transform_rectangle(_hierarchy:get_matrix_to_device(), 0, 0, width, height)
    return { x = x, y = y, width = w, height = h, hierarchy = _hierarchy }
  end

  for _, child in ipairs(_hierarchy:get_children()) do
    local ret = get_widget_geometry(child, widget)
    if ret then
      return ret
    end
  end
end

function helpers.get_widget_geometry(wibox, widget)
  return get_widget_geometry(wibox._drawable._widget_hierarchy, widget)
end

function helpers.randomColor()
  local accents = {
    beautiful.magenta,
    beautiful.yellow,
    beautiful.green,
    beautiful.red,
    beautiful.blue,
  }

  local i = math.random(1, #accents)
  return accents[i]
end

helpers.readJson = function(DATA)
  if helpers.file_exists(DATA) then
    local f = assert(io.open(DATA, "rb"))
    local lines = f:read("*all")
    f:close()
    local data = json.decode(lines)
    return data
  else
    return {}
  end
end

helpers.writeJson = function(PATH, DATA)
  local w = assert(io.open(PATH, "w"))
  w:write(json.encode(DATA, nil, { pretty = true, indent = "	", align_keys = false, array_newline = true }))
  w:close()
end

-- this stands for :get_children_by_id
helpers.gc = function(widget, id)
  return widget:get_children_by_id(id)[1]
end

helpers.beginsWith = function(str, pattern)
  return str:find('^' .. pattern) ~= nil
end


return helpers
