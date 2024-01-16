const { Gtk } = imports.gi;
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import App from 'resource:///com/github/Aylur/ags/app.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

const Notifs = Widget.Box({
  class_name: "panel-notifs",
  spacing: 20,
  vertical: true,
  vexpand: true,
  setup: (self) => {
    self.hook(Notifications, (self) => {
      self.children = Notifications.notifications.map(n => Widget.Box({
        class_name: "panel-notification",
        vertical: true,
        children: [
          Widget.CenterBox({
            class_name: "nt2",
            start_widget: Widget.Label({
              label: `${n.summary}`,
              hpack: "start",
              class_name: "ntt",
              wrap: true
            }),
            end_widget: Widget.Button({
              class_names: ["icon", "nti"],
              hpack: "end",
              label: "󰅖",
              on_clicked: () => {
                n.close()
              }
            })
          }),

          Widget.Box({
            class_name: "nc",
            spacing: 20,
            children: [
              Widget.Icon({
                icon: n.app_icon || `${App.configDir}/assets/wedding-bells.png`,
                size: 60
              }),
              Widget.Label({
                vpack: "start",
                hpack: "start",
                xalign: 0,
                justify: Gtk.Justification.LEFT,
                wrap: true,
                label: n.body
              })
            ]
          })
        ],
      }))
    })
  }
})
const NotifBox = Widget.Scrollable({
  vscroll: 'always',
  hscroll: 'never',
  vexpand: true,
  class_name: 'notifbox',
  child: Notifs,
})

const Empty = Widget.Box({
  class_name: "notifempty",
  spacing: 20,
  hpack: "center",
  vpack: "center",
  vertical: true,
  children: [
    Widget.Icon({
      icon: `${App.configDir}/assets/wedding-bells.png`,
      size: 240,
      vpack: "center",
      vexpand: true,
    })
  ]
})

export default () => Widget.Box({
  class_name: "panel-notifications",
  spacing: 20,
  vertical: true,
  children: [
    Widget.CenterBox({
      start_widget: Widget.Label({
        label: "Notifications",
        hpack: 'start',
        class_name: "nt"
      }),
      end_widget: Widget.Button({
        label: "󰎟",
        hpack: 'end',
        class_name: "icon ni",
        on_clicked: () => {
          const list = Array.from(Notifications.notifications);
          for (let i = 0; i < list.length; i++) {
            Utils.timeout(50 * i, () => list[i]?.close());
          }
        }
      })
    }),
    Widget.Stack({
      transition: 'crossfade',
      transitionDuration: 150,
      items: [
        ['empty', Empty],
        ['list', NotifBox]
      ],
      setup: (self) => {
        self.hook(Notifications, (self) => {
          self.shown = (Notifications.notifications.length == 0 ? 'empty' : 'list')
        })
      }
    }),
  ],
})

