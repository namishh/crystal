import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import { TimerSeconds, TimerMode } from '../../../variables.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

import { pausableInterval } from '../../..//mods/PausableInterval.js';

const TimerInterval = pausableInterval(1000, () => {
  TimerSeconds.value = TimerSeconds.value + 1
})

function getCurrentDateTime() {
  const now = new Date();

  const hours = now.getHours().toString().padStart(2, '0');
  const minutes = now.getMinutes().toString().padStart(2, '0');
  const seconds = now.getSeconds().toString().padStart(2, '0');
  const date = now.getDate().toString().padStart(2, '0');
  const month = (now.getMonth() + 1).toString().padStart(2, '0'); // Months are zero-based
  const year = now.getFullYear();

  const formattedDateTime = `${hours}:${minutes}:${seconds}:${date}:${month}:${year}`;
  return formattedDateTime;
}



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


export default () => Widget.Overlay({
  child: Widget.Box({
    class_name: "work-timer-bg",
  }),
  overlays: [
    Widget.CenterBox({
      vertical: true,
      homogeneous: true,
      start_widget: Widget.CenterBox({
        start_widget: Widget.Label({
          hpack: "start",
          label: "Focus Session",
          vpack: "center",
          class_name: 'work-timer-title',
        }),
        end_widget: Widget.Box({
          hpack: "end",
          class_name: 'work-timer-select',
          children: [
            Widget.Button({
              vpack: "center",
              label: "Work",
              class_name: `work-timer-${TimerMode.value == "work"} work-timer-selection`,
              setup: (self) => {
                self.hook(TimerMode, (self) => {
                  self.class_name = `work-timer-${TimerMode.value == "work"} work-timer-selection`
                })
              },
              on_clicked: () => { TimerMode.setValue("work") },
            }),
            Widget.Button({
              label: "Break",
              vpack: "center",
              setup: (self) => {
                self.hook(TimerMode, (self) => {
                  self.class_name = `work-timer-${TimerMode.value == "break"} work-timer-selection`
                })
              },
              class_name: `work-timer-${TimerMode.value == "break"} work-timer-selection`,
              on_clicked: () => { TimerMode.setValue("break") },
            })
          ],
        }),
      }),
      center_widget: Widget.Box({
        vexpand: true,
        hpack: "center",
        setup: (self) => {
          self.hook(TimerSeconds, (self) => {
            const time = convertTime(TimerSeconds.value)
            self.child = Widget.Label({
              hpack: "fill",
              class_name: "work-timer-time",
              label: `${time.hours}:${time.minutes}:${time.seconds}`
            })
          })
        }
      }),
      end_widget: Widget.Box({
        hpack: "center",
        vpack: "center",
        class_name: "work-timer-buttons",
        children: [
          Widget.Button({
            on_clicked: () => {
              TimerInterval.toggle()
            },
            label: "󰐎",
            class_names: ['icon', 'work-timer-button']
          }),
          Widget.Button({
            on_clicked: () => {
              TimerInterval.stop()
              TimerSeconds.value = 0
            },
            label: "󰦛",
            class_names: ['icon', 'work-timer-button']
          }),
          Widget.Button({
            on_clicked: () => {
              Utils.exec(`bash -c 'echo "${TimerSeconds.value},${getCurrentDateTime()},${TimerMode.value}" >> ${App.configDir}/_data/timerhistory.txt'`)
              TimerInterval.stop()
              TimerSeconds.value = 0
            },
            label: "󰈼",
            class_names: ['icon', 'work-timer-button']
          }),
        ],
      })
    })
  ]
})
