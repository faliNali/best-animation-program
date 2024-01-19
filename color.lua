-- drawing quads
local albutMinus_quad = love.graphics.newQuad(0, 15, 6, 10, IMAGEWIDTH, IMAGEHEIGHT)
local albutPlus_quad = love.graphics.newQuad(6, 15, 6, 10, IMAGEWIDTH, IMAGEHEIGHT)
local scButton_quad = love.graphics.newQuad(12, 15, 8, 5, IMAGEWIDTH, IMAGEHEIGHT)

-- colorhud table
local colorHud = {}
-- gui table
local gui = {}
-- alpha table for changing alphas
local alphas = {}
local alphaMax
-- saved colors to be used again
colorHud.savedColors = {}
local savedColorMax

---- INITIALIZE ----
function colorHud.init(color1, color2, x, y)
  colorHud.color = {color1, color2}
  colorHud.selectedColor = 1
  
  colorHud.x, colorHud.y = x, y
  
  alphas = {
  {display = {1, 0, 0}, level = 0, name = 'red'},
  {display = {0, 1, 0}, level = 0, name = 'green'},
  {display = {0, 0, 1}, level = 0, name = 'blue'}}
  alphaMax = 2
  
  savedColorMax = 6
  for i = 1, savedColorMax do
    table.insert(colorHud.savedColors, {r=1, g=1, b=1})
  end
  
  ---- GUI VARIABLES ----
  -- color displays
  gui.colorDis = {}
  gui.colorDis.x = 1+x
  gui.colorDis.y = y
  gui.colorDis.width = 25
  gui.colorDis.height = gui.colorDis.width
  gui.colorDis.xdistance = gui.colorDis.width + 5
  -- alphas
  gui.alphaDis = {}
  gui.alphaDis.x = x
  gui.alphaDis.y = 30+y
  gui.alphaDis.width = 45
  gui.alphaDis.height = 10
  gui.alphaDis.ydistance = 15
  -- bars used to show alpha values
  gui.alphaBar = {}
  gui.alphaBar.width = 4
  gui.alphaBar.height = 12
  gui.alphaBar.moveXdistance = gui.alphaDis.width / alphaMax
  -- buttons to change alpha values
  gui.alphaBut = {}
  gui.alphaBut.width = 6
  gui.alphaBut.height = 10
  gui.alphaBut.plus = {}
  gui.alphaBut.plus.x = gui.alphaDis.width+2 + x
  gui.alphaBut.plus.y = y
  gui.alphaBut.minus = {}
  gui.alphaBut.minus.x = gui.alphaBut.plus.x + gui.alphaBut.width+1
  gui.alphaBut.minus.y = y
  gui.alphaBut.ydistance = gui.alphaDis.ydistance
  -- saved colors
  gui.sColor = {}
  gui.sColor.x = x
  gui.sColor.y = 75+y
  gui.sColor.xdistance = 10
  gui.sColor.width = 8
  gui.sColor.height = gui.sColor.width
  -- button used to save colors
  gui.scBut = {}
  gui.scBut.x = x
  gui.scBut.y = 85+y
  gui.scBut.width = 16
  gui.scBut.height = 10
end

---- DRAW ----
function colorHud.draw()
  -- draw color displays
  for i = 1, 2 do
    local color = colorHud.color[i]
    local x = gui.colorDis.x + gui.colorDis.xdistance*(i-1)
    local y = gui.colorDis.y
    local width = gui.colorDis.width
    local height = gui.colorDis.height
    
    if i == colorHud.selectedColor then
      drawBorder(x, y, width, height, 2)
    end
    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.rectangle('fill', x, y, width, height)
    love.graphics.setColor(1, 1, 1)
  end
  
  for i = 1, #alphas do
    local alpha = {}
    alpha.x = gui.alphaDis.x
    alpha.y = gui.alphaDis.y + gui.alphaDis.ydistance*(i-1)
    alpha.width = gui.alphaDis.width
    alpha.height = gui.alphaDis.height
    
    -- draw alphas
    love.graphics.setColor(alphas[i].display[1], alphas[i].display[2], alphas[i].display[3])
    love.graphics.rectangle('fill', alpha.x, alpha.y, alpha.width, alpha.height)
    
    -- draw alpha bars
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', alpha.x - gui.alphaBar.width/2 + gui.alphaBar.moveXdistance*alphas[i].level, alpha.y - 1, gui.alphaBar.width, gui.alphaBar.height)
    
    -- draw alpha buttons
    love.graphics.draw(IMAGE, albutMinus_quad, gui.alphaBut.plus.x, alpha.y)
    love.graphics.draw(IMAGE, albutPlus_quad, gui.alphaBut.minus.x, alpha.y)
  end
  
  -- draw saved colors
  for i = 1, savedColorMax do
    local sc = colorHud.savedColors[i]
    love.graphics.setColor(sc.r, sc.g, sc.b)
    love.graphics.rectangle('fill', gui.sColor.x + gui.sColor.xdistance * (i-1), gui.sColor.y, gui.sColor.width, gui.sColor.height)
    love.graphics.setColor(1, 1, 1)
  end
  
  -- draw save color button
  love.graphics.draw(IMAGE, scButton_quad, gui.scBut.x, gui.scBut.y, 0, 2, 2)
end

function colorHud.mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    -- change alpha levels
    for i = 1, #alphas do
      local levelChange = 0
      if insideArea(x, y, gui.alphaBut.plus.x, gui.alphaDis.y + gui.alphaDis.ydistance*(i-1), gui.alphaBut.width, gui.alphaBut.height) then
        levelChange = -1
      elseif insideArea(x, y, gui.alphaBut.minus.x, gui.alphaDis.y + gui.alphaDis.ydistance*(i-1), gui.alphaBut.width, gui.alphaBut.height) then
        levelChange = 1
      end
      if levelChange ~= 0 then
        alphas[i].level = alphas[i].level + levelChange
        if alphas[i].level < 0 then alphas[i].level = 0
        elseif alphas[i].level > alphaMax then alphas[i].level = alphaMax end
        colorHud.color[colorHud.selectedColor] = levelsToColor()
      end
    end
    -- change selected color
    for i = 1, 2 do
      if insideArea(x, y, gui.colorDis.x + gui.colorDis.xdistance*(i-1), colorHud.y, gui.colorDis.width, gui.colorDis.height) then
        colorHud.selectedColor = i
      end
    end
    if insideArea(x, y, gui.scBut.x, gui.scBut.y, gui.scBut.width, gui.scBut.height) then
      newSavedColor(colorHud.color[colorHud.selectedColor])
    end
    for i = 1, savedColorMax do
      if insideArea(x, y, gui.sColor.x + gui.sColor.xdistance * (i-1), gui.sColor.y, gui.sColor.width, gui.sColor.height) then
        colorHud.color[colorHud.selectedColor] = colorHud.savedColors[i]
      end
    end
  end
end

function levelToAlpha(level)
  return level / alphaMax
end

function levelsToColor()
  local newColor = {}
  
  for i, alpha in ipairs(alphas) do
    if alpha.name == 'red' then
      newColor.r = levelToAlpha(alpha.level)
    elseif alpha.name == 'green' then
      newColor.g = levelToAlpha(alpha.level)
    elseif alpha.name == 'blue' then
      newColor.b = levelToAlpha(alpha.level)
    end
  end
  return newColor
end

function newSavedColor(color)
  table.insert(colorHud.savedColors, 1, color)
  table.remove(colorHud.savedColors, #colorHud.savedColors)
end

return colorHud