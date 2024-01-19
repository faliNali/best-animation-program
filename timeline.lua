-- drawing quads
local frame_quad = love.graphics.newQuad(20, 15, 20, 16, IMAGEWIDTH, IMAGEHEIGHT)
local frameButtons_quad = {
  love.graphics.newQuad(40, 15, 12, 8, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(40, 23, 12, 8, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(40, 31, 12, 8, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(40, 39, 12, 8, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(40, 47, 12, 8, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(52, 15, 48, 32, IMAGEWIDTH, IMAGEHEIGHT)}
local scrollButtons_quad = {
  love.graphics.newQuad(20, 31, 6, 10, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(26, 31, 6, 10, IMAGEWIDTH, IMAGEHEIGHT)}
local tlButtons_quad = {
  love.graphics.newQuad(0, 25, 10, 10, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(0, 45, 10, 10, IMAGEWIDTH, IMAGEHEIGHT)}
local fpsButtons_quad = {
  love.graphics.newQuad(88, 47, 12, 8, IMAGEWIDTH, IMAGEHEIGHT),
  love.graphics.newQuad(88, 55, 12, 8, IMAGEWIDTH, IMAGEHEIGHT)}

-- timeline table
local tl = {}

---- INITIALIZE ----
function tl.init(x, y, width, height, frame)
  tl.x, tl.y = x, y
  tl.width = width
  tl.height = height
  tl.frames = {frame}
  tl.current = 1
  tl.onionFrames = {}
  tl.onionFrameDist = 0
  tl.isOnion = false
  tl.isPlaying = false
  tl.isLooping = false
  tl.fps = 12
  tl.frameTime = 1/tl.fps
  tl.frameTimer = tl.frameTime
end

---- GUI VARIABLES ----

-- frame containers
local frameXintDefault = 10
local frameXint = frameXintDefault
local frameYint = 15
local frameWidth = 25
local frameHeight = 20
local frameXDistance = frameWidth + 5
local frameDisplayStart = 1
local frameDisplayAmount = 6

-- frame display inside frame container
local framePreviewXint = 4
local framePreviewYint = 5

-- buttons used to scroll timeline
local scrollButXint = -6
local scrollButYint = frameYint
local scrollButWidth = 12
local scrollButHeight = 20
local scrollButXDistance = 195

-- text to show #frames and frames being shown
local textFramesXint = 10
local textShowingXint = 120
local textYint = 32

-- buttons used to modify frames
local frameButWidth = 12
local frameButHeight = 8
local frameButXDistance = frameButWidth + 2

-- timeline buttons
local tlButXint = 45
local tlButYint = 45
local tlButXDistance = 24
local tlButWidth = 20

-- fps display
local fpsXint = 180
local fpsYint = 50
-- fps box
local fpsBoxXint = 176
local fpsBoxYint = 52
local fpsBoxWidth = 40
local fpsBoxHeight = 13
-- fps button
local fpsButXint = 160
local fpsButYint = 50
local fpsButWidth = 12
local fpsButHeight = 8
local fpsButYDistance = 10

---- UPDATE ----
function tl.update(dt)
  if tl.isPlaying then
    if tl.current == #tl.frames then
      if tl.isLooping then
        tl.current = 1
      else
        tl.isPlaying = false
        tl.frameTimer = tl.frameTime
      end
    else
      tl.frameTimer = tl.frameTimer - dt
      if tl.frameTimer < 0 then
        tl.frameTimer = tl.frameTimer + tl.frameTime
        tl.current = tl.current + 1
      end
    end
  end
  
  if tl.current >= frameDisplayStart + frameDisplayAmount then
    frameDisplayStart = frameDisplayStart + 1
  elseif tl.current < frameDisplayStart then
    frameDisplayStart = tl.current
  end
end

---- DRAW ----
function tl.draw()
  
  -- draw frame containers
  for i, frame in ipairs(tl.frames) do
    if i >= frameDisplayStart and i < frameDisplayStart + frameDisplayAmount then
      if tl.current == i then
        drawBorder(tl.x + frameXint + frameXDistance*(i-frameDisplayStart), tl.y + frameYint, frameWidth, frameHeight, 1)
      end
      love.graphics.draw(IMAGE, frame_quad, tl.x + frameXint + frameXDistance*(i-frameDisplayStart), tl.y + frameYint, 0, 1.25, 1.25)
      drawTiles(tl.x + frameXint + framePreviewXint + frameXDistance*(i-frameDisplayStart), tl.y + frameYint + framePreviewYint, frame, 0.6, 0.6)
    end
  end
  
  -- draw frame buttons
  for i, quad in ipairs(frameButtons_quad) do
    local scaleX, scaleY = 1, 1
    -- if button is onionskin
    if i == 6 then
      scaleX, scaleY = 1/4, 1/4
      if tl.isOnion then
        drawBorder(tl.x + frameButXDistance*(i-1), tl.y, frameButWidth, frameButHeight, 1)
      end
    end
    love.graphics.draw(IMAGE, quad, tl.x + frameButXDistance*(i-1), tl.y, 0, scaleX, scaleY)
  end
  
  -- draw scroll buttons
  for i, quad in ipairs(scrollButtons_quad) do
    love.graphics.draw(IMAGE, quad, tl.x + scrollButXint + scrollButXDistance * (i-1), tl.y + scrollButYint, 0, 2, 2)
  end
  
  -- draw frame text
  love.graphics.print('frames:' .. tostring(#tl.frames),
                      tl.x + textFramesXint, tl.y + textYint)
  love.graphics.print('showing:' .. tostring(frameDisplayStart) .. '-' .. tostring(frameDisplayStart + frameDisplayAmount-1),
                      tl.x + textShowingXint, tl.y + textYint)
  
  -- draw timeline buttons
  for i, quad in ipairs(tlButtons_quad) do
    if (i == 1 and tl.isPlaying)  or (i == 2 and tl.isLooping) then
      drawBorder(tl.x+tlButXint + tlButXDistance*(i-1), tl.y + tlButYint, tlButWidth, tlButWidth, 2)
    end
    love.graphics.draw(IMAGE, quad, tl.x + tlButXint + tlButXDistance*(i-1), tl.y + tlButYint, 0, 2, 2)
  end
  
  -- draw fps
  love.graphics.setColor(0, 0, 1)
  drawBorder(tl.x + fpsBoxXint, tl.y + fpsBoxYint, fpsBoxWidth, fpsBoxHeight, 2)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('fill', tl.x + fpsBoxXint, tl.y + fpsBoxYint, fpsBoxWidth, fpsBoxHeight)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print('fps:' .. tostring(tl.fps), tl.x + fpsXint, tl.y + fpsYint)
  love.graphics.setColor(1, 1, 1)
  
  -- draw fps buttons
  for i, quad in ipairs(fpsButtons_quad) do
    love.graphics.draw(IMAGE, quad, tl.x + fpsButXint, tl.y + fpsButYint + fpsButYDistance*(i-1))
  end
end

---- MOUSEPRESSED ----
function tl.mousepressed(x, y, button, istouch, presses)
  -- timeline buttons
  for i = 0, #tlButtons_quad-1 do
    if insideArea(x, y, tl.x + tlButXint + tlButXDistance*i, tl.y + tlButYint, tlButWidth, tlButWidth) then
      if i == 0 then
        if tl.current == #tl.frames then
          tl.current = 1
        end
        tl.isPlaying = not tl.isPlaying
        tl.isOnion = false
      else
        tl.isLooping = not tl.isLooping
      end
    end
  end
  
  -- for when animation is not playing
  if not tl.isPlaying then
    -- functions for each frame button
    for i=0, #frameButtons_quad-1 do
      if insideArea(x, y, tl.x + frameButXDistance*i, tl.y, frameButWidth, frameButHeight) then
        if i == 0 then
          tl.newFrame()
        elseif i == 1 then
          tl.newFrame(tl.frames[tl.current])
        elseif i == 2 then
          tl.removeFrame(tl.current)
        elseif i == 3 then
          tl.switchFrames(tl.current, tl.current-1)
        elseif i == 4 then
          tl.switchFrames(tl.current, tl.current+1)
        elseif i == 5 then
          tl.isOnion = not tl.isOnion
          tl.onionFrameDist = 1
        end
      end
    end
    -- switch frames when pressed
    for i = 0, frameDisplayAmount-1 do
      if insideArea(x, y, tl.x + frameXint + frameXDistance*i, tl.y + frameYint, frameWidth, frameHeight) then
        if tl.frames[frameDisplayStart + i] then
          tl.current = frameDisplayStart + i
        end
      end
    end
    -- change frames shown when scroll buttons are pressed
    for i=0, 1 do
      if insideArea(x, y, tl.x + scrollButXint + scrollButXDistance*i, tl.y + scrollButYint, scrollButWidth, scrollButHeight) then
        if i == 0 then
          if frameDisplayStart > 1 then
            frameDisplayStart = frameDisplayStart - 1
          end
        else
          if (#tl.frames - frameDisplayStart + 1) > frameDisplayAmount then
            frameDisplayStart = frameDisplayStart + 1
          end
        end
      end
    end
    -- fps buttons
    for i=0, #fpsButtons_quad do
      if insideArea(x, y, tl.x + fpsButXint, tl.y + fpsButYint + fpsButYDistance*i, fpsButWidth, fpsButHeight) then
        if i == 0 then
          tl.fps = tl.fps + 1
        else
          tl.fps = tl.fps - 1
        end
        tl.frameTime = 1/tl.fps
        tl.frameTimer = tl.frameTime
      end
    end
    
    -- set onionskin
    tl.setOnionOnFrame(tl.onionFrameDist)
  end
end

---- TIMELINE FUNCTIONS

-- insert new frame into timeline
function tl.newFrame(frame)
  local newFrame = tl.current + 1
  if frame then
    table.insert(tl.frames, newFrame, copy(frame))
  else
    table.insert(tl.frames, newFrame, newGrid())
  end
  tl.current = newFrame
end

-- change frame
function tl.writeFrame(tiles, frameNum)
  if tl.frames[frameNum] then
    table.remove(tl.frames, frameNum)
  end
  table.insert(tl.frames, frameNum, tiles)
end

-- remove frame
function tl.removeFrame(frameNum)
  if #tl.frames > 1 then
    if tl.current == frameNum then
      if frameNum ~= 1 and not tl.frames[frameNum+1] then
        tl.current = tl.current - 1
      end
    end
    table.remove(tl.frames, frameNum)
  end
end

-- switches position of 2 frames
function tl.switchFrames(frameNum1, frameNum2)
  if tl.frames[frameNum1] and tl.frames[frameNum2] then
    local frameCopy1, frameCopy2 = copy(tl.frames[frameNum1]), copy(tl.frames[frameNum2])
    tl.frames[frameNum1], tl.frames[frameNum2] = frameCopy2, frameCopy1
    tl.current = frameNum2
  end
end

-- sets the frames to be onion skinned
function tl.setOnionOnFrame(frameDist)
  tl.onionFrames = {}
  for i = tl.current-frameDist, tl.current+frameDist do
    table.insert(tl.onionFrames, tl.frames[i])
  end
end

return tl