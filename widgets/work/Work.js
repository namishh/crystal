import Widget from 'resource:///com/github/Aylur/ags/widget.js';

import Timer from './mods/Timer.js';
import Agenda from './mods/Agenda.js';
import Graph from './mods/Graph.js';

const Box = Widget.Box({
  spacing: 15,
  class_name: "work",
  homogeneous: false,
  vertical: true,
  children: [Agenda(), Timer(), Graph()]
})

const work = Widget.Window({
  name: 'work',
  visible: false,
  focusable: false,
  anchor: ['left', 'top', 'bottom'],
  margins: [0, 0],
  child: Box,
})

export { work }

