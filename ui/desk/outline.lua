local cairo = require('lgi').cairo
local function cairo_text_extents(font, font_size, text, _)
  local surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, 0, 0)
  local cr = cairo.Context(surface)
  cr:select_font_face(font, cairo.FontSlant.NORMAL, cairo.FontWeight.BOLD)
  cr:set_font_size(font_size)
  cr:set_antialias(cairo.Antialias.BEST)
  return cr:text_extents(text)
end

local function split_string(str, max_width)
  local line1 = ''
  local line2 = ''
  local line1_width = 0
  local line2_width = 0
  local font = 'Iosevka Nerd Font'
  local font_size = 14
  local font_args = { cairo.FontSlant.NORMAL, cairo.FontWeight.NORMAL }

  for word in str:gmatch('%S+') do
    local word_width = cairo_text_extents(font, font_size, word, font_args).width
    if line1_width + word_width < max_width then
      line1 = line1 .. word .. ' '
      line1_width = line1_width + word_width
    else
      line2 = line2 .. word .. ' '
      line2_width = line2_width + word_width
    end
  end

  return line1, line2
end

local function outlined_text(text, max_width)
  local font = 'Iosevka Nerd Font'
  local font_size = 14
  local spacing = 100
  local margin = 1
  max_width = max_width - (margin * 2)
  local shadow_offset_x, shadow_offset_y = 1, 1
  local font_args = { cairo.FontSlant.NORMAL, cairo.FontWeight.NORMAL }

  -- Get the dimensions from the text
  local extents = cairo_text_extents(font, font_size, text, font_args)

  -- if its bigger it needs special treatment
  if extents.width > max_width then
    local line1, line2 = split_string(text, max_width)

    -- Get the dimensions for both lines
    local extents1 = cairo_text_extents(font, font_size, line1, font_args)
    local extents2 = cairo_text_extents(font, font_size, line2, font_args)

    -- The surface width will be the biggest of the two lines
    local s_width = extents1.width
    if extents1.width < extents2.width then
      s_width = extents2.width
    end

    -- Create a new surface based on the widest line, and both line's height + the spacing between them and the shadow offset
    local surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, s_width + shadow_offset_x,
      extents1.height + extents2.height + spacing + (shadow_offset_y * 3))
    local cr = cairo.Context(surface)

    -- Create the font with best antialias
    cr:select_font_face(font, cairo.FontSlant.NORMAL, cairo.FontWeight.BOLD)
    cr:set_font_size(font_size)
    cr:set_antialias(cairo.Antialias.BEST)

    -- To center both lines get the surface center then substract half the line width
    local text_x = s_width / 2 - ((extents1.width) / 2)
    local text_x2 = s_width / 2 - ((extents2.width) / 2)

    -- This makes the first text to be blow the main text
    cr:set_operator(cairo.Operator.OVER)

    -- Draw the text shadow
    cr:move_to(text_x + shadow_offset_x, -extents1.y_bearing + shadow_offset_y)
    cr:set_source_rgba(0, 0, 0, 0.5)
    cr:show_text(line1)

    cr:set_operator(cairo.Operator.OVER)

    -- Draw the second shadow
    cr:move_to(text_x2 + shadow_offset_x, extents1.height + extents2.height + spacing + shadow_offset_y)
    cr:set_source_rgba(0, 0, 0, 0.5)
    cr:show_text(line2)

    -- Draw the first and second line
    cr:move_to(text_x, -extents1.y_bearing)
    cr:set_source_rgb(1, 1, 1)
    cr:text_path(line1)
    cr:move_to(text_x2, extents1.height + extents2.height + spacing)
    cr:text_path(line2)

    -- Color it and set the stroke
    cr:fill_preserve()
    cr:set_source_rgb(0, 0, 0)
    cr:set_line_width(0.19)
    cr:stroke()

    return surface, { width = extents.width, height = extents1.height + extents2.height + spacing }
  else
    -- The size is the dimension from above the if
    local surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, extents.width, extents.height + shadow_offset_y)
    local cr = cairo.Context(surface)

    -- Set the font, then draw the text and its stroke
    cr:select_font_face(font, cairo.FontSlant.NORMAL, cairo.FontWeight.NORMAL)
    cr:set_font_size(font_size)

    -- This makes the first text to be blow the main text
    cr:set_operator(cairo.Operator.OVER)

    -- Draw the text shadow
    cr:move_to( -extents.x_bearing + shadow_offset_x, -extents.y_bearing + shadow_offset_y)
    cr:set_source_rgba(0, 0, 0, 0.5)
    cr:show_text(text)

    cr:move_to( -extents.x_bearing, -extents.y_bearing)
    cr:set_source_rgb(1, 1, 1)
    cr:text_path(text)
    cr:fill_preserve()
    cr:set_source_rgb(0, 0, 0)
    cr:set_line_width(0.1)
    cr:stroke()
    return surface, { width = extents.width, height = extents.height }
  end
end

return outlined_text
