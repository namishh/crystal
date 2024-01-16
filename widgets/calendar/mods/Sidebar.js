import Date from '../../../mods/Date.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default () => Widget.Button({
  child: Widget.Box({
    class_name: "calendar-side",
    spacing: 8,
    homogeneous: false,
    vertical: true,
    children: [
      Widget.Box({
        children: [
          Widget.Overlay({
            child: Widget.Box({ class_name: "calendar-time-box" }),
            overlays: [Date({ format: "%M", class_name: "calendar-min" }), Date({ format: "%H", class_name: "calendar-hour" })]
          }),
          Date({ format: "%a, %d", class_name: "calendar-day", vexpand: false }),
          Widget.Box({
            class_name: "calendar-mon",
            hpack: "center",
            vertical: true,
            vpack: 'end',
            spacing: 5,
            children: [Date({ format: "%Y", hpack: "center", vpack: "end", }), Date({ format: "%b", vpack: "end", hpack: "center" }),]
          })
        ],
        vertical: true,
        class_name: "calendar-time",
        vpack: "center",
      })
    ],
  }),
})

