import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Calendar from './mods/Calendar.js';
import Sidebar from './mods/Sidebar.js';
import Music from './mods/Music.js'; 

const Box = Widget.Box({
  spacing: 20,
  class_name: "calendarbox",
  homogeneous: false,
  vertical: true,
  children: [
    Music(),
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
  anchor: ['left', 'bottom'],
  margins: [10, 10],
  child: Box,
})

export { calendarbox }


