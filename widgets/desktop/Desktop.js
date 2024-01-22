import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { GLib } = imports.gi
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import { DesktopChange } from '../../variables.js';

const splitArrayIntoMatrix = (arr, a1, a2) => {
  const n = arr.length;
  const matrix = Array.from({ length: a1 }, () => Array(a2).fill(0));
  for (let i = 0; i < a1; i++) {
    for (let j = 0; j < a2; j++) {
      const index = i * a2 + j;
      if (index < n) {
        matrix[i][j] = arr[index];
      }
    }
  }
  return matrix;
}


const languageTocode = {
  "js": "javascript", "py": "python", "rs": "rust", "hs": 'haskell', "ts": "typescript"
}

const languauges = ["js", "py", "java", "cpp", "rb", "cs", "swift", "ts", "php", "go", "kt", "rs", "m", "scala", "dart", "sh", "html", "css", "sql", "r", "matlab", "groovy", "pl", "hs", "lua",]

const generateDesktops = (self) => {
  const stuff = [{ name: "Trash", onclick: "nemo trash://", icon: "trashcan_empty", type: "other" }]
  const echo = Utils.execAsync('bash -c "ls ~/Desktop/"').then(res => {
    res = res.split("\n")
    res.forEach(element => {
      const dircheck = Utils.exec(`bash -c "cd ~/Desktop/${element}; echo $?"`)
      if (dircheck == 1) {
        const ext = element.split(".")[element.split(".").length - 1]
        let icon = "application-x-zerosize"
        let onclick = ""
        if (languauges.indexOf(ext) > -1) {
          icon = `text-x-${languageTocode[ext]}`
          onclick = `wezterm start --always-new-process -e sh -c "nvim ~/Desktop/${element}; zsh"`
        } else if (["tiff", "jpg", "png", "webp", "jpeg"].indexOf(ext) > -1) {
          icon = `media-image`
          onclick = `feh ~/Desktop/${element}`
        } else if (["mp4", "mp3", "mkv"].indexOf(ext) > -1) {
          icon = `media-video`
          onclick = `mpv ~/Desktop/${element}`
        } else if (ext == "desktop") {
          const contents = Utils.readFile(`${GLib.get_home_dir()}/Desktop/${element}`)
          const properties = contents.split("\n")
          icon = properties.filter(s => s.includes('Icon'))[0];
          icon = icon.split("=")[icon.split("=").length - 1]
          onclick = properties.filter(s => s.includes('Exec'))[0];
          onclick = icon.split("=")[icon.split("=").length - 1]
        } else {
          onclick = `wezterm start --always-new-process -e sh -c "nvim ~/Desktop/${element}; zsh"`
        }
        stuff.push({ name: element, onclick: onclick, icon: icon, type: "file" })
      } else {
        stuff.push({ name: element, onclick: `nemo Desktop/${element}`, icon: 'folder', type: "folder" })
      }
    });
    const icons = splitArrayIntoMatrix(stuff, 10, 10)
    self.children = icons.map(row => Widget.Box({
      class_name: "desktop-row",
      spacing: 12,
      homogeneous: true,
      children: [
        Widget.Box({
          vertical: true,
          spacing: 12,
          setup: (self) => {
            self.children = row.map(r => r && Widget.Button({
              on_clicked: () => {
                Utils.execAsync(r.onclick)
              },
              child: Widget.Box({
                class_name: "desktop-icon",
                vertical: true,
                spacing: 5,
                children: [
                  Widget.Icon({
                    size: 45,
                    icon: r.icon
                  }),
                  Widget.Label({
                    label: r.name,
                    truncate: 'end',
                  })
                ]
              })
            })
            )
          }
        })
      ]
    }))
  }).catch(e => print)
}


const Desktop = () => Widget.Box({
  class_name: "desktop",
  css: 'min-height: 2px;min-width: 5px;',
  children: [],
  setup: (self) => {
    self.hook(DesktopChange, (self) => {
      generateDesktops(self)
    })
  }
})

const desktop = Widget.Window({
  name: 'desktop',
  layer: "bottom",
  visible: true,
  anchor: ['top', 'left'],
  margins: [20, 20],
  child: Desktop(),
})

export { desktop }
