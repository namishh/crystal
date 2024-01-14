import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Brightness } from "../../../variables.js"

const Slider = (label, on_change, setup, min = 0, max = 100) => Widget.Box({
  spacing: 10,
  class_name: "ps",
  homogeneous: false,
  vertical: true,
  children: [
    Widget.Label({
      class_name: "panel-slider-label",
      label: label,
      hpack: "start"
    })
    ,
    Widget.Slider({
      setup,
      min,
      max,
      value: 0,
      on_change,
      drawValue: false,
      class_name: "panel-slider",
    })
  ],
})

export default () => Widget.Box({
  spacing: 20,
  class_name: "panel-sliders",
  homogeneous: false,
  vertical: true,
  children: [
    Slider("Volume", ({ value }) => {
      Audio['speaker'].volume = value
    }, (self) => {
      self.hook(Audio, (self) => {
        self.value = Audio.speaker?.volume
      }, 'speaker-changed')
    }, 0, 1),

    Slider("Brightness", ({ value }) => {
      Utils.execAsync(`brightnessctl s ${value}`)
    }, (self) => {
      self.hook(Brightness, (self) => {
        self.value = Brightness.value
      })
    }, 0, 255),
  ]
})
