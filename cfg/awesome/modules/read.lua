-- simple file read / writer
-- checks if the file exits
-- if it doesn't, then
-- returns "none" or false

-- author: saimoomedits


local file_reader     = {}

local gfs             = require("gears.filesystem")
local information_dir = gfs.get_configuration_dir() .. "/misc/info/"

-- Return true if file exists and is readable.
local check_exits     = function(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end



-- Read an entire file.
file_reader.readall = function(filename)
  if check_exits(information_dir .. filename) then
    local fh = assert(io.open(information_dir .. filename, "rb"))
    local infor = assert(fh:read("*a"))
    fh:close()
    print(infor)
    return tostring(infor:gsub("%s+", ""))
  else
    return "not found"
  end
end


-- Write a string to a file.
file_reader.write = function(filename, contents)
  if check_exits(information_dir .. filename) then
    local fh = assert(io.open(information_dir .. filename, "wb"))
    fh:write(contents)
    fh:flush()
    fh:close()
  end
end


return file_reader
