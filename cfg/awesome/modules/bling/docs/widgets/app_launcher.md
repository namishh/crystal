## 🎨 App Launcher <!-- {docsify-ignore} -->

A popup application launcher similar to Rofi

![](https://user-images.githubusercontent.com/33443763/140196352-07e444fe-cccd-45ad-93fa-5705f09e516b.png)

*image by [JavaCafe01](https://github.com/JavaCafe01)*

### Usage

To enable:

```lua
local app_launcher = bling.widget.app_launcher()
```

To run the app launcher, call `:toggle()` on the launcher.

```lua
app_launcher:toggle()
```

### Example Implementation:

```lua
local args = {
    apps_per_column = 1,
    sort_alphabetically = false,
    reverse_sort_alphabetically = true,
}
local app_launcher = bling.widget.app_launcher(args)
```

### Available Options:
```lua
local args = {
    terminal = "alacritty"                                            -- Set default terminal
    favorites = { "firefox", "wezterm" }                              -- Favorites are given priority and are bubbled to top of the list
    search_commands = true                                            -- Search by app name AND commandline command
    skip_names = { "Discord" }                                        -- List of apps to omit from launcher
    skip_commands = { "thunar" }                                      -- List of commandline commands to omit from launcher
    skip_empty_icons = true                                           -- Skip applications without icons
    sort_alphabetically = true                                        -- Sorts applications alphabetically
    reverse_sort_alphabetically = false                               -- Sort in reverse alphabetical order (NOTE: must set `sort_alphabetically = false` to take effect)
    select_before_spawn = true                                        -- When selecting by mouse, click once to select app, click once more to open the app.
    hide_on_left_clicked_outside = true                               -- Hide launcher on left click outside the launcher popup
    hide_on_right_clicked_outside = true                              -- Hide launcher on right click outside the launcher popup
    hide_on_launch = true                                             -- Hide launcher when spawning application
    try_to_keep_index_after_searching = false                         -- After a search, reselect the previously selected app
    reset_on_hide = true                                              -- When you hide the launcher, reset search query
    save_history = true                                               -- Save search history
    wrap_page_scrolling = true                                        -- Allow scrolling to wrap back to beginning/end of launcher list
    wrap_app_scrolling = true                                         -- Set app scrolling 

    default_app_icon_name = "standard.svg"                            -- Sets default app icon name for apps without icon names
    default_app_icon_path = "~/icons/"                                -- Sets default app icon path for apps without icon paths
    icon_theme = "application"                                        -- Set icon theme
    icon_size = 24                                                    -- Set icon size

    type = "dock"                                                     -- awful.popup type ("dock", "desktop", "normal"...).  See awesomewm docs for more detail
    show_on_focused_screen = true                                     -- Should app launcher show on currently focused screen
    screen = awful.screen                                             -- Screen you want the launcher to launch to
    placement = awful.placement.top_left                              -- Where launcher should be placed ("awful.placement.centered").
    rubato = { x = rubato_animation_x, y = rubato_animation_y }       -- Rubato animation to apply to launcher
    shrink_width = true                                               -- Automatically shrink width of launcher to fit varying numbers of apps in list (works on apps_per_column)
    shrink_height = true                                              -- Automatically shrink height of launcher to fit varying numbers of apps in list (works on apps_per_row)
    background = "#FFFFFF"                                            -- Set bg color
    shape = function(cr, width, height)
      gears.shape.rectangle(cr, width, height)
    end                                                               -- Set shape for launcher
    prompt_height = dpi(50)                                           -- Prompt height
    prompt_margins = dpi(30)                                          -- Prompt margins
    prompt_paddings = dpi(15)                                         -- Prompt padding
    shape = function(cr, width, height)
      gears.shape.rectangle(cr, width, height)
    end                                                               -- Set shape for prompt
    prompt_color = "#000000"                                          -- Prompt background color
    prompt_border_width = dpi(0)                                      -- Prompt border width
    prompt_border_color = "#000000"                                   -- Prompt border color
    prompt_text_halign = "center"                                     -- Prompt text horizontal alignment
    prompt_text_valign = "center"                                     -- Prompt text vertical alignment
    prompt_icon_text_spacing = dpi(10)                                -- Prompt icon text spacing
    prompt_show_icon = true                                           -- Should prompt show icon (?)
    prompt_icon_font = "Comic Sans"                                   -- Prompt icon font
    prompt_icon_color = "#000000"                                     -- Prompt icon color
    prompt_icon = ""                                                 -- Prompt icon
    prompt_icon_markup = string.format(
        "<span size='xx-large' foreground='%s'>%s</span>",
        args.prompt_icon_color, args.prompt_icon
    )                                                                 -- Prompt icon markup
    prompt_text = "<b>Search</b>:"                                    -- Prompt text
    prompt_start_text = "manager"                                     -- Set string for prompt to start with
    prompt_font = "Comic Sans"                                        -- Prompt font
    prompt_text_color = "#FFFFFF"                                     -- Prompt text color
    prompt_cursor_color = "#000000"                                   -- Prompt cursor color

    apps_per_row = 3                                                  -- Set how many apps should appear in each row
    apps_per_column = 3                                               -- Set how many apps should appear in each column
    apps_margin = {left = dpi(40), right = dpi(40), bottom = dpi(30)} -- Margin between apps
    apps_spacing = dpi(10)                                            -- Spacing between apps
    
    expand_apps = true                                                -- Should apps expand to fill width of launcher
    app_width = dpi(400)                                              -- Width of each app
    app_height = dpi(40)                                              -- Height of each app
    app_shape = function(cr, width, height)
      gears.shape.rectangle(cr, width, height)
    end                                                               -- Shape of each app
    app_normal_color = "#000000"                                      -- App normal color
    app_normal_hover_color = "#111111"                                -- App normal hover color 
    app_selected_color = "#FFFFFF"                                    -- App selected color
    app_selected_hover_color = "#EEEEEE"                              -- App selected hover color
    app_content_padding = dpi(10)                                     -- App content padding
    app_content_spacing = dpi(10)                                     -- App content spacing
    app_show_icon = true                                              -- Should show icon?
    app_icon_halign = "center"                                        -- App icon horizontal alignment
    app_icon_width = dpi(70)                                          -- App icon wigth
    app_icon_height = dpi(70)                                         -- App icon height
    app_show_name = true                                              -- Should show app name?
    app_name_generic_name_spacing = dpi(0)                            -- Generic name spacing (If show_generic_name)
    app_name_halign = "center"                                        -- App name horizontal alignment
    app_name_font = "Comic Sans"                                      -- App name font
    app_name_normal_color = "#FFFFFF"                                 -- App name normal color
    app_name_selected_color = "#000000"                               -- App name selected color
    app_show_generic_name = true                                      -- Should show generic app name?
}
```
