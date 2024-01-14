import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';


const updateNetworkIcon = () => {
  if (Network.wifi.internet == "connected") return "󰤨"
  return "󰤯"
}
const updateBluetooth = () => {
  if (Bluetooth.connected) return "󰂯"
  return "󰂲"
}

const WifiIndicator = () => Widget.Box({
  homogeneous: false,
  vertical: false,
  hpack: "center",
  children: [
    Widget.Label({
      class_name: "icon",
      label: updateNetworkIcon(),
      setup: self => {
        self.hook(Network, (self) => {
          self.label = updateNetworkIcon()
        })
      },
    }),
  ],
})


const Blooey = () => Widget.Box({
  homogeneous: false,
  vertical: false,
  hpack: "center",
  children: [
    Widget.Label({
      class_name: "icon",
      label: updateBluetooth(),
      setup: self => {
        self.hook(Bluetooth, (self) => {
          self.label = updateBluetooth()
        })
      },
    }),
  ],
})

const IconBox = () => Widget.Box({
  spacing: 12,
  homogeneous: false,
  class_name: "bar-icons",
  vertical: true,
  setup: async b => {
    b.children = [Blooey(), WifiIndicator()]
  }
})

const batteryProgress = Widget.ProgressBar({
  value: Battery.bind('percent').transform(p => p > 0 ? p / 100 : 0),
  vertical: true,
  hexpand: true,
  inverted: true,
  hpack: "center",
  class_name: "bar-battery-prog",
});

const Bat = () => Widget.Box({
  spacing: 2,
  class_name: "bar-battery",
  homogeneous: false,
  vertical: true,
  children: [
    Widget.Box({
      class_name: "bar-battery-bulb",
      hpack: "center",
      vpack: "center",
      hexpand: false,
    })
    ,
    batteryProgress
  ]
})

export default () => Widget.Button({
  on_clicked: () => {
    App.toggleWindow("panel")
  },
  child: Widget.Box({
    spacing: 12,
    class_name: "status",
    homogeneous: false,
    vertical: true,
    setup: async b => {
      b.children = [IconBox(), Bat()]
    }
  })
});
