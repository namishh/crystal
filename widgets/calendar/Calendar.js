import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Calendar from './mods/Calendar.js';
import Sidebar from './mods/Sidebar.js';
import Music from './mods/Music.js';
import Events from './mods/Events.js';

const Box = Widget.Box({
  spacing: 20,
  class_name: "calendarbox",
  homogeneous: false,
  vertical: true,
  children: [
    Events(),
    Widget.Box({
      class_name: "calendar-bottom",
      spacing: 20,
      children: [Calendar(), Sidebar()]
    }),
  ]
})

const calendarbox = Widget.Window({
  name: 'calendarbox',
  visible: false,
  popup: true,
  focusable: false,
  anchor: ['left', 'bottom', 'top'],
  margins: [0, 0],
  child: Box,
})

export { calendarbox }


