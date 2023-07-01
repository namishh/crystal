local awful = require("awful")
local helpers = require("helpers")
local dontSuckMe = {}

local checkForSucc = function(child, parent)
  local canSuc = false
  if not helpers.inTable(dontSuckMe, child) and parent == "kitty" then
    canSuc = true
  end
  return canSuc
end

local getDaddy = function(child, cb)
  awful.spawn.easy_async(string.format("pstree -p %s", child), function(output, _, _, _)
    cb(nil, output)
  end)
end

function on(c)
  local current_tag = c.screen.selected_tag
  ctags = { current_tag }
  for k, tag in pairs(c:tags()) do
    if tag ~= current_tag then
      table.insert(ctags, tag)
    end
  end
  c:tags(ctags)
  c:raise()
  client.focus = c
end

local sync = function(c, p)
  if not c.valid or not p.valid then
    return
  end
  if p.modal then
    return
  end
  c.floating = p.floating
  c.maximized = p.maximized
  c.above = p.above
  c.below = p.below
  c:geometry(p:geometry())
end

function off(c)
  current_tag = c.screen.selected_tag
  local ctags = {}
  for k, tag in pairs(c:tags()) do
    if tag ~= current_tag then
      table.insert(ctags, tag)
    end
  end
  c:tags(ctags)
  c.sticky = false
end

local handle = function(c)
  local daddy = awful.client.focus.history.get(c.screen, 1)
  if not daddy or daddy.type == "dialog" or daddy.type == "splash" then return end
  getDaddy(c.pid, function(e, pid)
    if (tostring(pid):find("(" .. tostring(daddy.pid) .. ")")) and checkForSucc(c.class, daddy.class) then
      c:connect_signal("unmanage", function()
        if daddy then
          on(daddy)
          sync(c, daddy)
        end
      end)

      sync(c, daddy)
      off(daddy)
    end
  end)
end
client.connect_signal("manage", handle)
