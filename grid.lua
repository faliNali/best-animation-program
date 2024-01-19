-- other guis that interact with grid
local toolbar = require 'toolbar'
local colorHud = require 'color'
local timeline = require 'timeline'

-- grid table
local grid = {}
-- table for storing pixels for drawing
grid.tiles = {}

---- INITIALIZE ----
function grid.init(x, y, width, height, scale, transColor)
  -- initialize other guis
  toolbar.init(0, x - 36, y + 5)
  colorHud.init({r = 0, g = 0, b = 0}, {r = 1, g = 1, b = 1},
                x + 160, y)
  
  -- grid variables
  grid.x = x
  grid.y = y
  grid.width = width
  grid.height = height
  grid.scale = scale
  grid.transparentColor = transColor
  
  -- creates the grid's tiles and initializes timeline, which requires grid tiles
  grid.tiles = newGrid()
  timeline.init(x, y + 105, width, height, grid.tiles)
end

---- UPDATE
function grid.update(dt)
  -- update timeline
  timeline.update(dt)
  
  -- check if mouse is down
  if love.mouse.isDown(1, 2) then
    if not timeline.isPlaying then
      for i, tile in ipairs(grid.tiles) do
        local mouseX, mouseY = love.mouse.getPosition()
        if isOverTile(mouseX/SCALE, mouseY/SCALE, tile)then
          -- brush tool
          if toolbar.current == 0 then
            if love.mouse.isDown(1) then
              tile.color = colorHud.color[colorHud.selectedColor]
            else
              if colorHud.selectedColor == 1 then
                tile.color = colorHud.color[2]
              else
                tile.color = colorHud.color[1]
              end
            end
          -- colorpicker tool
          elseif toolbar.current == 1 then
            colorHud.color[colorHud.selectedColor] = tile.color
          end
        end
      end
    end
  end
  -- grid interaction with timeline
  grid.tiles = timeline.frames[timeline.current]
  timeline.writeFrame(grid.tiles, timeline.current)
  
  -- check if erase tool has been pressed
  if not timeline.isPlaying then
    if toolbar.eraseTriggered then
      toolbar.eraseTriggered = false
      for i, tile in ipairs(grid.tiles) do
        tile.color = {r=1, g=1, b=1}
      end
    end
  end
end

---- DRAW ----
function grid.draw()
  -- draw guis
  toolbar.draw()
  colorHud.draw()
  timeline.draw()
  
  -- draw grid
  love.graphics.setColor(0, 0, 0.6)
  drawBorder(grid.x, grid.y, grid.width*grid.scale, grid.height*grid.scale, 2)
  drawTiles(grid.x, grid.y, grid.tiles, grid.scale, grid.scale)
  -- draw onionskin
  if timeline.isOnion then
    for i, of in ipairs(timeline.onionFrames) do
      drawTiles(grid.x, grid.y, of, grid.scale, grid.scale, grid.transparentColor, 0.2)
    end
  end
end

---- MOUSEPRESSED ----
function grid.mousepressed(x, y, button, istouch, presses)
  toolbar.mousepressed(x, y, button, istouch, presses)
  colorHud.mousepressed(x, y, button, istouch, presses)
  timeline.mousepressed(x, y, button, istouch, presses)
end

---- LOCAL FUNCTIONS ----

-- gets the position of a grid tile as displayed on the screen
function getTilePos(tile)
  return grid.x + tile.x*grid.scale - grid.scale, grid.y + tile.y*grid.scale - grid.scale
end

-- check if position is over a tile
function isOverTile(x, y, tile)
  local tileX, tileY = getTilePos(tile)
  return x >= tileX and x < tileX + grid.scale and y >= tileY and y < tileY + grid.scale
end

-- draw the colored tiles on the grid
function drawTiles(x, y, tiles, scaleX, scaleY, transColor, tileAlpha)
  for i, tile in ipairs(tiles) do
    -- set alpha of tile
    local alpha = 1
    if tileAlpha then
      alpha = tileAlpha
    end
    -- make a certain color tile be transparent
    if transColor then
      if tile.color.r == transColor.r and tile.color.g == transColor.g and tile.color.b == transColor.b then
        alpha = 0
      end
    end
    
    -- draw the colored tile
    love.graphics.setColor(tile.color.r, tile.color.g, tile.color.b, alpha)
    love.graphics.rectangle('fill',
                            x + tile.x*scaleX-scaleX, y + tile.y*scaleY-scaleY,
                            scaleX, scaleY)
    love.graphics.setColor(1, 1, 1)
  end
end

-- sets grid table to store tiles
function newGrid()
  local new = {}
  for gx = 1, grid.width do
    for gy = 1, grid.height do
      local tile = {x = gx, y = gy,
                    color = {r = 1, g = 1, b = 1}}
      table.insert(new, tile)
    end
  end
  return new
end

return grid