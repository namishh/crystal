import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Date2 from '../../mods/Date.js';

const box = () => Widget.Box({
  vertical: true,
  children: [
    Widget.Box({
      class_name: "desktime",
      children: [
        Widget.Label({ label: "It's ", class_name: 'desktime-text-big' }),
        Date2({ format: " %A ", class_name: "desktime-day" }),
        Date2({ format: " %d, %b ", class_name: "desktime-date" }),
      ]
    }),
    Widget.Label({
      label: "Hi nam! How are ya doing",
      hpack: "end",
      class_name: "desktime-message"
    }),
  ]
})

const time = Widget.Window({
  name: 'time',
  layer: "bottom",
  anchor: ['right', 'top'],
  margins: [60, 0, 10, 0],
  child: box(),
})

export { time }
