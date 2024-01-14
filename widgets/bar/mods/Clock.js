import Date from '../../../mods/Date.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default () => Widget.Box({
  class_name: "bar-time",
  spacing: 8,
  homogeneous: false,
  vertical: true,
  children: [Date({ format: "%H" }), Date({ format: "%M" })],
});
