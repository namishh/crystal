import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import App from 'resource:///com/github/Aylur/ags/app.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
const { Gtk } = imports.gi;

const Notification = (n) => Widget.Revealer({
  attribute: {
    "id": n.id
  },
  reveal_child: true,
  child: Widget.Button({
    on_clicked: () => { n.close() },
    child: Widget.Box({
      class_name: "notification",
      spacing: 20,
      children: [
        Widget.Icon({
          icon: n.app_icon || `${App.configDir}/assets/wedding-bells.png`,
          size: 60
        }),
        Widget.Box({
          vertical: true,
          spacing: 2,
          children: [
            Widget.Label({
              label: `${n.summary}`,
              hpack: "start",
              xalign: 0,
              justify: Gtk.Justification.LEFT,
              class_name: "notification-title",
              wrap: true
            }),
            Widget.Label({
              vpack: "start",
              hpack: "start",
              class_name: "notification-body",
              xalign: 0,
              justify: Gtk.Justification.LEFT,
              wrap: true,
              label: n.body
            }),
            Widget.Box({
              class_name: 'notification-actions',
              children: n.actions.map(({ id, label }) => Widget.Button({
                class_name: 'notification-button',
                on_clicked: () => n.invoke(id),
                hexpand: true,
                child: Widget.Label(label),
              })),
            })
          ]
        })
      ]
    }),
  })
})
const NotifList = () => Widget.Box({
  vertical: true,
  spacing: 10,
  class_name: 'osd-notifs spacing-v-5-revealer',
  attribute: {
    'map': new Map(),
    'dismiss': (box, id, force = false) => {
      if (!id || !box.attribute.map.has(id) || box.attribute.map.get(id).attribute.hovered && !force)
        return;

      const notif = box.attribute.map.get(id);
      notif.revealChild = false;
      notif.destroy();
      box.attribute.map.delete(id);
    },
    'notify': (box, id) => {
      if (!id || Notifications.dnd) return;
      if (!Notifications.getNotification(id)) return;

      box.attribute.map.delete(id);

      const notif = Notifications.getNotification(id);
      const newNotif = Notification(notif);
      box.attribute.map.set(id, newNotif);
      box.pack_end(box.attribute.map.get(id), false, false, 0);
      box.show_all();
    },
  },
  setup: (self) => self
    .hook(Notifications, (box, id) => box.attribute.notify(box, id), 'notified')
    .hook(Notifications, (box, id) => box.attribute.dismiss(box, id), 'dismissed')
    .hook(Notifications, (box, id) => box.attribute.dismiss(box, id, true), 'closed')
  ,
});

const revealer = () => Widget.Box({
  css: "min-height: 1px; min-width: 1px;",
  child: Widget.Revealer({
    reveal_child: false,
    transition: 'none',
    attribute: { count: 0, box: NotifList },
    child: NotifList(),
    setup: self => {
      self.hook(Notifications, (self) => {
        self.reveal_child = true
        self.attribute.count++
        Utils.timeout(8000, () => {
          self.attribute.count--
          if (self.attribute.count === 0) self.reveal_child = false
        })
      }, 'notified')
    }
  })
})

const notif = Widget.Window({
  name: 'notif',
  anchor: ['top'],
  margins: [60, 10, 10, 10],
  child: revealer(),
})

export { notif }
