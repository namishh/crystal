import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

const Music = player => {
  return Widget.Overlay({
    child: Widget.Box({
      class_name: "calendar-music-b",
        setup: self => {
          self.hook(Mpris, (self) => {
            self.css = `background-image: url('${player.cover_path}'); min-height: 200px; background-size: cover; background-position: center; `
          })
        }
    }),
    overlays: [
      Widget.Box({class_name: "calendar-music-g"}),
      Widget.CenterBox({
        class_name: "calendar-music",
        vertical: true,
        end_widget: Widget.Box({
          spacing: 8,
          children: [
            Widget.Box({vpack: "center",hpack : "center", class_names:["calendar-music-vis","calendar-music-vis-1"]}),
            Widget.Box({vpack: "center",hpack : "center", class_names:["calendar-music-vis","calendar-music-vis-2"]}),
            Widget.Box({vpack: "center",hpack : "center", class_names:["calendar-music-vis","calendar-music-vis-3"]}),
            Widget.Box({vpack: "center",hpack : "center", class_names:["calendar-music-vis","calendar-music-vis-4"]}),
          ]
        }),
        start_widget: Widget.Box({
          class_name: "calendar-music-top",
        spacing:6,
          vertical: true,
          hpack: "start",
          children: [
            Widget.Label({
              class_name: "calendar-music-label",
          hpack: "start",
              setup: self => {
                self.hook(Mpris, (self) => {
                  self.label = `Playing via: ${player.identity == "Music Player Daemon" ? "mpd" : player.identity}`
                })
              }
            }),
            Widget.Label({
          hpack: "start",
              class_name: "calendar-music-title",
              setup: self => {
                self.hook(Mpris, (self) => {
                  self.label = `${player.track_title}`
                })
              }
            }),
            Widget.Label({
              class_name: "calendar-music-artist",
          hpack: "start",
              setup: self => {
                self.hook(Mpris, (self) => {
                  self.label = `${player.track_artists[0]}`
                })
              }
            }),
          ]
        })
      })
    ]
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

