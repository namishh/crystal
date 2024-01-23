import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

const Music = player => {
  return Widget.Box({
    vertical: false,
    homogeneous: false,
    class_name: "launcher-music",
    children: [
      Widget.Box({
        class_name: "launcher-music-img",
        setup: self => {
          self.hook(Mpris, (self) => {
            self.css = `background-image: url('${player.cover_path}'); min-width: 120px; min-height: 120px; background-size: cover; background-position: center; `
          })
        }
      }),
      Widget.Box({
        vertical: true,
        homogeneous: false,
        hexpand: true,
        class_name: 'launcher-music-info',
        children: [
          Widget.Label({
            class_name: 'launcher-app-title',
            setup: self => {
              self.hook(Mpris, (self) => {
                self.label = player.track_title
              })
            },
            vpack: 'center',
            hpack: 'center',
            truncate: 'end',
          }),
          Widget.Label({
            class_name: 'launcher-music-artist',
            setup: self => {
              self.hook(Mpris, (self) => {
                self.label = player.track_artists[0]
              })
            },
            vpack: 'center',
            hpack: 'center',
            truncate: 'end',
          }),
          Widget.Box({
            class_name: "launcher-music-box",
            hpack: "center",
            spacing: 20,
            children: [
              Widget.Button({
                on_clicked: () => {
                  player.previous()
                },
                child: Widget.Label({
                  class_name: 'icon launcher-music-icon',
                  label: "󰒮",
                  vpack: "center",
                  hpack: "center",
                  xalign: 0.5,
                })
              }),
              Widget.CircularProgress({
                class_name: "launcher-music-prog",
                value: 0.14,
                vpack: "center",
                hpack: "center",
                rounded: true,
                hexpand: true,
                setup: self => {
                  self.poll(3000, (self) => {
                    self.value = player.position / player.length
                  })
                },
                inverted: false,
                startAt: 0.75,
                child: Widget.Button({
                  on_clicked: () => {
                    player.playPause()
                  },
                  class_name: 'icon launcher-music-icon',
                  label: "󰐊",
                  hexpand: true,
                  vpack: "center",
                  hpack: "center",
                  setup: self => {
                    self.hook(Mpris, self => {
                      self.label = `${player.playBackStatus != "Playing" ? "󰐊" : "󰏤"}`
                    })
                  },
                })
              }),
              Widget.Button({
                on_clicked: () => {
                  player.next()
                },
                child: Widget.Label({
                  class_name: 'icon launcher-music-icon',
                  label: "󰒭",
                  vpack: "center",
                  hpack: "center"
                })
              })
            ],
          })
        ],
      })
    ],
  })
}

export default () => Widget.Box({
  vertical: true,
  class_name: 'media vertical',
  visible: Mpris.bind('players').transform(p => p.length > 0),
  children: Mpris.bind('players').transform(ps => ps
    .filter(p => ["playerctld"]
      .includes(p.name)).map(Music)),
});
