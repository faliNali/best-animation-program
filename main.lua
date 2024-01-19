-- local variables
local grid

---- LOAD ----
function love.load()
  -- background color
  love.graphics.setBackgroundColor(1, 0.8, 0.9)
  -- pixel filter
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  -- image variables
  IMAGE = love.graphics.newImage('images/hud.png')
  IMAGEWIDTH, IMAGEHEIGHT = IMAGE:getWidth(), IMAGE:getHeight()
  
  -- scale of pixels
  SCALE = 3
  
  -- default font for printing on screen
  local pixFont = love.graphics.newFont('fonts/000webfont.ttf', 16)
  love.graphics.setFont(pixFont)
  
  -- set grid for drawing, grid will also contain all other gui
  grid = require('grid')
  grid.init(43, 20, 30, 20, 5, {r=1, g=1, b=1})
end

---- UPDATE ----
function love.update(dt)
  grid.update(dt)
end

---- DRAW ----
function love.draw()
  -- scale the pixels
  love.graphics.scale(SCALE, SCALE)
  -- title on corner
  love.graphics.print('BEST ANIMATION PROGRAM', 1, -5)
  -- draws gui
  grid.draw()
end

---- MOUSEPRESSED ----
function love.mousepressed(x, y, button, istouch, presses)
  x, y = x/SCALE, y/SCALE
  grid.mousepressed(x, y, button, istouch, presses)
end

---- GLOBAL FUNCTIONS ----

-- check if a point is inside an area
function insideArea(x1, y1, x2, y2, w2, h2)
  return x1 >= x2 and x1 <= x2 + w2 and y1 >= y2 and y1 <= y2 + h2
end

-- draws a rectangle larger than another area, drawn before the area to make a border
function drawBorder(x, y, w, h, borderSize)
  love.graphics.rectangle('fill', x - borderSize, y - borderSize, w + borderSize*2, h + borderSize*2)
end

-- copies an object, can be used to change the values of a variable without changing the original
function copy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[copy(k)] = copy(v) end
    return res
end