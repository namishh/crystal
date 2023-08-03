local awful = require("awful")

return function(name, dir)
  local ext = name:match("^.+(%..+)$")
  local i
  local fn
  local finalName = name

  if ext == '.mp4' or ext == ".avi" or ext == ".mkv" then
    i = 'mimes/scalable/video.svg'
    fn = 'mpv ' .. dir .. name
  elseif ext == '.jpg' or ext == '.jpeg' or ext == '.png' or ext == '.tiff' or ext == ".webm" then
    i = "mimes/scalable/application-images.svg"
    fn = 'feh ' .. dir .. name
  elseif ext == '.docx' or ext == '.doc' or ext == '.gdoc' then
    i = "mimes/scalable/application-msword.svg"
  elseif ext == '.pptx' or ext == '.ppt' then
    i = "mimes/scalable/application-mspowerpoint.svg"
  elseif ext == '.xlsx' or ext == '.xls' then
    i = "mimes/scalable/application-msexcel.svg"
  elseif ext == '.mp3' then
    i = "mimes/scalable/music.svg"
    fn = 'mpv ' .. dir .. name
  elseif ext == '.7z' or ext == ".zip" or ext == ".gz" or ext == ".xz" then
    i = "mimes/scalable/zip.svg"
    fn = 'xarchiver ' .. dir .. name
  elseif ext == '.c' then
    i = "mimes/scalable/text-c.svg"
    fn = 'wezterm -e nvim ' .. dir .. name
  elseif ext == '.py' then
    i = "mimes/scalable/text-x-python.svg"
    fn = 'wezterm -e nvim ' .. dir .. name
  elseif ext == '.js' then
    i = "mimes/scalable/text-javascript.svg"
    fn = 'wezterm -e nvim ' .. dir .. name
  elseif ext == '.hs' then
    fn = 'wezterm -e nvim ' .. dir .. name
    i = "mimes/scalable/text-x-haskell.svg"
  elseif ext == '.lua' then
    fn = 'wezterm -e nvim ' .. dir .. name
    i = "mimes/scalable/text-x-lua.svg"
  elseif ext == '.md' then
    fn = 'wezterm -e nvim ' .. dir .. name
    i = "mimes/scalable/text-x-markdown.svg"
  else
    i = "mimes/scalable/txt.svg"
  end
  return { icon = i or '', fn = fn, n = finalName }
end
