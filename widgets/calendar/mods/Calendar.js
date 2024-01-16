import Widget from 'resource:///com/github/Aylur/ags/widget.js';

import { getCalendarLayout } from '../../../mods/CalendarLayout.js';

export default () => Widget.Box({
  vertical: true,
  class_name: 'calendar-cal',
  setup: (self) => {
    const dates = getCalendarLayout()
    self.children = [
      Widget.Box({
        homogeneous: true,
        children: [
          Widget.Label({
            label: "Mo",
            hpack: 'center',
            class_name: 'calendar-cell calendar-weekday'
          }),
          Widget.Label({
            label: "Tu",
            hpack: 'center',
            class_name: 'calendar-cell calendar-weekday'
          }),
          Widget.Label({
            label: "We",
            hpack: 'center',
            class_name: 'calendar-cell calendar-weekday'
          }),
          Widget.Label({
            label: "Th",
            hpack: 'center',
            class_name: 'calendar-cell calendar-weekday'
          }),
          Widget.Label({
            label: "Fr",
            hpack: 'center',
            class_name: 'calendar-cell calendar-weekday'
          }),
          Widget.Label({
            label: "Sa",
            hpack: 'center',
            class_name: 'calendar-cell calendar-weekend'
          }),
          Widget.Label({
            label: "Su",
            hpack: 'center',
            class_name: 'calendar-cell calendar-weekend'
          }),
        ]
      })
    ].concat(dates.map(s => Widget.Box({
      homogeneous: true,
      setup: (sl) => {
        sl.children = [].concat(s.map(a => Widget.Label({
          label: `${a['day']}`,
          hpack: 'center',
          class_name: `calendar-cell ${a['today'] == 0 ? 'calendar-month' : 'calendar-disabled'} ${a['istoday'] && 'calendar-active'}`
        })))
      }
    })))
  }
})
