import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
const { Gtk } = imports.gi;
import App from 'resource:///com/github/Aylur/ags/app.js';
import { AgendaText } from '../../../variables.js';

import { parseMarkdown } from '../../../mods/ParseMarkdown.js';

function makeSafeForRegExp(input) {
  return input.replace(/[.*+?^${}()|[\]\\/&'-]/g, '\\$&');
}

export default () => Widget.Box({
  class_name: 'work-agenda',
  vertical: true,
  spacing: 10,
  children: [
    Widget.Box({ spacing: 5, children: [Widget.Button({ on_clicked: () => { Utils.execAsync('wezterm start --always-new-process -e sh -c "nvim ~/.config/ags/_data/agenda.md" &') }, child: Widget.Label({ class_name: "icon", label: "󰏫" }) }), Widget.Label({ label: "Agenda", hpack: "start", class_name: "work-agenda-title" })] }),
    Widget.Scrollable({
      vscroll: 'always',
      hscroll: 'never',
      vexpand: true,
      class_name: 'work-agenda-scroll',
      child: Widget.Box({
        vertical: true,
        spacing: 5,
        setup: (self) => {
          self.hook(AgendaText, (self) => {
            const content = parseMarkdown(AgendaText.value)
            self.children = content.map(e => {
              if (e == []) {
                return Widget.Box({ css: `margin: 20px;` })
              }
              return Widget.Box({
                children: e.map(i => {
                  const type = i.type
                  if (type == "link") {
                    return Widget.EventBox({
                      class_name: `work-agenda-${i.type}`,
                      label: i.content,
                      on_primary_click: () => {
                        Utils.exec(`firefox ${i.url}`)
                      }
                    })
                  } else if (type == "todo") {
                    return Widget.Button({
                      on_clicked: () => {
                        if (i.completed) {
                          Utils.exec(`sed -i '/^-\\ \\[x\\] ${makeSafeForRegExp(i.content)}/s/\\[x\\]/[ ]/' ${App.configDir}/_data/agenda.md`)
                        } else {
                          Utils.exec(`sed -i '/^-\\ \\[ \\] ${makeSafeForRegExp(i.content)}/s/\\[ \\]/[x]/' ${App.configDir}/_data/agenda.md`)
                        }
                      },
                      child: Widget.Box({
                        spacing: 5,
                        children: [
                          Widget.Box({
                            class_names: ['icon', `work-agenda-todo-${i.completed}`],
                            vpack: "start",
                          }),
                          Widget.Label({
                            label: i.content,
                            hpack: "start",
                            xalign: 0,
                            justify: Gtk.Justification.LEFT,
                            wrap: true,
                            class_name: `work-agenda-text-${i.completed}`
                          }),
                        ]
                      })
                    })
                  } else if (type == "list") {
                    return Widget.Box({
                      spacing: 5,
                      children: [
                        Widget.Box({
                          class_names: ['icon', `work-agenda-list`],
                          vpack: "start",
                        }),
                        Widget.Label({
                          label: i.content,
                          hpack: "start",
                          xalign: 0,
                          justify: Gtk.Justification.LEFT,
                          wrap: true,

                        }),
                      ]
                    })
                  }
                  return Widget.Label({
                    label: i.content, class_name: `work-agenda-${type}`, hpack: "start",
                    xalign: 0,
                    justify: Gtk.Justification.LEFT,
                    wrap: true,
                  })
                })
              })
            }
            )
          })
        }
      }),
    })
  ],
})
