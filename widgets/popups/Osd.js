import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import BrightnessService from "../../services/BrightnessService.js";

const revealer = () => Widget.Box({
  css: "min-height: 1px; min-width: 1px;",
  child: Widget.Revealer({
    reveal_child: false,
    transition: 'none',
    child: Widget.Box({
      class_name: "osd",
      spacing: 30,
      children: [
        Widget.Label({
          class_names: ["icon", "osd-icon"],
          setup: self => {
            self.hook(Audio, (self) => {
              self.label = "󰕾"
            }, 'speaker-changed')
            self.hook(BrightnessService, (self) => {
              self.label = "󰃟"
            }, 'screen-changed')
          }
        }),
        Widget.Box({
          vertical: true,
          spacing: 5,
          children: [
            Widget.Label({
              class_names: ["osd-label"],
              hpack: "start",
              setup: self => {
                self.hook(Audio, (self) => {
                  self.label = "Audio"
                }, 'speaker-changed')
                self.hook(BrightnessService, (self) => {
                  self.label = "Brightness"
                }, 'screen-changed')
              }
            }), Widget.ProgressBar({
              setup: self => {
                self.hook(Audio, (self) => {
                  self.value = Audio.speaker?.volume
                }, 'speaker-changed')
                self.hook(BrightnessService, (self) => {
                  self.value = BrightnessService.bind('screen-value')['emitter']['screen-value']
                }, 'screen-changed')
              },
              hexpand: true,
              hpack: "center",
              class_name: "osd-prog",
            })
          ]
        }),
      ]
    }),
    attribute: { count: 0 },
    setup: self => {
      self.hook(Audio, (self) => {
        self.reveal_child = true
        self.attribute.count++
        Utils.timeout(4000, () => {
          self.attribute.count--
          if (self.attribute.count === 0) self.reveal_child = false
        })
      }, 'speaker-changed')
      self.hook(BrightnessService, (self) => {
        self.reveal_child = true
        self.attribute.count++
        Utils.timeout(4000, () => {
          self.attribute.count--
          if (self.attribute.count === 0) self.reveal_child = false
        })
      }, 'screen-changed')
    }
  })
})


const osd = Widget.Window({
  name: 'osd',
  anchor: ['top'],
  margins: [60, 10, 10, 10],
  child: revealer(),
})

export { osd }
