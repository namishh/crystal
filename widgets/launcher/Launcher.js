import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'

import Weather from "./mods/Weather.js"
import AppLauncher from "./mods/AppLauncher.js"
import Music from "./mods/Music.js"
import Sites from "./mods/Sites.js"

const left = () => Widget.Box({
  class_name: "launcher-left",
  homogeneous: false,
  spacing: 12,
  vertical: true,
  vpack: "fill",
  vexpand: true,
  children: [
    Widget.Box({
     class_name: "launcher-left",
      homogeneous: false,
      spacing: 30,
      vertical: true,
      vpack: "end",
      vexpand: true,
      children: [

        Widget.Button({
          child: Widget.Label({
            class_name: 'launcher-exit',
            label: "󰐥",
            vpack: "center",
          }),
          on_clicked: () => {
            exec("poweroff")
          }
        }),
        Widget.Button({
          child: Widget.Label({
            class_name: 'launcher-exit',
            label: "󰦛",
            vpack: "center",
          }),
          on_clicked: () => {
            exec("reboot")
          }
        }),
        Widget.Button({
          child: Widget.Label({
            class_name: 'launcher-exit',
            label: "󰌾",
            vpack: "center",
          }),
          on_clicked: () => {
            App.toggleWindow("launcher")
            exec("waylock")
          }
        }),
        Widget.Box({
          class_name: "launcher-pfp",
          css: `background-image: url('${App.configDir}/assets/pfp.png');background-size: cover;`
        }),
      ],
    }),

  ]
})


const right = () => Widget.Box({
  class_name: "launcher-right",
  homogeneous: false,
  vertical: true,
  children: [
    Weather(),
    Sites(),
    Music(),
  ]
})
const box = Widget.Box({
  class_name: "launcher",
  homogeneous: false,
  vertical: false,
  children: [
    left(),
    AppLauncher(),
    right(),
  ]
})

const launcher = Widget.Window({
  name: 'launcher',
  popup: true,
  visible: false,
  focusable: true,
  anchor: ['top', 'left'],
  margins: [10, 10],
  child: box,
})

export { launcher }
