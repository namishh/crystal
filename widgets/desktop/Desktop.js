import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import { CurrentTheme } from '../../variables.js';

import Icons from './mods/Icons.js';
import Greeter from './mods/Greeter.js';

const Item = (label, icon, on_activate) =>
  Widget.MenuItem({
    class_name: "rm-entry",
    on_activate,
    child: Widget.Box({
      spacing: 10,
      hpack: "start",
      children: [
        Widget.Icon({ icon, class_name: "rm-icon" }),
        Widget.Label({
          label,
          hexpand: true,
          xalign: 0,
          class_name: "rm-label",
        }),
      ],
    }),
  });


const Box = Widget.EventBox({
  onSecondaryClick: (_, event) => {
    return Widget.Menu({
      children: [
        Item("Terminal", "org.wezfurlong.wezterm", () => {
          Utils.exec("wezterm & disown")
        }),
        Item("Open In Desktop", "org.wezfurlong.wezterm", () => {
          Utils.exec("wezterm -e sh -c 'cd ~/Desktop ; zsh'")
        }),
        Item("Open In Desktop", "nemo", () => {
          Utils.exec("nemo Desktop")
        }),
        Item("Firefox", "firefox", () => {
          Utils.exec("firefox & disown")
        }),
        Item("Music Pad", "deepin-music-player", () => {
          Utils.exec("swayscratch smusicpad & disown")
        }),
        Item("Scratch Pad", "terminal", () => {
          Utils.exec("swayscratch spad & disown")
        }),
        Item("Launcher", "view-app-grid-symbolic", () => {
          App.toggleWindow("launcher")
        }),
        Widget.MenuItem({
          class_name: "rm-entry",
          child: Widget.Box({
            spacing: 10,
            children: [
              Widget.Icon({ icon: "system-shutdown-symbolic", class_name: "rm-icon" }),
              Widget.Label({
                label: "System",
                hexpand: true,
                xalign: 0,
                class_name: "label"
              }),
            ],
          }),
          submenu: Widget.Menu({
            children: [
              Item("Shutdown", "system-shutdown-symbolic", () =>
                Utils.exec("shutdown")),
              Item("Reboot", "system-reboot-symbolic", () =>
                Utils.exec("reboot")),
              Item("Logout", "system-log-out-symbolic", () =>
                Utils.exec("swaymsg exit")),
            ],
          }),
        }),
      ],
    }).popup_at_pointer(event)
  },
  child: Widget.Overlay({
    overlays: [Greeter(), Icons(),],
    child: Widget.Box({
      class_name: "bgbox",
      child: Widget.Box({
        class_name: 'bgoverlay',
        setup: (self) => {
          self.hook(CurrentTheme, (self) => {
            self.css = `background: url('/home/namish/.wallpapers/${CurrentTheme.value.trim()}.jpg');background-size: cover;background-repeat: no-repeat; background-position: center;`
          })
        }
      }),
    })
  })
}
)
export const desktop = Widget.Window({
  name: 'bgoverlay',
  visible: true,
  layer: "bottom",
  popup: false,
  focusable: false,
  anchor: ["top", "left"],
  child: Box,
})
