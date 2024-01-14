import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';

const SysTrayItem = item => Widget.Button({
  child: Widget.Icon().bind('icon', item, 'icon'),
  tooltipMarkup: item.bind('tooltip-markup'),
  onPrimaryClick: (_, event) => item.activate(event),
  onSecondaryClick: (_, event) => item.openMenu(event),
});

export default () => Widget.Box({ vertical: true, spacing: 10 })
  .bind('children', SystemTray, 'items', i => i.map(SysTrayItem))
