import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import App from 'resource:///com/github/Aylur/ags/app.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

const SettingButton = (label, setup, on_clicked) => Widget.Button({
  class_name: "panel-button",
  label: label,
  on_clicked: on_clicked,
  hpack: "center",
  vpack: "center",
  setup: setup
})

export default () => Widget.Box({
  spacing: 12,
  class_name: "panel-buttons",
  homogeneous: false,
  vertical: false,
  children: [
    SettingButton("󰤨", (self) => {
      self.hook(Network, self => {
        if (Network.wifi.internet == "connected") {
          self.class_name = "panel-buttonactive"
        } else {
          self.class_name = "panel-button"
        }
      })
    }, () => {
      Network.toggleWifi()
    }),

    SettingButton("󰂯", (self) => {
      self.hook(Bluetooth, self => {
        if (Bluetooth.connected) {
          self.class_name = "panel-buttonactive"
        } else {
          self.class_name = "panel-button"
        }
      })
    }, () => {
      Bluetooth.toggle()
    }),

    SettingButton("󰍶", (self) => {
      self.hook(Notifications, self => {
        if (Notifications.dnd) {
          self.class_name = "panel-buttonactive"
        } else {
          self.class_name = "panel-button"
        }
      })
    }, () => {
      Notifications.dnd = !Notifications.dnd
    }),

    SettingButton("󰍬", (self) => {
      self.hook(Audio, self => {
        if (!Audio.microphone?.is_muted) {
          self.class_name = "panel-buttonactive"
        } else {
          self.class_name = "panel-button"
        }
      })
    }, () => {
      Audio.microphone.is_muted = !Audio.microphone?.is_muted
    }),

    Widget.Box({
      class_name: "panel-sep",
      hpack: "center",
      vpack: "center",
    }),

    SettingButton("󰻂", (self) => {
    }, () => {
      let date = new Date().toJSON();
      App.toggleWindow("panel")
      Utils.execAsync(`bash -c 'if pgrep -x "wf-recorder"; then notify-send "Ending Recording" ; pkill wf-recorder ; else notify-send "Starting Recording" ;wf-recorder -g "$(slurp)" -f ~/Videos/Recordings/${date}.mp4 ;fi'`)
    }),

    SettingButton("󰆟", (self) => {
    }, () => {
      let date = new Date().toJSON();
      App.toggleWindow("panel")
      Utils.execAsync(`bash -c 'grim -g "$(slurp)" ~/Pictures/Screenshots/${date}.png ; wl-copy < ~/Pictures/Screenshots/${date}.png'`)
    }),
  ]
})

