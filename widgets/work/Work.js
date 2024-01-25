import Widget from 'resource:///com/github/Aylur/ags/widget.js';

import Timer from './mods/Timer.js';
import Agenda from './mods/Agenda.js';

const Box = Widget.Box({
  spacing: 15,
  class_name: "work",
  homogeneous: false,
  vertical: true,
  children: [Agenda(), Timer()]
})

const work = Widget.Window({
  name: 'work',
  visible: false,
  focusable: false,
  anchor: ['left'],
  margins: [10, 10],
  child: Box,
})

export { work }

