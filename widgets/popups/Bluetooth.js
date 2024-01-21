import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js'
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';

const DeviceItem = device => Widget.Box({
  spacing: 20,
  children: [
    Widget.Icon({ icon: device.icon_name + '-symbolic', size: 18 }),
    Widget.Label(device.name),
    Widget.Label({
      label: `${device.battery_percentage}%`,
      class_names: ["popuppanel-label"],
      visible: device.bind('battery_percentage').transform(p => p > 0),
    }),
    Widget.Box({ hexpand: true }),
    Widget.Spinner({
      active: device.bind('connecting'),
      visible: device.bind('connecting'),
    }),
    Widget.Switch({
      active: device.connected,
      visible: device.bind('connecting').transform(p => !p),
      setup: self => self.on('notify::active', () => {
        device.setConnection(self.active);
      }),
    }),
  ],
});

const box = () => Widget.Box({
  class_names: ["popuppanel", "popuppanel-bluetooth"],
  spacing: 20,
  vertical: true,
  children: [
    Widget.CenterBox({
      start_widget: Widget.Label({ hpack: "start", label: "Bluetooth", class_name: "popuppanel-title" }),
      end_widget: Widget.Button({ hpack: "end", label: "󰅖", class_names: ["popuppanel-close", "icon"], on_clicked: () => App.closeWindow("bluetoothmenu") })
    }),

    // Actual menu from here
    Widget.Scrollable({
      vscroll: 'always',
      hscroll: 'never',
      vexpand: true,
      class_name: 'popuppanel-scroll',
      child: Widget.Box({
        vertical: true,
        spacing: 20,
        children: [],
        setup: (self) => {
          self.hook(Bluetooth, (self) => {
            const devices = Bluetooth.bind('devices').transform(ds => ds.filter(d => d.name))
            self.children = devices["emitter"]["devices"].map(DeviceItem)
          })
        }
      }),
    })
  ],
})

const bluetoothmenu = Widget.Window({
  name: 'bluetoothmenu',
  visible: 'false',
  anchor: ['top', 'right'],
  margins: [80, 530, 10, 10],
  child: box(),
})

export { bluetoothmenu }
