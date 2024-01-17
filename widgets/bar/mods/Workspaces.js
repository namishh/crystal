// tanks to lutman
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Sway from "resource:///com/github/Aylur/ags/service/sway.js";
import { range } from "../../../utils.js"

const dispatch = (arg) => Utils.execAsync(`swaymsg workspace ${arg}`);

export default () => Widget.Box({
  class_name: 'bar-ws',
  vertical: true,
  children: range(5).map((i) =>
    Widget.Button({
      setup: (btn) => (btn.id = i),
      on_clicked: () => dispatch(i),
      child: Widget.Label({
        label: ``,
        class_name: "bar-ws-indicator",
        vpack: "center",
      }),
      connections: [
        [
          Sway,
          (btn) => {
            btn.toggleClassName("bar-ws-active", Sway.active.workspace.name == i);
            btn.toggleClassName(
              "bar-ws-occupied",
              Sway.getWorkspace(`${i}`)?.nodes.length > 0,
            );
          },
        ],
      ],
    })
  ),
});
