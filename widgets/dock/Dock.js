import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Sway from "resource:///com/github/Aylur/ags/service/sway.js";

import { WS } from '../../variables.js';
import { getArrayOfKeys } from '../../utils.js';

const pinned = {
  firefox: {
    class: "firefox",
    cmd: "firefox",
    count: 0,
    focused: false,
  },
  "org.wezfurlong.wezterm": {
    class: "org.wezfurlong.wezterm",
    cmd: "wezterm",
    count: 0,
    focused: false,
  },
  spotify: {
    class: "spotify",
    cmd: "spotify",
    count: 0,
    focused: false,
  },
  vesktop: {
    class: "vesktop",
    cmd: "vesktop",
    count: 0,
    focused: false,
  },
}


function extractAppIds(obj) {
  let result = [];
  if (obj.app_id) {
    result.push(obj.app_id);
  } else if (obj.window_properties) {
    result.push(obj.window_properties.class);
  }

  if (obj.nodes && obj.nodes.length > 0) {
    obj.nodes.forEach(node => {
      result = result.concat(extractAppIds(node));
    });
  }

  if (obj.floating_nodes && obj.floating_nodes.length > 0) {
    obj.floating_nodes.forEach(node => {
      result = result.concat(extractAppIds(node));
    });
  }

  return result;
}


function getFocused(obj) {
  let result = [];
  if (obj.focused) {
    if (obj.app_id) {
      result.push(obj.app_id);
    } else if (obj.window_properties) {
      result.push(obj.window_properties.class);
    }
  }

  if (obj.nodes && obj.nodes.length > 0) {
    obj.nodes.forEach(node => {
      result = result.concat(extractAppIds(node));
    });
  }

  if (obj.floating_nodes && obj.floating_nodes.length > 0) {
    obj.floating_nodes.forEach(node => {
      result = result.concat(extractAppIds(node));
    });
  }

  return result;
}

// ugliest code ive ever written but hey, it aorks
const generateChildren = (self) => {
  const apps = pinned
  const curr = WS.value ? WS.value.filter(i => i.focused == true)[0].name : "0"
  const nodes = Sway.getWorkspace(curr).nodes.concat(Sway.getWorkspace(curr).floating_nodes)
  const appIdsArray = nodes.reduce((acc, obj) => acc.concat(extractAppIds(obj)), []);
  const focused = nodes.reduce((acc, obj) => acc.concat(getFocused(obj)), []);
  for (var key in apps) {
    apps[key].count = 0
    if (key == focused[0]) {
      apps[key].focused = true
    } else {
      apps[key].focused = false
    }
  }
  appIdsArray.forEach(id => {
    if (apps[id]) {
      apps[id].count++
    } else {
      apps[id] = {
        class: id,
        cmd: id,
        count: 0,
        focused: false,
      }
    }
  });
  console.log(apps)
  self.children = getArrayOfKeys(apps).map(i => Widget.Button({ on_clicked: () => { Utils.execAsync(i.cmd) }, child: Widget.Icon({ size: 40, icon: i.class, class_name: `dock-icon dock-icon-${i.focused}` }) }))

}

const tasklist = () => Widget.Box({
  class_name: "dock-tasklist",
  spacing: 7,
  children: getArrayOfKeys(pinned).map(i => Widget.Button({ on_clicked: () => { Utils.execAsync(i.cmd) }, child: Widget.Icon({ size: 40, icon: i.class, class_name: "dock-icon" }) })),
  setup: (btn) => {
    btn.hook(WS, (btn) => {
      generateChildren(btn)
    });
  }
})

const pinnedApps = () => Widget.Box({
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
  self.reveal_child = ws.nodes.length == 0;
}

const box = () => Widget.Box({
  css: "min-height: 1px; min-width: 1px;",
  child: Widget.Revealer({
    reveal_child: true,
    transition: 'none',
    setup: self => {
      self.hook(Sway.active.workspace, hideChild);
      self.hook(WS, hideChild);
    },
    child: Widget.Box({
      children: [tasklist(), Widget.Box({ class_name: "dock-sep" }), pinnedApps()],
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
