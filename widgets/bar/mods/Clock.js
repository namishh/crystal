import Date from '../../../mods/Date.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default () => Widget.Button({
  child: Widget.Box({
    class_name: "bar-time",
    spacing: 8,
    homogeneous: false,
    vertical: true,
    children: [Date({ format: "%H" }), Date({ format: "%M" })],
  }),
  on_clicked: () => {
    App.toggleWindow("calendarbox")
  }
})
