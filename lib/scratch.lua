local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local ruled = require("ruled")


local Scratchpad = { mt = {} } -- scratch init

-- make a new instance of scratchpad
function Scratchpad:new(args)
  local ret = gears.object {}
  gears.table.crush(ret, Scratchpad)
  gears.table.crush(ret, args)
  return ret
end

local findClient = function(rule)
  local function matcher(c)
    return awful.rules.match(c, rule)
  end
  local clients = client.get()
  local findex = gears.table.hasitem(clients, client.focus) or 1
  local start = gears.math.cycle(#clients, findex + 1)

  local matches = {}
  for c in awful.client.iterate(matcher, start) do
    matches[#matches + 1] = c
  end

  return matches
end

function Scratchpad:find()
  return findClient(self.rule)
end

function Scratchpad:become(c)
  if not c or not c.valid then return end
  c.floating = true
  c.sticky = false
  c.fullscreen = false
  c.maximised = false
  c:geometry({
    x = (1920 - self.width) / 2,
    y = (1080 - self.height) / 2,
    width = self.width,
    height = self.height
  })
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

function Scratchpad:on()
  self.client = self:find()[1]
  if not self.client then
    local pid = awful.spawn.with_shell(self.command)
    ruled.client.append_rule({
      id = "scratch",
      rule = self.rule,
      properties = {
        tag = awful.screen.focused().selected_tag,
        switch_to_tags = false,
        hidden = true,
        minimized = true,
      },
      callback = function(c)
        gears.timer({
          timeout = 0.1,
          autostart = true,
          single_shot = true,
          callback = function()
            self.client = c
            self:become(c)
            c.hidden = false
            c.minimized = false

            c:activate({})
            self:emit_signal("inital_apply", c)
            if c.name ~= "Discord Updater" then
              ruled.client.remove_rule("scratch")
            end
            c:connect_signal("request::unmanage", function()
              ruled.client.remove_rule("scratch")
            end)
          end
        })
      end
    })
  else
    self.client:raise()
    client.focus = self.client
    on(self.client)
    self:become(self.client)
  end
end

function turn_off(c)
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

function Scratchpad:off()
  self.client = self:find()[1]
  turn_off(self.client)
end

function Scratchpad:toggle()
  local is_turn_off = client.focus and awful.rules.match(client.focus, self.rule)
  if is_turn_off then
    self:off()
  else
    self:on()
  end
end

function Scratchpad.mt:__call(...)
  return Scratchpad:new(...)
end

local createScratch = function(command, width, height, k)
  local scratch = Scratchpad:new {
    --command = 'kitty' .. ' --class "' .. command .. 'pad" -e sh -c "' .. command .. '; $SHELL"',
    command = 'wezterm start --class ' .. command .. 'pad -e sh -c "' .. command .. '; $SHELL"',
    rule = { class = command .. 'pad' },
    height = height,
    width = width,
  }
  awful.keyboard.append_global_keybindings {
    awful.key {
      modifiers   = { "Mod4" },
      key         = k,
      description = 'show help',
      group       = 'awesome',
      on_press    = function() scratch:toggle() end,
    },
  }
  awesome.connect_signal("toggle::" .. command .. "pad", function()
    scratch:toggle()
  end)
  return scratch
end

local default = createScratch("neofetch", 1000, 650, 'v')
local ncmpcpp = createScratch("ncmpcpp", 800, 500, 'z')
