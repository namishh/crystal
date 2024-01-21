import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

import { bar } from "./widgets/bar/Bar.js"
import { launcher } from './widgets/launcher/Launcher.js'
import { panel } from "./widgets/panel/Panel.js"

import { calendarbox } from "./widgets/calendar/Calendar.js"
import { osd } from './widgets/popups/Osd.js'

import { time } from './widgets/time/Time.js'
import { dock } from './widgets/dock/Dock.js'
import { wifimenu } from './widgets/popups/Wifi.js'
import { bluetoothmenu } from './widgets/popups/Bluetooth.js'

let loadCSS = () => {
  const scss = `${App.configDir}/style/_style.scss`

  // target css file
  const css = `${App.configDir}/finalcss/style.css`

  // make sure sassc is installed on your system
  Utils.exec(`sassc ${scss} ${css}`)

  App.resetCss() // reset if need
  App.applyCss(`${App.configDir}/finalcss/style.css`)
}

loadCSS()

Utils.monitorFile(
  `${App.configDir}/style/`,
  function() {
    loadCSS()
  },
  'directory',
)

export default { windows: [bar, launcher, panel, calendarbox, osd, time, wifimenu, bluetoothmenu], style: `${App.configDir}/finalcss/style.css` }
