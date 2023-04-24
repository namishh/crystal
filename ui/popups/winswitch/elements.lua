local helpers = require("helpers")
local beautiful = require("beautiful")
local wibox = require("wibox")
local getIcon = require("modules.geticon")

return function()
  local elems = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    spacing = 20,
    id = "switcher"
  }

  local curr = 0

  local function createElement(fn)
    fn = fn or ""
    elems:reset()

    local clients = client.get()
    local sortedClients = {}

    if client.focus then
      sortedClients[1] = client.focus
    end

    for _, client in ipairs(clients) do
      if client ~= sortedClients[1] then
        table.insert(sortedClients, client)
      end
    end

    curr = curr
    for _, client in ipairs(sortedClients) do
      local widget = wibox.widget {
        {
          {
            {
              id = "icon",
              forced_height = 70,
              halign = 'center',
              forced_width = 70,
              image = getIcon.get_client_icon_path(client) or client.icon,
              widget = wibox.widget.imagebox
            },
            {
              {
                id = "name",
                halign = 'center',
                text = client.name,
                widget = wibox.widget.textbox
              },
              widget = wibox.container.constraint,
              width = 100,
              height = 18,
            },
            spacing = 5,
            layout = wibox.layout.fixed.vertical,
          },
          widget = wibox.container.margin,
          margins = 20
        },
        forced_height = 135,
        forced_width = 130,
        shape = helpers.rrect(6),
        widget = wibox.container.background,
        bg = beautiful.bg
      }
      elems:add(widget)
    end

    if fn == "next" then
      if curr >= #sortedClients then
        curr = 1
      else
        curr = curr + 1
      end
      for i, element in ipairs(elems.children) do
        if i == curr then
          element.bg = beautiful.mbg
        else
          element.bg = beautiful.bg
        end
      end
    elseif fn == "raise" then
      local c = sortedClients[curr]
      if c ~= nil then
        if not c:isvisible() and c.first_tag then
          c.first_tag:view_only()
        end
        c:emit_signal "request::activate"
        c:raise()
      end
      curr = 0
    end

    return elems
  end

  elems = createElement()

  awesome.connect_signal("winswitch::next", function()
    elems = createElement("next")
  end)

  awesome.connect_signal("winswitch::raise", function()
    elems = createElement("raise")
  end)

  awesome.connect_signal("winswitch::update", function()
    elems = createElement("raise")
  end)

  client.connect_signal("manage", function()
    elems = createElement()
  end)

  client.connect_signal("unmanage", function()
    elems = createElement()
  end)

  return elems
end
