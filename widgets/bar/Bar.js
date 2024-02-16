import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Clock from "./mods/Clock.js"
import Status from "./mods/Status.js"
import Systray from "./mods/Systray.js"
import Work from './mods/Work.js';


const pfp = () => Widget.Button({
  child: Widget.Box({
    class_name: "bar-pfp",
    css: `background-image: url('${App.configDir}/assets/pfp.jpg');background-size: cover;`
  }),
  on_clicked: () => {
  }
})
const nixicon = () => Widget.Button({
  child: Widget.Icon({
    icon: `${App.configDir}/assets/nixos.png`,
    size: 25
  }),
  on_clicked: () => {
    App.toggleWindow("launcher")
  }
})

const OptionalWorkspaces = async () => {
  try {
    return (await import('./mods/Workspaces.js')).default();
  } catch {
  }
};

const left = () => Widget.Box({
  spacing: 12,
  homogeneous: false,
  vertical: true,
  setup: async b => {
    b.children = [nixicon(), await OptionalWorkspaces(), Work()]
  }
});

const right = () => Widget.Box({
  spacing: 12,
  homogeneous: false,
  vertical: true,
  vpack: "end",
  children: [Systray(), Status(), Clock(), pfp()]
});

const box = () => Widget.CenterBox({
  class_name: "bar",
  homogeneous: false,
  spacing: 8,
  vertical: true,
  start_widget: left(),
  end_widget: right(),
})

const bar = Widget.Window({
  name: 'bar',
  anchor: ['top', 'left', 'bottom'],
  exclusivity: "exclusive",
  margins: [0, 0, 0, 0],
  child: box(),
})

export { bar }
