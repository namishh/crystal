local awful      = require('awful')

local mod        = require('binds.mod')
local modkey     = mod.modkey

local apps       = require('config.apps')
local widgets    = require('ui')

local volume     = require "lib.volume"
local brightness = require "lib.brightness"


--- Global key bindings
awful.keyboard.append_global_keybindings({
  -- General Awesome keys.
  awful.key({}, "XF86MonBrightnessUp", function()
    brightness.increase()
    awesome.emit_signal("open::osdb")
  end),

  awful.key({}, "Print", function()
    awful.spawn.with_shell("maim -s -u | xclip -selection clipboard -t image/png")
  end),

  awful.key({ mod.shift }, "Print", function()
    awful.spawn.with_shell("maim -u | xclip -selection clipboard -t image/png")
  end),

  awful.key({ modkey, }, "p",
    function(c)
      awesome.emit_signal("toggle::launcher")
    end),
  awful.key({ modkey, }, "d",
    function(c)
      awesome.emit_signal("toggle::dash")
    end),

  awful.key({ modkey, }, "x",
    function(c)
      awesome.emit_signal("toggle::lock")
    end),

  awful.key({}, "XF86MonBrightnessDown", function()
    brightness.decrease()
    awesome.emit_signal("open::osdb")
  end),
  awful.key({}, "XF86AudioRaiseVolume", function()
    volume.increase()
    awesome.emit_signal("open::osd")
  end),
  awful.key({}, "XF86AudioMute", function()
    volume.mute()
    awesome.emit_signal("open::osd")
  end),
  awful.key({}, "XF86AudioLowerVolume", function()
    volume.decrease()
    awesome.emit_signal("open::osd")
  end),


  awful.key({ modkey, }, 's', require('awful.hotkeys_popup').show_help,
    { description = 'show help', group = 'awesome' }),
  awful.key({ modkey, }, 'w', function() widgets.menu.main:show() end,
    { description = 'show main menu', group = 'awesome' }),
  awful.key({ modkey, mod.ctrl }, 'r', awesome.restart,
    { description = 'reload awesome', group = 'awesome' }),
  awful.key({ modkey, mod.shift }, 'q', awesome.quit,
    { description = 'quit awesome', group = 'awesome' }),
  awful.key({ modkey, }, 'Return', function() awful.spawn(apps.terminal) end,
    { description = 'open a terminal', group = 'launcher' }),

  -- Tags related keybindings.
  awful.key({ modkey, }, 'Left', awful.tag.viewprev,
    { description = 'view previous', group = 'tag' }),
  awful.key({ modkey, }, 'Right', awful.tag.viewnext,
    { description = 'view next', group = 'tag' }),
  awful.key({ modkey, }, 'Escape', awful.tag.history.restore,
    { description = 'go back', group = 'tag' }),

  -- Focus related keybindings.
  awful.key({ modkey, }, 'j', function() awful.client.focus.byidx(1) end,
    { description = 'focus next by index', group = 'client' }),
  awful.key({ modkey, }, 'k', function() awful.client.focus.byidx(-1) end,
    { description = 'focus previous by index', group = 'client' }),
  awful.key({ modkey, }, 'Tab', function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = 'go back', group = 'client' }),
  awful.key({ modkey, mod.ctrl }, 'j', function() awful.screen.focus_relative(1) end,
    { description = 'focus the next screen', group = 'screen' }),
  awful.key({ modkey, mod.ctrl }, 'k', function() awful.screen.focus_relative(-1) end,
    { description = 'focus the previous screen', group = 'screen' }),
  awful.key({ modkey, mod.ctrl }, 'n', function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:activate { raise = true, context = 'key.unminimize' }
    end
  end, { description = 'restore minimized', group = 'client' }),

  -- Layout related keybindings.
  awful.key({ modkey, mod.shift }, 'j', function() awful.client.swap.byidx(1) end,
    { description = 'swap with next client by index', group = 'client' }),
  awful.key({ modkey, mod.shift }, 'k', function() awful.client.swap.byidx(-1) end,
    { description = 'swap with previous client by index', group = 'client' }),
  awful.key({ modkey, }, 'u', awful.client.urgent.jumpto,
    { description = 'jump to urgent client', group = 'client' }),
  awful.key({ modkey, }, 'l', function() awful.tag.incmwfact(0.05) end,
    { description = 'increase master width factor', group = 'layout' }),
  awful.key({ modkey, }, 'h', function() awful.tag.incmwfact(-0.05) end,
    { description = 'decrease master width factor', group = 'layout' }),
  awful.key({ modkey, mod.shift }, 'h', function() awful.tag.incnmaster(1, nil, true) end,
    { description = 'increase the number of master clients', group = 'layout' }),
  awful.key({ modkey, mod.shift }, 'l', function() awful.tag.incnmaster(-1, nil, true) end,
    { description = 'decrease the number of master clients', group = 'layout' }),
  awful.key({ modkey, mod.ctrl }, 'h', function() awful.tag.incncol(1, nil, true) end,
    { description = 'increase the number of columns', group = 'layout' }),
  awful.key({ modkey, mod.ctrl }, 'l', function() awful.tag.incncol(-1, nil, true) end,
    { description = 'decrease the number of columns', group = 'layout' }),
  awful.key({ modkey, }, 'space', function() awful.layout.inc(1) end,
    { description = 'select next', group = 'layout' }),
  awful.key({ modkey, mod.shift }, 'space', function() awful.layout.inc(-1) end,
    { description = 'select previous', group = 'layout' }),
  awful.key({
    modifiers   = { modkey },
    keygroup    = 'numrow',
    description = 'only view tag',
    group       = 'tag',
    on_press    = function(index)
      local tag = awful.screen.focused().tags[index]
      if tag then tag:view_only() end
    end
  }),
  awful.key({
    modifiers   = { modkey, mod.ctrl },
    keygroup    = 'numrow',
    description = 'toggle tag',
    group       = 'tag',
    on_press    = function(index)
      local tag = awful.screen.focused().tags[index]
      if tag then awful.tag.viewtoggle(tag) end
    end
  }),
  awful.key({
    modifiers   = { modkey, mod.shift },
    keygroup    = 'numrow',
    description = 'move focused client to tag',
    group       = 'tag',
    on_press    = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then client.focus:move_to_tag(tag) end
      end
    end
  }),
  awful.key({
    modifiers   = { modkey, mod.ctrl, mod.shift },
    keygroup    = 'numrow',
    description = 'toggle focused client on tag',
    group       = 'tag',
    on_press    = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then client.focus:toggle_tag(tag) end
      end
    end
  }),
  awful.key({
    modifiers   = { modkey },
    keygroup    = 'numpad',
    description = 'select layout directly',
    group       = 'layout',
    on_press    = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end
  })
})
