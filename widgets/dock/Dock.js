import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Sway from "resource:///com/github/Aylur/ags/service/sway.js";

const generateChildren = (self) => {
  let apps = self.attribute.apps
  const nodes = Sway.getWorkspace(Sway.active.workspace.name).nodes;
  const floats = Sway.getWorkspace(Sway.active.workspace.name).floating_nodes;
  let uniqueClasses = []
}

const tasklist = () => Widget.Box({
  class_name: "dock-tasklist",
  spacing: 7,
  attribute: {
    'apps': [
      {
        class: "firefox",
        cmd: "firefox",
        count: 0,
      },
      {
        class: "org.wezfurlong.wezterm",
        cmd: "wezterm",
        count: 0
      },
      {
        class: "spotify",
        cmd: "spotify",
        count: 0
      },
      {
        class: "discord",
        cmd: "discord",
        count: 0,
      },
    ]
  },
  setup: (btn) => {
    btn.children = btn.attribute['apps'].map(i => Widget.Button({ on_clicked: () => { Utils.execAsync(i.cmd) }, child: Widget.Icon({ size: 40, icon: i.class, class_name: "dock-icon" }) }))
    btn.hook(Sway, (btn) => {
      generateChildren(btn)
    }, 'notify::client');
    btn.hook(Sway.active.workspace, (btn) => {
      generateChildren(btn)
    }, 'notify::client');
  }
})

const pinned = () => Widget.Box({
  class_name: "dock-pinned",
  spacing: 7,
  attribute: {
    'apps': [
      {
        class: "trashcan_empty",
        cmd: "nemo trash://",
      },
    ]
  },
  setup: (btn) => {
    btn.children = btn.attribute['apps'].map(i => Widget.Button({ on_clicked: () => { Utils.execAsync(i.cmd) }, child: Widget.Icon({ size: 40, icon: i.class, class_name: "dock-icon" }) }))
  }
})

const folders = () => Widget.Box({
  class_name: "dock-pinned",
  spacing: 7,
  attribute: {
    'apps': [
      {
        class: "folder_home",
        cmd: "nemo",
      },
      {
        class: "folder-pictures",
        cmd: "nemo Pictures/",
      },
    ]
  },
  setup: (btn) => {
    btn.children = btn.attribute['apps'].map(i => Widget.Button({ on_clicked: () => { Utils.execAsync(i.cmd) }, child: Widget.Icon({ size: 40, icon: i.class, class_name: "dock-icon" }) }))
  }
})

const hideChild = (self) => {
  const ws = Sway.getWorkspace(Sway.active.workspace.name);
  //console.log("WORKSPACES RAH")
  //console.log(Sway.workspaces)
  self.reveal_child = ws.nodes.length == 0;
}

const box = () => Widget.Box({
  css: "min-height: 1px; min-width: 1px;",
  child: Widget.Revealer({
    reveal_child: true,
    transition: 'none',
    setup: self => {
      self.hook(Sway.active.workspace, hideChild);
      self.hook(Sway, hideChild, 'notify::clients');
    },
    child: Widget.Box({
      children: [folders(), Widget.Box({ class_name: "dock-sep" }), tasklist(), Widget.Box({ class_name: "dock-sep" }), pinned()],
      class_name: "dock",
    }),
  })
})

const dock = Widget.Window({
  name: 'dock',
  anchor: ['bottom'],
  margins: [10, 10, 10, 10],
  child: box(),
})

export { dock }
