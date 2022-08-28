
local colors = {
  black        = '#0f0f0f',
  white        = '#dfdde0',
  red          = '#d08689',
  green        = '#9bcba8',
  blue         = '#7894b0',
  yellow       = '#d3b787',
  gray         = '#1e1f25',
  darkgray     = '#1a1a1d',
  lightgray    = '#ccc9c3',
  inactivegray = '#b9c1c1',
}
return {
  normal = {
    a = {bg = colors.blue, fg = colors.white, gui = 'bold'},
    b = {bg = colors.darkgray, fg = colors.white},
    c = {bg = colors.darkgray, fg = colors.blue}
  },
  insert = {
    a = {bg = colors.green, fg = colors.white, gui = 'bold'},
    b = {bg = colors.darkgray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.blue}
  },
  visual = {
    a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
    b = {bg = colors.darkgray, fg = colors.white},
    c = {bg = colors.black, fg = colors.white}
  },
  replace = {
    a = {bg = colors.red, fg = colors.black, gui = 'bold'},
    b = {bg = colors.gray, fg = colors.white},
    c = {bg = colors.black, fg = colors.white}
  },
  command = {
    a = {bg = colors.red, fg = colors.black, gui = 'bold'},
    b = {bg = colors.gray, fg = colors.white},
    c = {bg = colors.black, fg = colors.white}
  },
  inactive = {
    a = {bg = colors.darkgray, fg = colors.gray, gui = 'bold'},
    b = {bg = colors.darkgray, fg = colors.gray},
    c = {bg = colors.darkgray, fg = colors.gray}
  }
}
