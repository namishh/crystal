local wibox     = require("wibox")
local awful     = require("awful")
local gears     = require("gears")
local Gio       = require("lgi").Gio
local iconTheme = require("lgi").require("Gtk", "3.0").IconTheme.get_default()
local beautiful = require("beautiful")
local gfs       = require("gears.filesystem")
local helpers   = require("helpers")
local animation = require("modules.animation")
local dpi       = beautiful.xresources.apply_dpi

-- Widgets

awful.screen.connect_for_each_screen(function(s)
  local launcherdisplay = wibox {
    width = dpi(800),
    shape = helpers.rrect(8),
    height = dpi(570),
    bg = beautiful.bg,
    ontop = true,
    visible = false
  }

  local slide = animation:new({
    duration = 0.6,
    pos = 0 - launcherdisplay.height,
    easing = animation.easing.inOutExpo,
    update = function(_, pos)
      launcherdisplay.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43,
    callback = function()
      launcherdisplay.visible = false
    end,
  })

  local prompt = wibox.widget {
    {
      {
        {
          id = "txt",
          font = beautiful.font .. " 15",
          widget = wibox.widget.textbox,
        },
        widget = wibox.container.margin,
        margins = 20,
      },
      widget = wibox.container.background,
      bg = beautiful.bg
    },
    widget = wibox.container.margin,
  }

  local entries = wibox.widget {
    homogeneous = false,
    expand = false,
    forced_num_cols = 1,
    spacing = 4,
    layout = wibox.layout.grid
  }
  local image = wibox.widget {
    id = "boximage",
    widget = wibox.widget.imagebox,
    forced_height = 570,
    horizontal_fit_policy = "fill",
    vertical_fit_policy = "fill",
    forced_width = 380,
    image = gears.filesystem.get_configuration_dir() .. "/theme/pics/menu-" .. beautiful.name .. ".png",
  }

  local check_exits = function(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
  end
  local makeImage = function()
    if not check_exits("~/.cache/awesome/menu/" .. require("theme.colors").ow) then
      os.execute("mkdir -p ~/.cache/awesome/menu/")
      local cmd = 'convert ' ..
          beautiful.wall ..
          ' -crop 380x570+600+410 -modulate 70 ~/.cache/awesome/menu/' ..
          require('theme.colors')
          .ow
      awful.spawn.easy_async_with_shell(cmd, function()
        local blurwall = gfs.get_cache_dir() .. "menu/" .. require('theme.colors').ow
        image.image = blurwall
      end)
    else
      local blurwall = gfs.get_cache_dir() .. "menu/" .. require('theme.colors').ow
      image.image = blurwall
    end
  end
  makeImage()
  launcherdisplay:setup {
    {
      image,
      {
        {
          widget = wibox.widget.textbox,
        },
        bg = {
          type = "linear",
          from = { 0, 0 },
          to = { 0, 500 },
          stops = { { 0.2, beautiful.bg .. "22" }, { 1, beautiful.mbg } }
        },
        widget = wibox.container.background,
      },
      {
        {
          {
            {
              prompt,
              forced_width = 380,
              forced_height = 60,
              widget = wibox.container.background,
            },
            widget = wibox.container.margin,
            margins = 10,
          },
          widget = wibox.container.place,
          valign = 'bottom',
        },
        widget = wibox.container.background,
        fo9ced_height = 570,
        forced_width = 380,
      },
      layout = wibox.layout.stack
    },
    {
      entries,
      left = 10,
      right = 10,
      bottom = 10,
      top = 10,
      widget = wibox.container.margin
    },
    spacing = 0,
    layout = wibox.layout.fixed.horizontal
  }

  -- Functions

  local function next(entries)
    if index_entry ~= #filtered then
      index_entry = index_entry + 1
      if index_entry > index_start + 5 then
        index_start = index_start + 1
      end
    end
  end

  local function back(entries)
    if index_entry ~= 1 then
      index_entry = index_entry - 1
      if index_entry < index_start then
        index_start = index_start - 1
      end
    end
  end

  local function gen()
    local entries = {}
    for _, entry in ipairs(Gio.AppInfo.get_all()) do
      if entry:should_show() then
        local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
        local icon = entry:get_icon()
        local path
        if icon then
          path = icon:to_string()
          if not path:find("/") then
            local icon_info = iconTheme:lookup_icon(path, dpi(48), 0)
            local p = icon_info and icon_info:get_filename()
            path = p
          end
        end
        table.insert(
          entries,
          { name = name, appinfo = entry, icon = path or '' }
        )
      end
    end
    return entries
  end

  local function filter(cmd)
    filtered = {}
    regfiltered = {}

    -- Filter entries

    for _, entry in ipairs(unfiltered) do
      if entry.name:lower():sub(1, cmd:len()) == cmd:lower() then
        table.insert(filtered, entry)
      elseif entry.name:lower():match(cmd:lower()) then
        table.insert(regfiltered, entry)
      end
    end

    -- Sort entries

    table.sort(filtered, function(a, b) return a.name:lower() < b.name:lower() end)
    table.sort(regfiltered, function(a, b) return a.name:lower() < b.name:lower() end)

    -- Merge entries

    for i = 1, #regfiltered do
      filtered[#filtered + 1] = regfiltered[i]
    end

    -- Clear entries

    entries:reset()

    -- Add filtered entries

    for i, entry in ipairs(filtered) do
      local widget = wibox.widget {
        {
          {
            {
              image = entry.icon,
              clip_shape = helpers.rrect(10),
              forced_height = dpi(42),
              forced_width = dpi(42),
              valign = 'center',
              widget = wibox.widget.imagebox
            },
            {
              markup = entry.name,
              font = beautiful.font .. " 12",
              widget = wibox.widget.textbox
            },
            spacing = 20,
            layout = wibox.layout.fixed.horizontal,
          },
          margins = dpi(15),
          widget = wibox.container.margin
        },
        forced_width = 400,
        forced_height = 90,
        widget = wibox.container.background
      }

      if index_start <= i and i <= index_start + 5 then
        entries:add(widget)
      end

      if i == index_entry then
        widget.bg = beautiful.mbg
      end
    end

    -- Fix position

    if index_entry > #filtered then
      index_entry, index_start = 1, 1
    elseif index_entry < 1 then
      index_entry = 1
    end

    collectgarbage("collect")
  end

  local function open()
    -- Reset index and page

    index_start, index_entry = 1, 1

    -- Get entries

    unfiltered = gen()
    filter("")

    -- Prompt

    awful.prompt.run {
      prompt = "Launch: ",
      textbox = prompt:get_children_by_id('txt')[1],
      done_callback = function()
        slide_end:again()
        slide:set(0 - launcherdisplay.height)
      end,
      changed_callback = function(cmd)
        filter(cmd)
      end,
      exe_callback = function(cmd)
        local entry = filtered[index_entry]
        if entry then
          entry.appinfo:launch()
        else
          awful.spawn.with_shell(cmd)
        end
      end,
      keypressed_callback = function(_, key)
        if key == "Down" then
          next(entries)
        elseif key == "Up" then
          back(entries)
        end
      end
    }
  end

  awesome.connect_signal("toggle::launcher", function()
    open()

    if launcherdisplay.visible then
      awful.keyboard.emulate_key_combination({}, "Escape")
      slide_end:again()
      slide:set(0 - launcherdisplay.height)
    elseif not launcherdisplay.visible then
      slide:set(beautiful.scrheight / 2 - launcherdisplay.height / 2)
      launcherdisplay.visible = true
    end

    awful.placement.centered(
      launcherdisplay,
      {
        parent = awful.screen.focused()
      }
    )
  end)
end)
