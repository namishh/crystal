import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import { TimerHistory, TimerMode } from '../../../variables.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

const convertTime = (seconds) => {
  let hours = Math.floor(seconds / 3600);
  let minutes = Math.floor((seconds % 3600) / 60);
  let remainingSeconds = seconds % 60;

  // Add leading zeros if needed
  hours = hours < 10 ? '0' + hours : hours;
  minutes = minutes < 10 ? '0' + minutes : minutes;
  remainingSeconds = remainingSeconds < 10 ? '0' + remainingSeconds : remainingSeconds;

  return { hours, minutes, seconds: String(remainingSeconds) };
}
const parseTimerHistory = (history) => {
  const lines = history.split("\n")
  const data = []
  let maxtime = 0
  lines.forEach(line => {
    if (!line) return
    const [seconds, datetime, mode] = line.split(",")
    if (Number(seconds) > maxtime) {
      maxtime = Number(seconds)
    }
    data.push({
      time: seconds,
      datetime: datetime.split(":"),
      mode: mode
    })
  })
  return [data, maxtime]
}

export default () => Widget.Box({
  class_name: "work-graph",
  child: Widget.Box({
    class_name: "work-cont",
    hexpand: true,
    vexpand: true,
    child: Widget.Scrollable({
      vscroll: "never",
      hexpand: true,
      class_name: "work-graph-scroll",
      hscroll: "always",
      child: Widget.Box({
        spacing: 8,
        hpack: "start",
        hexpand: true,
        vpack: "end",
        setup: (self) => {
          self.hook(TimerHistory, (self) => {
            const [data, max] = parseTimerHistory(TimerHistory.value)
            self.children = data.map(i => {
              const time = convertTime(Number(i.time))
              return Widget.Box({
                vpack: "end",
                class_name: `work-graph-stick-${i.mode}`,
                tooltip_text: `${i.mode == "work" ? "Focused" : "On a break"} for ${time.hours}:${time.minutes}:${time.seconds}\n${i.datetime[3]}/${i.datetime[4]}`,
                css: `min-height: ${Number(i.time) / max * 220}px;`
              })
            }
            )
          })
        }
      }),
    })
  }),
})
