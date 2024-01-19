---- GUI VARIABLES ----
local boxSize = 15
local boxScale = 2
local boxDist = 40
local iconBoxDist = 4

-- drawing quads
local box_quad = love.graphics.newQuad(0, 0, boxSize, boxSize, IMAGEWIDTH, IMAGEHEIGHT)
local icons_quad = {
  love.graphics.newQuad(15, 0, boxSize-iconBoxDist, boxSize-iconBoxDist, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(26, 0, boxSize-iconBoxDist, boxSize-iconBoxDist, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(37, 0, boxSize-iconBoxDist, boxSize-iconBoxDist, IMAGEWIDTH, IMAGEHEIGHT)}

-- toolbar table
local toolbar = {}

---- INITIALIZE
function toolbar.init(toolNumber, x, y)
  -- brush=0, eyedropper=1, erase=2
  toolbar.current = toolNumber

  toolbar.x = x
  toolbar.y = y
  toolbar.eraseTriggered = false
end

function toolbar.draw()
  -- draw tools
  for i = 0, 2 do
    love.graphics.draw(IMAGE, box_quad,
                       toolbar.x, toolbar.y + i*boxDist,
                       0, boxScale, boxScale)
    love.graphics.draw(IMAGE, icons_quad[i+1],
                       toolbar.x+iconBoxDist, toolbar.y+iconBoxDist + i*boxDist,
                       0, boxScale, boxScale)
    -- make current tool brighter
    if toolbar.current == i then
      love.graphics.setColor(1, 1, 1, 0.3)
      love.graphics.rectangle('fill', toolbar.x, toolbar.y + i*boxDist, boxSize*2, boxSize*2)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end

function toolbar.mousepressed(x, y, button, istouch, presses)
  for tool = 0, 2 do
    -- check if tools are clicked
    if insideBoxArea(x, y, tool) then
      if tool == 2 then
        toolbar.eraseTriggered = true
      else
        toolbar.current = tool
      end
    end
  end
end

-- check if position is inside tool button
function insideBoxArea(x, y, tool)
  return insideArea(x, y, toolbar.x, toolbar.y + boxDist*tool, boxSize*boxScale, boxSize*boxScale)
end

return toolbar