import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

import { Uptime } from "../../../variables.js"

export default () => Widget.CenterBox({
  spacing: 12,
  class_name: "panel-top",
  homogeneous: false,
  vertical: false,
  start_widget: Widget.Box({
    homogeneous: false,
    vertical: false,
    hpack: "start",
    spacing: 12,
    children: [
      Widget.Box({
        class_name: "panel-pfp",
        css: `background-image: url('${App.configDir}/assets/pfp.png');`
      }),
      Widget.Label({
        class_name: "panel-name",
        label: "Hi nam!"
      })
    ]
  }),
  end_widget: Widget.Box({
    hpack: "end",
    children: [Widget.Label({
      class_name: "panel-uptime",
      setup: self => {
        self.hook(Uptime, (self) => {
          self.label = Uptime.value
        })
      }
    })]
  })
})

