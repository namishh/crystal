import Widget from 'resource:///com/github/Aylur/ags/widget.js';

import Agenda from './mods/Agenda.js';

const Box = Widget.Box({
  spacing: 20,
  class_name: "work",
  homogeneous: false,
  children: [Agenda()]
})

const work = Widget.Window({
  name: 'work',
  visible: true,
  focusable: false,
  anchor: ['left'],
  margins: [10, 10],
  child: Box,
})

export { work }

