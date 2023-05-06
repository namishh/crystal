local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local lockscreen = {}
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
      id = "arc",
      widget = wibox.container.arcchart,
      max_value = 100,
      min_value = 0,
      value = 0,
      rounded_edge = true,
      thickness = dpi(10),
      start_angle = 4.71238898,
      bg = beautiful.fg,
      colors = { beautiful.fg },
      forced_width = dpi(200),
      forced_height = dpi(200)
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


  local promptbox = wibox {
    width = dpi(500),
    height = dpi(500),
    bg = beautiful.bg .. '00',
    ontop = true,
    visible = false
  }

  local background = wibox({
    width = dpi(beautiful.scrwidth),
    height = dpi(beautiful.scrheight),
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
    entered = 0
    header:get_children_by_id('arc')[1].value = not f and 100 or 0
    header:get_children_by_id('arc')[1].colors = { not f and beautiful.err or beautiful.fg }
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
        header:get_children_by_id('arc')[1].colors = { beautiful.pri }
        header:get_children_by_id('arc')[1].value = 25
        header:get_children_by_id('arc')[1].start_angle = tonumber(string.format("%.8f", math.random(0, math.pi * 2)))
        if #key == 1 then
          entered = entered + 1
        elseif key == "BackSpace" then
          if entered > 0 then
            entered = entered - 1
          end
        end
      end,
      exe_callback = function(input)
        if lockscreen.auth(input) then
          icon.markup = symbol
          reset(true)
          visible(false)
        else
          header:get_children_by_id('arc')[1].colors = { beautiful.err }
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
    {
      widget = wibox.widget.imagebox,
      forced_height = beautiful.scrheight,
      horizontal_fit_policy = "fit",
      vertical_fit_policy = "fit",
      forced_width = beautiful.scrwidth,
      image = beautiful.blurwall,
    },
    layout = wibox.layout.stack
  }
  promptbox:setup {
    {
      {
        markup = helpers.colorizeText(os.date("%H:%M"), beautiful.fg),
        font = beautiful.sans .. " Bold 82",
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox,
      },
      header,
      {
        {
          markup = helpers.colorizeText("Namish Pande", beautiful.fg),
          font = beautiful.sans .. " Semibold 16",
          align = 'center',
          valign = 'center',
          widget = wibox.widget.textbox,
        },
        top = 10,
        widget = wibox.container.margin
      },
      spacing = 10,
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
