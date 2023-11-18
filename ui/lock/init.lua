local wibox     = require("wibox")
local helpers   = require("helpers")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local pam       = require("liblua_pam")
local gears     = require("gears")
local auth      = function(password)
  return pam.auth_current_user(password)
end

local header    = wibox.widget {
  {
    {
      image         = beautiful.pfp,
      clip_shape    = helpers.rrect(100),
      forced_height = 180,
      opacity       = 1,
      forced_width  = 180,
      halign        = 'center',
      widget        = wibox.widget.imagebox
    },
    id = "arc",
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    value = 0,
    rounded_edge = false,
    thickness = dpi(8),
    start_angle = 4.71238898,
    bg = beautiful.fg,
    colors = { beautiful.fg },
    forced_width = dpi(180),
    forced_height = dpi(180)
  },
  widget = wibox.container.place,
  halign = 'center',
}
local label     = wibox.widget {
  markup = "Type The Password",
  valign = "center",
  halign = "center",
  id     = "name",
  font   = beautiful.sans .. " 14",
  widget = wibox.widget.textbox,
}



local check_caps = function()
  awful.spawn.easy_async_with_shell(
    'xset q | grep Caps | cut -d: -f3 | cut -d0 -f1 | tr -d \' \'',
    function(stdout)
      if stdout:match('off') then
        label.markup = "Type The Password Here"
      else
        label.markup = "HINT: Caps Lock Is ON"
      end
    end
  )
end


local promptbox = wibox {
  width = dpi(900),
  height = dpi(800),
  bg = beautiful.mbg .. "00",
  ontop = true,
  shape = helpers.rrect(10),
  visible = false
}

local background = wibox({
  width = dpi(1920),
  height = dpi(1080),
  visible = false,
  ontop = true,
  type = "splash"
})



awful.placement.centered(background)

local visible = function(v)
  background.visible = v
  promptbox.visible = v
end

local reset = function(f)
  header:get_children_by_id('arc')[1].value = not f and 100 or 0
  header:get_children_by_id('arc')[1].colors = { not f and beautiful.red or beautiful.fg }
end

local getRandom = function()
  local r = math.random(0, 628)
  r = r / 100
  return r
end

local input = ""
local function grab()
  local grabber = awful.keygrabber {
    auto_start           = true,
    stop_event           = 'release',
    mask_event_callback  = true,
    keybindings          = {
      awful.key {
        modifiers = { 'Mod1', 'Mod4', 'Shift', 'Control' },
        key       = 'Return',
        on_press  = function(_)
          input = input
        end
      }
    },
    keypressed_callback  = function(_, _, key, _)
      if key == 'Escape' then
        input = ""
        return
      end
      -- Accept only the single charactered key
      -- Ignore 'Shift', 'Control', 'Return', 'F1', 'F2', etc., etc.
      if #key == 1 then
        header:get_children_by_id('arc')[1].colors = { beautiful.blue }
        header:get_children_by_id('arc')[1].value = 20
        header:get_children_by_id('arc')[1].start_angle = getRandom()
        if input == nil then
          input = key
          return
        end
        input = input .. key
      elseif key == "BackSpace" then
        header:get_children_by_id('arc')[1].colors = { beautiful.blue }
        header:get_children_by_id('arc')[1].value = 20
        header:get_children_by_id('arc')[1].start_angle = getRandom()
        input = input:sub(1, -2)
        if #input == 0 then
          header:get_children_by_id('arc')[1].colors = { beautiful.magenta }
          header:get_children_by_id('arc')[1].value = 100
        end
      end
    end,
    keyreleased_callback = function(self, _, key, _)
      -- Validation
      if key == 'Return' then
        if auth(input) then
          self:stop()
          reset(true)
          visible(false)
          input = ""
        else
          header:get_children_by_id('arc')[1].colors = { beautiful.red }
          reset(false)
          grab()
          input = ""
        end
      elseif key == 'Caps_Lock' then
        check_caps()
      end
    end
  }
  grabber:start()
end


awesome.connect_signal("toggle::lock", function()
  visible(true)
  grab()
end)

local back = wibox.widget {
  id = "bg",
  image = beautiful.wallpaper,
  widget = wibox.widget.imagebox,
  forced_height = 1080,
  horizontal_fit_policy = "fit",
  vertical_fit_policy = "fit",
  forced_width = 1920,
}

local makeImage = function()
  local cmd = 'convert ' ..
      beautiful.wallpaper .. ' -filter Gaussian -blur 0x6 ~/.cache/awesome/lock.jpg'
  awful.spawn.easy_async_with_shell(cmd, function()
    local blurwall = gears.filesystem.get_cache_dir() .. "lock.jpg"
    back.image = blurwall
  end)
end

makeImage()

local overlay = wibox.widget {
  widget = wibox.container.background,
  forced_height = 1080,
  forced_width = 1920,
  bg = beautiful.bg .. "c1"
}
background:setup {
  back,
  overlay,
  layout = wibox.layout.stack
}


promptbox:setup {
  {
    {
      {
        {
          {
            font = beautiful.sans .. " Medium 110",
            format = "%H:%M",
            halign = "center",
            valign = "center",
            widget = wibox.widget.textclock
          },
          {
            font = beautiful.sans .. " Light 28",
            format = "%a, %d %B",
            halign = "center",
            valign = "center",
            widget = wibox.widget.textclock
          },
          {
            label,
            widget = wibox.container.margin,
            top = 50
          },
          spacing = 10,
          layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.place,
        valign = "center",
      },
      nil,
      header,
      layout = wibox.layout.align.vertical
    },
    margins = dpi(30),
    widget = wibox.container.margin
  },
  widget = wibox.container.background,
  shape = helpers.rrect(20)
}
awful.placement.centered(
  promptbox
)

check_caps()
