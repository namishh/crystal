import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js'

const websites = [
  {
    name: "NixOs",
    url: "https://nixos.org"
  },
  {
    name: "Figma",
    url: "https://www.figma.com/files/recents-and-sharing"
  },
  {
    name: "Reddit",
    url: "https://reddit.com"
  },
  {
    name: "Youtube",
    url: "https://youtube.com"
  },
  {
    name: "WhatsApp",
    url: "https://web.whatsapp.com"
  },
]

export default () => Widget.Box({
  class_name: "launcher-sites",
  homogeneous: false,
  spacing: 30,
  vertical: true,
  children: [
    Widget.Label({
      class_name: 'launcher-site-header',
      label: "Favourite Sites",
      vpack: "center",
      hpack: "start",
    }),
    Widget.Scrollable({
      hscroll: 'never',
      class_name: "launcher-sites-list",
      child: Widget.Box({
        vertical: true,
        children: websites.map(i => Widget.Button({
          on_clicked: () => {
            execAsync(`firefox ${i.url} `)
          },
          child: Widget.Box({
            class_name: "launcher-sites-site",
            homogeneous: false,
            spacing: 15,
            vertical: false,
            children: [
              Widget.Icon({
                icon: `${App.configDir}/assets/icons/${i.name.toLowerCase()}.svg`,
                size: 30,
              }),
              Widget.Label({
                class_name: 'launcher-sites-site-title',
                label: i.name,
                vpack: "center",
                hpack: "start",
              }),
            ]
          })
        })
        ),
        spacing: 30,
      }),
    }),
  ]
})
