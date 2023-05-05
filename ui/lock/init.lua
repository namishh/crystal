local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local lockscreen = {}
--local passwd = config.password
function lockscreen:init()
  local pam = require("liblua_pam")
  lockscreen.auth = function(password)
    return pam.auth_current_user(password)
  end


  local symbol = "󰌾"
  local entered = 0

  local header = wibox.widget {
    {
      {
        image         = beautiful.profilepicture,
        clip_shape    = helpers.rrect(100),
        forced_height = 200,
        forced_width  = 200,
        halign        = 'center',
        widget        = wibox.widget.imagebox
      },
      widget = wibox.container.background,
      border_width = dpi(10),
      forced_width = dpi(210),
      forced_height = dpi(210),
      shape = helpers.rrect(100),
      border_color = beautiful.fg_color
    },
    widget = wibox.container.place,
    halign = 'center',
  }

  local icon = wibox.widget {
    markup = symbol,
    font = beautiful.icofont .. " 16",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  }

  local prompt = wibox.widget {
    forced_width = 380,
    forced_height = 40,
    markup = "Enter Password",
    font = beautiful.font .. " 16",
    widget = wibox.widget.textbox,
  }

  local promptbox = wibox {
    width = dpi(500),
    height = dpi(405),
    bg = beautiful.bg .. '00',
    ontop = true,
    visible = false
  }

  local background = wibox({
    bgimage = beautiful.wall,
    visible = false,
    ontop = true,
    type = "splash"
  })

  awful.placement.maximize(background)

  local visible = function(v)
    background.visible = v
    promptbox.visible = v
  end

  local reset = function(f)
    entered = 0
    prompt.markup = not f and "Wrong" or "Enter Password"
  end

  local function grab()
    awful.prompt.run {
      hooks = {
        { {}, 'Escape', function(_)
          reset(true)
          grab()
        end
        },
        { {}, 'Control', function(_)
          reset(true)
          grab()
        end
        }
      },
      keypressed_callback = function(_, key, _)
        if #key == 1 then
          entered = entered + 1
          prompt.markup = string.rep("•", entered)
        elseif key == "BackSpace" then
          if entered > 0 then
            entered = entered - 1
          end
          prompt.markup = string.rep("•", entered)
        end
      end,
      exe_callback = function(input)
        if lockscreen.auth(input) then
          icon.markup = symbol
          reset(true)
          visible(false)
        else
          icon.markup = helpers.colorizeText(symbol, beautiful.err)
          reset(false)
          grab()
        end
      end,
      textbox = wibox.widget.textbox(),
    }
  end


  awesome.connect_signal("toggle::lock", function()
    visible(true)
    grab()
  end)

  background:setup {
    layout = wibox.container.place
  }
  promptbox:setup {
    {
      header,
      {
        {
          {
            {
              {
                prompt,
                left = dpi(10),
                widget = wibox.container.margin
              },
              forced_height = 50,
              shape = helpers.rrect(6),
              widget = wibox.container.background,
              bg = beautiful.bg .. "cc",
            },
            {
              {
                {
                  icon,
                  left = 15,
                  right = 15,
                  widget = wibox.container.margin
                },
                shape = helpers.rrect(6),
                widget = wibox.container.background,
                bg = beautiful.bg .. "cc",
              },
              widget = wibox.container.margin,
            },
            spacing = 20,
            layout = wibox.layout.fixed.horizontal,
          },
          widget = wibox.container.background
        },
        widget = wibox.container.margin
      },
      spacing = 30,
      layout = wibox.layout.fixed.vertical
    },
    margins = dpi(10),
    widget = wibox.container.margin
  }

  awful.placement.centered(
    promptbox
  )
end

lockscreen:init()

return lockscreen
