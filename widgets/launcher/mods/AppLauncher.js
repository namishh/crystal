import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';

const AppItem = app => Widget.Button({
  on_clicked: () => {
    App.closeWindow("launcher");
    app.launch();
  },
  attribute: { app },
  child: Widget.Box({
    children: [
      Widget.Icon({
        class_name: "launcher-appmenu-appicon",
        icon: app.icon_name || '',
        size: 32,
      }),
      Widget.Label({
        class_name: 'launcher-appmenu-apptitle',
        label: app.name,
        xalign: 0,
        vpack: 'center',
        truncate: 'end',
      }),
    ],
  }),
});



export default () => {
  // list of application buttons
  let applications = Applications.query('').map(AppItem);

  // container holding the buttons
  const list = Widget.Box({
    vertical: true,
    children: applications,
    spacing: 20,
  });

  // repopulate the box, so the most frequent apps are on top of the list
  function repopulate() {
    applications = Applications.query('').map(AppItem);
    list.children = applications;
  }

  // search entry
  const entry = Widget.Entry({
    hexpand: true,
    class_name: "launcher-appmenu-appentry",
    placeholder_text: 'Search',
    css: `margin-bottom: 24px; `,

    // to launch the first item on Enter
    on_accept: () => {
      if (applications[0]) {
        App.toggleWindow("launcher");
        applications[0].attribute.app.launch();
      }
    },

    // filter out the list
    on_change: ({ text }) => applications.forEach(item => {
      item.visible = item.attribute.app.match(text);
    }),
  });

  return Widget.Box({
    vertical: true,
    class_name: "launcher-appmenu",
    css: `margin: 10px; `,
    children: [
      entry,

      // wrap the list in a scrollable
      Widget.Scrollable({
        hscroll: 'never',
        class_name: "launcher-appmenu-list",
        child: list,
      }),
    ],
    setup: self => self.hook(App, (_, windowName, visible) => {
      if (windowName !== "launcher")
        return;

      // when the applauncher shows up
      if (visible) {
        repopulate();
        entry.text = '';
        entry.grab_focus();
      }
    }),
  });
};

