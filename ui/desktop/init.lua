local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local popup = require("ui.desktop.popup")
local json = require("mods.json")
local beautiful = require("beautiful")


local data = helpers.readJson(gears.filesystem.get_cache_dir() .. "json/settings.json")
local inspect = require("mods.inspect")
local dpi = beautiful.xresources.apply_dpi
local appicons = "/nix/store/3wpdmiaszdpga7sdax0xj37q7kjs6hqs-reversal/share/icons/reversal-dark/"

local foldericons =
"/nix/store/3wpdmiaszdpga7sdax0xj37q7kjs6hqs-reversal/share/icons/reversal-dark/places/48"

local grid = wibox.widget {
  forced_num_rows = 14,
  forced_num_cols = 19,
  orientation = "horizontal",
  layout = wibox.layout.grid
}

local manual = wibox.layout {
  layout = wibox.layout.manual
}

local icons = {
  ["lua"] = "lua",
  ["py"] = "python",
  ["rs"] = "rust",
  ["html"] = "html",
  ["c"] = "c",
  ["c++"] = "c++",
  ["js"] = "javascript",
  ["hs"] = "haskell",
  ['go'] = "go",
  ["php"] = "php",
  ["rb"] = "ruby",
  ["md"] = "markdown",
  ["ts"] = "typescript",
  ["scss"] = "sass",
  ["sass"] = "sass",
  ["java"] = "java",
}

local desktopdisplay = wibox {
  visible = data.showDesktopIcons,
  ontop = false,
  bg = beautiful.bg .. '00',
  type = "desktop",
  screen = s,
  widget = wibox.widget {
    {
      grid,
      margins = dpi(20),
      widget = wibox.container.margin
    },
    manual,
    layout = wibox.layout.stack
  }
}

awful.placement.maximize(desktopdisplay)

local function gen()
  local shortcuts = {}
  local folders = {}
  local files = {}
  local entries = {}

  table.insert(entries,
    { icon = appicons .. "places/48/trash-empty.svg", label = "Trash", exec = "nemo trash:/", type = "general" })
  --  table.insert(entries,
  --    {
  --      icon = gears.filesystem.get_configuration_dir() .. "theme/assets/tsukkisaidmetoaddthis.png",
  --      label = beautiful.user:lower(),
  --      exec = "nemo /home/" .. beautiful.user:lower(),
  --      type = "general"
  --    })
  for entry in io.popen([[ls ~/Desktop | sed '']]):lines() do
    local label = entry
    local exec = nil
    local icon = appicons .. "mimes/48/text-x-generic.svg"
    local ext = label:match("^.+(%..+)$")

    if ext == ".desktop" then
      for line in io.popen("cat ~/Desktop/'" .. entry .. "'"):lines() do
        if line:match("Name=") and label == entry then
          label = line:gsub("Name=", "")
        end
        if line:match("Exec=") and exec == nil then
          local cmd = line:gsub("Exec=", "")
          exec = cmd
        end
        if line:match("CustomIcon=") then
          icon = line:gsub("CustomIcon=", "")
        elseif line:match("Icon=") then
          icon = appicons .. "apps/" .. line:gsub("Icon=", "") .. ".svg"
        end
      end
      table.insert(entries, { icon = icon, label = label, exec = exec, type = "shortcut" })
    elseif os.execute("cd ~/Desktop/'" .. entry .. "'") then
      icon = foldericons .. "/folder.svg"
      exec = "nemo" .. " Desktop/'" .. entry .. "'"
      table.insert(entries, { icon = icon, label = label, exec = exec, type = "folder" })
    elseif os.execute("wc -c < ~/Desktop/'" .. entry .. "'") then
      icon = appicons .. "mimes/48/application-x-zerosize.svg"
      exec = "wezterm -e nvim" .. " ~/Desktop/'" .. entry .. "'"
      if string.match(entry, "%.") then
        local extenstion = helpers.split(entry, ".")
        extenstion = extenstion[#extenstion]
        if extenstion == "jpg" or extenstion == "jpeg" or extenstion == "tiff" or extenstion == "png" or extenstion == "webp" or extenstion == "svg" then
          if extenstion == "jpg" then
            icon = appicons .. "mimes/48/jpg.svg"
          else
            icon = appicons .. "mimes/48/image-" .. extenstion .. ".svg"
          end
          exec = "feh '~/Desktop/" .. entry .. "'"
        elseif extenstion == "mp4" or extenstion == "avif" or extenstion == "webm" or extenstion == "mkv" or extenstion == "mov" then
          icon = appicons .. "mimes/48/media-video.svg"
        elseif extenstion == "mp3" or extenstion == "wav" or extenstion == "flac" or extenstion == "aiff" then
          icon = appicons .. "mimes/48/media-audio.svg"
        elseif icons[extenstion] ~= nil then
          icon = appicons .. "mimes/48/text-x-" .. icons[extenstion] .. ".svg"
        end
      end
      table.insert(entries, { icon = icon, label = label, exec = exec, type = 'file' })
    else
      exec = "xdg-open " .. os.getenv("HOME") .. "/Desktop/'" .. label .. "'"
      table.insert(entries, { icon = icon, label = label, exec = exec, type = 'file' })
    end
  end
  return entries
end

local function save()
  layout = {}

  for i, widget in ipairs(grid.children) do
    local pos = grid:get_widget_position(widget)

    layout[i] = {
      row = pos.row,
      col = pos.col,
      widget = {
        icon = widget.icon,
        label = widget.label,
        exec = widget.exec,
        type = widget.type,
      }
    }
  end

  local w = assert(io.open(".cache/awesome/json/desktop.json", "w"))
  w:write(json.encode(layout, nil, { pretty = true, indent = "	", align_keys = false, array_newline = true }))
  w:close()
end

local function gridindexat(y, x)
  local margin = dpi(30)
  local cellwidth, cellheight = dpi(115), dpi(105)

  local row = math.ceil((y - margin) / cellheight)
  row = math.min(row, 8)
  row = math.max(row, 1)

  local col = math.ceil((x - margin) / cellwidth)
  col = math.min(col, 16)
  col = math.max(col, 1)

  return row, col
end

local function createicon(icon, label, exec, ty)
  local widget = wibox.widget {
    {
      {
        {
          image = icon,
          halign = "center",
          widget = wibox.widget.imagebox
        },
        strategy = "exact",
        width = dpi(50),
        height = dpi(40),
        widget = wibox.container.constraint
      },
      {
        {
          {
            markup = helpers.colorizeText(label, beautiful.fg),
            valign = "top",
            font = beautiful.sans .. " 11",
            align = "center",
            widget = wibox.widget.textbox
          },
          margins = dpi(5),
          widget = wibox.container.margin
        },
        strategy = "max",
        width = dpi(100),
        height = dpi(50),
        widget = wibox.container.constraint
      },
      spacing = dpi(5),
      layout = wibox.layout.fixed.vertical
    },
    icon = icon,
    label = label,
    exec = exec,
    type = ty,
    forced_width = dpi(115),
    forced_height = dpi(105),
    margins = dpi(10),
    widget = wibox.container.margin
  }

  local iconmenu = awful.menu({
    items = {
      { "Open", exec },
      { "Delete", function()
        awful.spawn.with_shell("rm -rf " .. os.getenv("HOME") .. "/Desktop/'" .. label .. "'")
      end },
    }
  })

  awesome.connect_signal("iconmenu::hide", function()
    iconmenu:hide()
  end)

  widget:connect_signal("button::press", function(_, _, _, button)
    if not mousegrabber.isrunning() then
      local heldwidget = wibox.widget {
        {
          {
            image = icon,
            opacity = 0.5,
            halign = "center",
            widget = wibox.widget.imagebox
          },
          strategy = "exact",
          width = dpi(50),
          height = dpi(50),
          widget = wibox.container.constraint
        },
        {
          {
            {
              text = label,
              opacity = 0.5,
              valign = "top",
              align = "center",
              widget = wibox.widget.textbox
            },
            margins = dpi(5),
            widget = wibox.container.margin
          },
          strategy = "max",
          width = dpi(100),
          height = dpi(50),
          widget = wibox.container.constraint
        },
        forced_height = dpi(105),
        forced_width = dpi(100),
        spacing = dpi(5),
        visible = false,
        layout = wibox.layout.fixed.vertical
      }

      local startpos = mouse.coords()
      heldwidget.point = { x = startpos.x, y = startpos.y }
      local oldpos = grid:get_widget_position(widget)
      manual:add(heldwidget)

      mousegrabber.run(function(mouse)
        if (math.abs(mouse.x - startpos.x) > 10 or
              math.abs(mouse.y - startpos.y) > 10) and
            mouse.buttons[1] then
          grid:remove(widget)
          heldwidget.visible = true

          manual:move_widget(heldwidget, {
            x = mouse.x - dpi(50),
            y = mouse.y - dpi(50)
          })
        end

        if not mouse.buttons[1] then
          if button == 1 then
            if heldwidget.visible then
              heldwidget.visible = false

              local newrow, newcol = gridindexat(
                mouse.y,
                mouse.x
              )
              if not grid:get_widgets_at(newrow, newcol) then
                grid:add_widget_at(widget, newrow, newcol)
                save()
              else
                local d = helpers.readJson(gears.filesystem.get_cache_dir() .. "json/desktop.json")
                local elem
                for _, j in ipairs(d) do
                  if j.row == newrow and j.col == newcol then
                    elem = j
                    break
                  end
                end
                if elem.widget.exec:find("nemo Desktop") then
                  if exec ~= "Trash" then
                    os.execute("mv ~/Desktop/'" .. label .. "' ~/Desktop/'" .. elem.widget.label .. "'/'" .. label .. "'")
                  end
                elseif elem.widget.exec:find("nemo trash:/") then
                  if exec ~= "Trash" then
                    os.execute("trash ~/Desktop/'" .. label .. "'")
                  end
                else
                  grid:add_widget_at(widget, oldpos.row, oldpos.col)
                end
              end
            else
              awful.spawn.with_shell(exec)
              manual:reset()
            end
            mousegrabber.stop()
          elseif button == 3 then
            awesome.emit_signal("iconmenu::hide")
            iconmenu:toggle()
            mousegrabber.stop()
          end
        end
        return mouse.buttons[1]
      end, "hand2")
    end
  end)

  return widget
end

local function load()
  local layoutfile = gears.filesystem.get_cache_dir() .. 'json/desktop.json'
  if not gears.filesystem.file_readable(layoutfile) then
    local entries = gen()
    for _, entry in ipairs(entries) do
      grid:add(createicon(entry.icon, entry.label, entry.exec, entry.type))
    end
    save()
    return
  end

  local awmmenu = {
    { "Restart", awesome.restart }
  }

  local createmenu = {
    { "File", function()
      local filename = "New File"
      local filepath = os.getenv("HOME") .. "/Desktop/" .. filename
      local i = 1
      while gears.filesystem.file_readable(filepath) do
        filename = "New File " .. "(" .. i .. ")"
        filepath = os.getenv("HOME") .. "/Desktop/" .. filename
        i = i + 1
      end
      awful.spawn.with_shell("touch '" .. filepath .. "'")
    end },
    { "Folder", function()
      local foldername = "New Folder"
      local folderpath = os.getenv("HOME") .. "/Desktop/" .. foldername
      local i = 1
      while gears.filesystem.dir_readable(folderpath) do
        foldername = "New Folder " .. "(" .. i .. ")"
        folderpath = os.getenv("HOME") .. "/Desktop/" .. foldername
        i = i + 1
      end
      gears.filesystem.make_directories(folderpath)
    end }
  }


  manual:buttons {
    awful.button({}, 1, function()
      awesome.emit_signal("iconmenu::hide")
      awesome.emit_signal("close::menu")
    end),
    awful.button({}, 3, function()
      if mouse.current_widgets[4] == manual then
        awesome.emit_signal("iconmenu::hide")
        awesome.emit_signal("toggle::menu")
      end
    end)
  }

  local r = assert(io.open(".cache/awesome/json/desktop.json", "rb"))
  local t = r:read("*all")
  r:close()
  local layout = json.decode(t)

  for _, entry in ipairs(layout) do
    grid:add_widget_at(createicon(entry.widget.icon, entry.widget.label, entry.widget.exec, entry.type), entry.row,
      entry.col)
  end
end

load()

awesome.connect_signal("signal::desktop", function(type)
  local entries = gen()
  local check = false

  if type == add then
    for _, entry in ipairs(entries) do
      for _, widget in ipairs(grid.children) do
        if entry.label == widget.label then
          check = true
        end
      end
      if check == false then
        grid:add(createicon(entry.icon, entry.label, entry.exec, entry.type))
      end
      check = false
    end
  end

  if type == remove then
    for _, widget in ipairs(grid.children) do
      for _, entry in ipairs(entries) do
        if entry.label == widget.label then
          check = true
        end
      end
      if check == false then
        grid:remove(widget)
      end
      check = false
    end
  end

  save()
end)

local subscribe = [[
   bash -c "
   while (inotifywait -m -e close_write -e delete -e create -e moved_from $HOME/Desktop/ -q) do echo; done
"]]

awful.spawn.easy_async_with_shell(
  "ps x | grep \"inotifywait -m -e close_write -e delete -e create -e moved_from $HOME/Desktop/ -q\" | awk '{print $1}' | xargs kill",
  function()
    awful.spawn.with_line_callback(subscribe, {
      stdout = function(l)
        awesome.emit_signal("signal::desktop")
      end
    })
  end)
