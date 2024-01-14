import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import { bar } from "./widgets/bar/Bar.js"
import { launcher } from './widgets/launcher/Launcher.js'
import { panel } from "./widgets/panel/Panel.js"

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



export default { windows: [bar, launcher, panel], style: `${App.configDir}/finalcss/style.css` }
