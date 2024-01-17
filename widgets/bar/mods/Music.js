import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';


const Music = player => {
  return Widget.Overlay({
    child: Widget.Box({
      class_name: 'barmusic',
      setup: self => {
        self.hook(Mpris, (self) => {
          self.css = `background-image: url('${player.cover_path}');min-width: 20px; min-height:120px;background-size: cover;background-position: center;`
        })
      },
    }),
    overlays: [
      Widget.Box({
        class_name: 'barmusicg',
      }),
      Widget.CenterBox({
        vertical: true,
        class_name: "barmusicbuttons",
        start_widget: Widget.CircularProgress({
          class_name: "barmusicprog",
          value: 0.14,
          vpack: "start",
          rounded: true,
          setup: self => {
            const update = () => {
              self.value = player.position / player.length
            }
            self.hook(player, update, "position")
            self.poll(2000, update)
          },
          inverted: false,
          startAt: 0.75,
          child: Widget.Button({
            on_clicked: () => {
              player.playPause()
            },
            child: Widget.Label({
              class_name: 'icon musicicon',
              label: "󰐊",
              vpack: "center",
              setup: self => {
                self.hook(Mpris, self => {
                  self.label = `${player.playBackStatus != "Playing" ? "󰐊" : "󰏤"}`
                })
              },
              hpack: "center"
            })

          })
        })
      }),
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
