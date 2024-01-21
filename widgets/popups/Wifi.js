import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Network from 'resource:///com/github/Aylur/ags/service/network.js';

const box = () => Widget.Box({
  class_names: ["popuppanel", "popuppanel-wifi"],
  spacing: 20,
  vertical: true,
  children: [
    Widget.CenterBox({
      start_widget: Widget.Label({ hpack: "start", label: "Network", class_name: "popuppanel-title" }),
      end_widget: Widget.Button({ hpack: "end", label: "󰅖", class_names: ["popuppanel-close", "icon"], on_clicked: () => App.closeWindow("wifimenu") })
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
        setup: (self) => {
          self.hook(Network, (self) => {
            self.children = Network.wifi?.access_points.map(ap => Widget.Button({
              on_clicked: () => Utils.execAsync(`nmcli device wifi connect ${ap.bssid}`),
              child: Widget.CenterBox({
                start_widget: Widget.Box({
                  spacing: 20,
                  children: [
                    Widget.Icon({ icon: ap.iconName, size: 18 }),
                    Widget.Label({
                      label: ap.ssid,
                      class_names: ["popuppanel-label", `${ap.active ? 'popuppanel-label-active' : ''}`]
                    })
                  ],
                }),
                end_widget: Widget.Label({
                  label: `${!ap.active ? '' : '󰄬'}`,
                  hpack: "end",
                  class_names: ["icon", "popuppanel-active-icon"]
                })
              })
            }))
          })
        }
      }),
    })
  ],
})

const wifimenu = Widget.Window({
  name: 'wifimenu',
  visible: 'false',
  anchor: ['top', 'right'],
  margins: [80, 530, 10, 10],
  child: box(),
})

export { wifimenu }
