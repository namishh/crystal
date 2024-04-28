--- Tag layouts.
-- Appends all layouts defined in `config/user.lua` to all tags.
tag.connect_signal('request::default_layouts', function()
   require('awful').layout.append_default_layouts(require('config.user').layouts)
end)
