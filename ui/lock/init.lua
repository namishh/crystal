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

local label     = wibox.widget {
  markup = "Just Type The Password",
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
        label.markup = "Just Type The Password Here"
      else
        label.markup = "HINT: Caps Lock Is ON"
      end
    end
  )
end

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
        --header:get_children_by_id('arc')[1].colors = { beautiful.blue }
        --header:get_children_by_id('arc')[1].value = 20
        --header:get_children_by_id('arc')[1].start_angle = getRandom()
        if input == nil then
          input = key
          return
        end
        input = input .. key
      elseif key == "BackSpace" then
        --header:get_children_by_id('arc')[1].colors = { beautiful.blue }
        --header:get_children_by_id('arc')[1].value = 20
        --header:get_children_by_id('arc')[1].start_angle = getRandom()
        input = input:sub(1, -2)
        if #input == 0 then
          --header:get_children_by_id('arc')[1].colors = { beautiful.magenta }
          --header:get_children_by_id('arc')[1].value = 100
        end
      end
    end,
    keyreleased_callback = function(self, _, key, _)
      -- Validation
      if key == 'Return' then
        if auth(input) then
          self:stop()
          visible(false)
          input = ""
        else
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

local overlay = wibox.widget {
  widget = wibox.container.background,
  forced_height = 1080,
  forced_width = 1920,
  bg = {
    type = "linear",
    from = { 0, 0 },
    to = { 1920, 0 },
    stops = { { 0, beautiful.bg .. "dd" }, { 0.4, beautiful.bg .. "cc" }, { 1, beautiful.bg .. '33' } }
  },
}

background:setup {
  back,
  overlay,
  layout = wibox.layout.stack
}

check_caps()
