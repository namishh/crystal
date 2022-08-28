local colors = {
  black        = '#0a1011',
  white        = '#d7e0e0',
  red          = '#df5b61',
  green        = '#6ec587',
  blue         = '#659bdb',
  yellow       = '#deb26a',
  gray         = '#0d1617',
  darkgray     = '#121b1c',
  lightgray    = '#c5d7d7',
  inactivegray = '#cedcd9',
}
return {
  normal = {
    a = {bg = colors.blue, fg = colors.white, gui = 'bold'},
    b = {bg = colors.gray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.blue}
  },
  insert = {
    a = {bg = colors.green, fg = colors.white, gui = 'bold'},
    b = {bg = colors.gray, fg = colors.white},
    c = {bg = colors.gray, fg = colors.blue}
  },
  visual = {
    a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
    b = {bg = colors.gray, fg = colors.white},
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
