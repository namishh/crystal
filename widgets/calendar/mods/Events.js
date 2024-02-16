import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
const { Gtk } = imports.gi;
import App from 'resource:///com/github/Aylur/ags/app.js';
import { EventsText } from '../../../variables.js';

const parseEvents = (self, text) => {
  let events = text.split("\n").filter(i => i != "")
  console.log(events)
  if (events == []) {
    self.child = Widget.Box({ css: `margin: 20px;` })
  } else {
    self.child = Widget.Box({
      vertical: true,
      children: events.map(e => {
        const [date, month, urgency, event] = e.split("`")
        return Widget.Box({
          class_name: `calendar-events-item calendar-${urgency}`,
          hexpand: true,
          children: [
            Widget.Box({
              vertical: true,
              class_name: "calendar-events-box",
              children: [
                Widget.Label({
                  class_name: "calendar-events-month",
                  label: month
                }),
                Widget.Label({
                  class_name: "calendar-events-date",
                  label: date
                })
              ]
            }),
            Widget.Label({
              label: event,
              hpack: "start",
              vpack: "start",
              xalign: 0,
              justify: Gtk.Justification.LEFT,
              wrap: true,
              class_name: `calendar-events-text`
            }),
          ]
        })
      })
    })
  }
}

export default () => Widget.Box({
  class_name: 'calendar-events',
  vertical: true,
  spacing: 10,
  children: [
    Widget.Box({ spacing: 5, children: [Widget.Button({ on_clicked: () => { Utils.execAsync('wezterm start --always-new-process -e sh -c "nvim ~/.config/ags/_data/events.txt" &') }, child: Widget.Label({ class_name: "icon", label: "󰏫" }) }), Widget.Label({ label: "Events", hpack: "start", class_name: "calendar-events-title" })] }),
    Widget.Scrollable({
      vscroll: 'always',
      hscroll: 'never',
      vexpand: true,
      class_name: 'calendar-scroll',
      child: Widget.Box({
        class_name: "calendar-events-content",
        setup: (self) => {
          self.hook(EventsText, self => {
            parseEvents(self, EventsText.value)
          })
        },
      }),
    })
  ],
})
