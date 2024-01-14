import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Clock from "./mods/Clock.js"
import Status from "./mods/Status.js"
import Systray from "./mods/Systray.js"

const nixicon = Widget.Button({
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
    b.children = [nixicon, await OptionalWorkspaces(),]
  }
});

const right = () => Widget.Box({
  spacing: 12,
  homogeneous: false,
  vertical: true,
  vpack: "end",
  children: [Systray(), Status(), Clock()]
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
  margins: [10, 0, 10, 10],
  child: box(),
})

export { bar }
