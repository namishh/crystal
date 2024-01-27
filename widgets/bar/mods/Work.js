import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { AgendaText } from '../../../variables.js';

const getTodos = (txt) => {
  const lines = txt.split("\n").filter(i => i.startsWith("- ["))
  const completed = lines.filter(i => i.startsWith("- [x]"))
  return [lines, completed]
}

export default () => Widget.Button({
  on_clicked: () => {
    App.toggleWindow("work")
  },
  child: Widget.CircularProgress({
    class_name: "bar-work-prog",
    value: 0.14,
    vpack: "center",
    hpack: "center",
    rounded: true,
    hexpand: true,
    setup: self => {
      self.hook(AgendaText, (self) => {
        const state = getTodos(AgendaText.value)
        self.value = state[1].length / state[0].length
      })
    },
    child: Widget.Label({
      label: "0",
      class_name: "bar-work-label",
      setup: self => {
        self.hook(AgendaText, (self) => {
          const state = getTodos(AgendaText.value)
          self.label = `${state[1].length}`
        })
      },
    }),
    inverted: false,
    startAt: 0.75,
  })
})
