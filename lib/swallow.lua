-- documenting my shit because someone thought i write good code
local awful = require("awful")
local helpers = require("helpers")
local dontSuckMe = {} -- this is for classes that you dont want to be swallowed
-- eg local dontSuckMe = {"nemo", "firefox"}

local checkForSucc = function(child, parent)
  local canSuc = false
  if not helpers.inTable(dontSuckMe, child) and parent == "org.wezfurlong.wezterm" and child ~= "org.wezfurlong.wezterm" then -- write the class of your terminal here
    canSuc = true
  end
  return canSuc
end

-- get the terminal window that executed the command maybe
local getDaddy = function(child, cb)
  awful.spawn.easy_async(string.format("pstree -p %s", child), function(output, _, _, _)
    cb(nil, output)
  end)
end

-- this function was straight out ripped from bling
-- from what i understand this basically makes the window focused and on top
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

-- move the parent with the child
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

-- this does the opposite off on() and you guessed it, also copied from bling
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

-- the main implementation
local handle = function(c)
  local daddy = awful.client.focus.history.get(c.screen, 1) -- read the history to get the parent terminal
  if not daddy or daddy.type == "dialog" or daddy.type == "splash" then return end
  getDaddy(c.pid, function(e, pid)
    if (tostring(pid):find("(" .. tostring(daddy.pid) .. ")")) and checkForSucc(c.class, daddy.class) then -- check if the parent exists and the window can be swallowed
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
client.connect_signal("manage", handle) -- executing it
